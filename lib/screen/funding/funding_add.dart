import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/utils/api/category_api.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class FundingAddPage extends StatefulWidget {
  final String mode;
  final PopupModel? popup;

  const FundingAddPage({super.key, this.mode = "add", this.popup});

  @override
  _FundingAddPageState createState() => _FundingAddPageState();
}

class _FundingAddPageState extends State<FundingAddPage> {
  var countFomat = NumberFormat('###,###,###,###');
  List<CategoryModel> category = [];
  List<Map<String, dynamic>> fundingItem = [];

  @override
  void initState() {
    super.initState();

    getCategory();
  }

  Future<void> getCategory() async {
    final data = await CategoryApi.getCategoryList();
    setState(() {
      category = data.where((item) => item.categoryId >= 10).toList();
      if (widget.popup != null) {
        selectedCategory = category.firstWhere(
          (item) =>
              item.categoryId.toString() == widget.popup?.category.toString(),
        );
      }
    });
    print("Data $data");
  }

  final ImagePicker _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemTitleController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  CategoryModel? selectedCategory;

  Future<void> storeAdd(StoreModel store) async {
    final data = await StoreApi.postStoreAdd(store);

    if (!data.toString().contains("fail") && mounted) {
      showAlert(context, "성공", "팝업스토어 신청이 완료되었습니다.", () {
        Navigator.of(context).pop();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiProvider(providers: [
                      ChangeNotifierProvider(create: (_) => UserNotifier())
                    ], child: const BottomNavigationPage())));
      });
    } else {}
  }

  Future<void> storeModify(StoreModel store) async {
    final data = await StoreApi.putStoreModify(store);

    if (!data.toString().contains("fail") && mounted) {
      showAlert(context, "성공", "팝업스토어 수정이 완료되었습니다.", () {
        Navigator.of(context).pop();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiProvider(providers: [
                      ChangeNotifierProvider(create: (_) => UserNotifier())
                    ], child: const BottomNavigationPage())));
      });
    } else {}
  }

  void addItemModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
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
                          onPressed: () => {
                            // _pickImage()
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                      // ...store.images
                      //     .map((image) => Stack(
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.all(4.0),
                      //               child: image['type'] == 'file'
                      //                   ? Image.file(
                      //                       image['data'],
                      //                       width: 60,
                      //                       height: 60,
                      //                     )
                      //                   : Image.network(
                      //                       image['data'],
                      //                       width: 60,
                      //                       height: 60,
                      //                     ),
                      //             ),
                      //             Positioned(
                      //               right: 0,
                      //               child: GestureDetector(
                      //                 onTap: () =>
                      //                     {},
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.black,
                      //                     borderRadius:
                      //                         BorderRadius.circular(50),
                      //                   ),
                      //                   child: const Icon(
                      //                     Icons.close,
                      //                     size: 20,
                      //                     color: Colors.white,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ))
                      //     .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '펀딩 제목',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _itemTitleController,
                  decoration: const InputDecoration(
                      labelText: '제목을 작성해주세요.',
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      labelStyle:
                          TextStyle(fontSize: 13, color: Constants.DARK_GREY)),
                  onChanged: (value) => {},
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '펀딩 가격',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _itemPriceController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                      labelText: '금액을 작성해주세요.',
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      labelStyle:
                          TextStyle(fontSize: 13, color: Constants.DARK_GREY)),
                  onChanged: (value) => {},
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '펀딩 수량',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _itemAmountController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: '수량을 작성해주세요.',
                    alignLabelWithHint: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    labelStyle:
                        TextStyle(fontSize: 13, color: Constants.DARK_GREY),
                  ),
                  onChanged: (value) => {},
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey,
                      ),
                      Text(
                        '무제한인 경우 체크해주세요.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '펀딩 설명',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _itemDescriptionController,
                  decoration: const InputDecoration(
                      labelText: '펀딩 설명을 작성해주세요.',
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      labelStyle:
                          TextStyle(fontSize: 13, color: Constants.DARK_GREY)),
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: OutlinedButton(
                        onPressed: () {
                          fundingItem.add({
                            "price": int.parse(_itemPriceController.text),
                            "title": _itemTitleController.text,
                            "limit": int.parse(_itemAmountController.text),
                            "description": _itemDescriptionController.text
                          });
                          setState(() {
                            _itemPriceController.text = '';
                            _itemTitleController.text = '';
                            _itemAmountController.text = '';
                            _itemDescriptionController.text = '';
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text('추가'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _itemPriceController.text = '';
                            _itemTitleController.text = '';
                            _itemAmountController.text = '';
                            _itemDescriptionController.text = '';
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Constants.LIGHT_GREY),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          '닫기',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
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
            titleName: widget.mode == "modify" ? "펀딩 수정" : "펀딩 등록"),
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
                              onPressed: () => {
                                // _pickImage()
                              },
                              child: const Icon(Icons.add),
                            ),
                          ),
                          // ...store.images
                          //     .map((image) => Stack(
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.all(4.0),
                          //               child: image['type'] == 'file'
                          //                   ? Image.file(
                          //                       image['data'],
                          //                       width: 60,
                          //                       height: 60,
                          //                     )
                          //                   : Image.network(
                          //                       image['data'],
                          //                       width: 60,
                          //                       height: 60,
                          //                     ),
                          //             ),
                          //             Positioned(
                          //               right: 0,
                          //               child: GestureDetector(
                          //                 onTap: () =>
                          //                     {},
                          //                 child: Container(
                          //                   decoration: BoxDecoration(
                          //                     color: Colors.black,
                          //                     borderRadius:
                          //                         BorderRadius.circular(50),
                          //                   ),
                          //                   child: const Icon(
                          //                     Icons.close,
                          //                     size: 20,
                          //                     color: Colors.white,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ))
                          //     .toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "펀딩 이름",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: '이름을 작성해주세요.'),
                      onChanged: (value) => {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "펀딩 설명",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          labelText: '펀딩 설명을 작성해주세요.',
                          alignLabelWithHint: true),
                      maxLines: 4,
                      onChanged: (value) => {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "펀딩 목표 금액",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: _nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration:
                          const InputDecoration(labelText: '금액을 작성해주세요.'),
                      onChanged: (value) => {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (int index = 0;
                      index < (fundingItem.length ?? 0);
                      index++)
                    if (fundingItem != [])
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/goods.png',
                                  // width: screenHeight * 0.07 - 5,
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
                                  Text(
                                    "${countFomat.format(fundingItem[index]["price"])}원",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    fundingItem[index]["title"].toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "제한수량 ${fundingItem[index]["limit"].toString()}개",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
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
                                  child: const Icon(Icons.close)),
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
                      child: const Text('펀딩 아이템 추가하기'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('완료'),
                ),
              ),
            ],
          ),
        ));
  }
}
