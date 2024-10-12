import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/model/funding_model.dart';
import 'package:pophub/model/fundingitem_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/utils/utils.dart';

import '../../utils/api/funding_api.dart';

class FundingAddPage extends StatefulWidget {
  final String mode;

  const FundingAddPage({
    super.key,
    this.mode = "add",
  });

  @override
  _FundingAddPageState createState() => _FundingAddPageState();
}

class _FundingAddPageState extends State<FundingAddPage> {
  var countFomat = NumberFormat('###,###,###,###');
  List<CategoryModel> category = [];
  List<Map<String, dynamic>> fundingItem = [];
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      startDate = DateTime.now();
      endDate = DateTime.now();
    });
  }

  final ImagePicker _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  List images = [];
  List itemImages = [];

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _itemTitleController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  CategoryModel? selectedCategory;
  Future<void> _submitFunding() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _targetAmountController.text.isEmpty ||
        fundingItem.isEmpty ||
        images == []) {
      showAlert(context, ('error').tr(),
          ('complete_all_fields_and_add_your_funding_item').tr(), () {
        Navigator.pop(context);
      });
      return;
    }
    // 날짜 유효성 검사: startDate와 endDate가 7일 이상 차이가 나는지 확인
    if (startDate == null || endDate == null) {
      showAlert(context, ('error').tr(),
          ('select_your_funding_start_and_end_date').tr(), () {
        Navigator.pop(context);
      });
      return;
    }

    Duration dateDifference = endDate!.difference(startDate!);
    if (dateDifference.inDays < 7) {
      showAlert(context, ('error').tr(),
          ('the_funding_period_must_be_at_least_7_days').tr(), () {
        Navigator.pop(context);
      });
      return;
    }

    // 펀딩 모델 생성
    FundingModel funding = FundingModel(
      title: _titleController.text,
      content: _descriptionController.text,
      amount: int.parse(_targetAmountController.text),
      openDate: startDate.toString(),
      closeDate: endDate.toString(),
      images: images,
    );

    // 펀딩 추가 API 호출
    final result = await FundingApi.postFundingAdd(funding);
    print('result : $result');
    if (result.toString().contains("fail")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(('funding_failed_to_register').tr()),
        ),
      );
    } else {
      for (int index = 0; index < (fundingItem.length); index++) {
        // _submitItem(fundingItem[index], result.toString());
        _submitItem(fundingItem[index], result['data']);
      }

      showAlert(context, ('success').tr(),
          ('funding_has_been_successfully_registered').tr(), () {
        Navigator.pop(context); // 페이지 닫기
        Navigator.pop(context);
      });
    }
  }

  Future<void> _submitItem(Map<String, dynamic> items, String fundingId) async {
    // 펀딩 모델 생성
    FundingItemModel item = FundingItemModel(
      fundingId: fundingId,
      userName: User().userName,
      itemName: items['title'],
      content: items['description'],
      count: items['limit'],
      amount: items['price'],
      openDate: startDate.toString(),
      closeDate: endDate.toString(),
      paymentDate: endDate.toString(),
      images: items['image'],
    );

    // 펀딩 추가 API 호출
    final result = await FundingApi.postItemAdd(item);

    if (result.toString().contains("fail")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('item_registration_failed_funding_item_')
              .tr(args: [items['title'].toString()]),
        ),
      );
    } else {}
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          images.add({'type': 'file', 'data': File(pickedFile.path)});
        });
      } else {
        print(('no_image_has_been_selected').tr());
      }
    } catch (e) {
      print(('an_error_occurred_while_selecting_image_e_1').tr());
    }
  }

  Future<void> _pickItemImage(StateSetter setModalState) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setModalState(() {
          // 모달 내부 상태 갱신
          itemImages.add({'type': 'file', 'data': File(pickedFile.path)});
        });
        setState(() {
          // 전체 페이지 상태 갱신
        });
      }
    } catch (e) {
      print(('an_error_occurred_while_selecting_image_e_1').tr());
    }
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      if (isStartDate) {
        setState(() {
          startDate = picked;
        });
      } else {
        if (picked.isBefore(startDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  ('the_operation_end_date_cannot_be_set_before_the_operation_start_date')
                      .tr()),
            ),
          );
        } else {
          setState(() {
            endDate = picked;
          });
        }
      }
    }
  }

  void addItemModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: OutlinedButton(
                                onPressed: () {
                                  _pickItemImage(setModalState);
                                },
                                child: const Icon(Icons.add),
                              ),
                            ),
                            ...itemImages
                                .map((image) => Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: image['type'] == 'file'
                                                ? Image.file(
                                                    image['data'],
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    image['data'],
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                itemImages.remove(image);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ('funding_title').tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _itemTitleController,
                        decoration: InputDecoration(
                          labelText: ('labelText_14').tr(),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          labelStyle:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ('funding_price').tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _itemPriceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: ('labelText_15').tr(),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          labelStyle:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        ('funding_quantity').tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _itemAmountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: ('labelText_16').tr(),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          labelStyle:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ('funding_description').tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _itemDescriptionController,
                        decoration: InputDecoration(
                          labelText: ('labelText_17').tr(),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          labelStyle:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.34,
                            child: OutlinedButton(
                              onPressed: () {
                                if (_itemTitleController.text.isEmpty ||
                                    _itemPriceController.text.isEmpty ||
                                    _itemAmountController.text.isEmpty ||
                                    _itemDescriptionController.text.isEmpty) {
                                  showAlert(
                                      context,
                                      ('error').tr(),
                                      ('complete_all_fields_and_add_your_funding_item')
                                          .tr(), () {
                                    Navigator.pop(context);
                                  });
                                  return;
                                }
                                setState(() {
                                  fundingItem.add({
                                    "price":
                                        int.parse(_itemPriceController.text),
                                    "title": _itemTitleController.text,
                                    "limit":
                                        int.parse(_itemAmountController.text),
                                    "description":
                                        _itemDescriptionController.text,
                                    "image": itemImages
                                  });
                                  _itemPriceController.clear();
                                  _itemTitleController.clear();
                                  _itemAmountController.clear();
                                  _itemDescriptionController.clear();
                                  itemImages = [];
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: Text(('addition').tr()),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.34,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _itemPriceController.clear();
                                  _itemTitleController.clear();
                                  _itemAmountController.clear();
                                  _itemDescriptionController.clear();
                                  itemImages = [];
                                });
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.grey),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: Text(('close').tr(),
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
        appBar: CustomTitleBar(
            titleName: widget.mode == "modify"
                ? ('funding_modification').tr()
                : ('funding_registration').tr()),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: OutlinedButton(
                              onPressed: () => {_pickImage()},
                              child: const Icon(Icons.add),
                            ),
                          ),
                          ...images
                              .map((image) => Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: image['type'] == 'file'
                                              ? Image.file(
                                                  image['data'],
                                                  width: 56,
                                                  height: 56,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  image['data'],
                                                  width: 56,
                                                  height: 56,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              images.remove(
                                                  image); // 해당 이미지를 리스트에서 제거
                                            })
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      ('funding_name').tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: _titleController,
                      decoration:
                          InputDecoration(labelText: ('labelText_10').tr()),
                      onChanged: (value) => {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      ('funding_description').tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: ('labelText_17').tr(),
                          alignLabelWithHint: true),
                      maxLines: 4,
                      onChanged: (value) => {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      ('funding_period').tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Constants.BUTTON_GREY),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                ('funding_start_date').tr(),
                              ),
                              subtitle: Text(
                                _dateFormat.format(startDate!),
                              ),
                              trailing: const Icon(
                                Icons.calendar_today,
                                color: Constants.DARK_GREY,
                              ),
                              onTap: () => _selectDate(true),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Constants.BUTTON_GREY),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                ('funding_end_date').tr(),
                              ),
                              subtitle: Text(
                                _dateFormat.format(endDate!),
                              ),
                              trailing: const Icon(
                                Icons.calendar_today,
                                color: Constants.DARK_GREY,
                              ),
                              onTap: () => _selectDate(false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      ('funding_target_amount').tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: _targetAmountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration:
                          InputDecoration(labelText: ('labelText_15').tr()),
                      onChanged: (value) => {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (int index = 0; index < fundingItem.length; index++)
                    if (fundingItem.isNotEmpty)
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 1, color: Constants.DEFAULT_COLOR),
                                bottom: BorderSide(
                                    width: 1, color: Constants.DEFAULT_COLOR))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 40, bottom: 40, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 이미지 표시
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: fundingItem[index]["image"] != null
                                    ? (fundingItem[index]["image"][0]['type'] ==
                                            'file'
                                        ? Image.file(
                                            fundingItem[index]["image"][0]
                                                ['data'],
                                            width: screenWidth * 0.32,
                                            height: screenWidth * 0.32,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            fundingItem[index]["image"][0]
                                                ['data'],
                                            width: screenWidth * 0.32,
                                            height: screenWidth * 0.32,
                                            fit: BoxFit.cover,
                                          ))
                                    : Image.asset(
                                        'assets/images/goods.png', // 이미지가 없을 때 기본 이미지
                                        width: screenWidth * 0.32,
                                        height: screenWidth * 0.32,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "won",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ).tr(args: [
                                    countFomat
                                        .format(fundingItem[index]["price"])
                                  ]),
                                  const SizedBox(height: 8),
                                  Text(
                                    fundingItem[index]["title"].toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "limited_quantity_",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ).tr(args: [
                                    fundingItem[index]["limit"].toString()
                                  ]),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: Text(
                                      fundingItem[index]["description"]
                                          .toString(),
                                      style: const TextStyle(fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fundingItem.removeAt(index);
                                  });
                                },
                                child: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                      ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton(
                      onPressed: () {
                        addItemModal();
                      },
                      child: Text(('add_funding_item').tr()),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () {
                    _submitFunding();
                  },
                  child: Text(('complete').tr()),
                ),
              ),
            ],
          ),
        ));
  }
}
