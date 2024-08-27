import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/model/kopo_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/schedule_model.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/screen/store/store_operate_hour.dart';
import 'package:pophub/utils/api/category_api.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/remedi_kopo.dart';
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
  @override
  void initState() {
    super.initState();
    _initializeFields();
    getCategory();
  }

  void _initializeFields() {
    if (widget.popup != null) {
      _nameController.text = widget.popup?.name ?? '';
      _descriptionController.text = widget.popup?.description ?? '';

      String locationPart = "";
      if (widget.popup?.location != null &&
          widget.popup!.location!.isNotEmpty) {
        List<String> parts = widget.popup!.location!.split("/");
        if (parts.length > 1) {
          locationPart = parts[1];
        }
      }

      _locationController.text = locationPart;
      _contactController.text = widget.popup?.contact ?? '';
      _maxCapacityController.text = widget.popup?.view?.toString() ?? '';

      Provider.of<StoreModel>(context, listen: false).name =
          widget.popup?.name ?? '';
      Provider.of<StoreModel>(context, listen: false).description =
          widget.popup?.description ?? '';
      Provider.of<StoreModel>(context, listen: false).location =
          widget.popup?.location ?? '';
      Provider.of<StoreModel>(context, listen: false).contact =
          widget.popup?.contact ?? '';
      Provider.of<StoreModel>(context, listen: false).maxCapacity =
          widget.popup?.view ?? 0;

      Provider.of<StoreModel>(context, listen: false).startDate =
          DateTime.parse(widget.popup?.start ?? DateTime.now().toString());
      Provider.of<StoreModel>(context, listen: false).endDate =
          DateTime.parse(widget.popup?.end ?? DateTime.now().toString());

      Provider.of<StoreModel>(context, listen: false).schedule =
          widget.popup!.schedule;

      Provider.of<StoreModel>(context, listen: false).id = widget.popup!.id!;

      Provider.of<StoreModel>(context, listen: false).category =
          widget.popup?.category?.toString() ?? '';
      Provider.of<StoreModel>(context, listen: false).images = widget
              .popup?.image
              ?.map((imageUrl) => {'type': 'url', 'data': imageUrl})
              .toList() ??
          [];
    }
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
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _maxCapacityController = TextEditingController();
  CategoryModel? selectedCategory;

  Future<void> _pickImage() async {
    try {
      if (Provider.of<StoreModel>(context, listen: false).images.length < 5) {
        final XFile? pickedImage =
            await _picker.pickImage(source: ImageSource.gallery);

        if (pickedImage != null && mounted) {
          Provider.of<StoreModel>(context, listen: false)
              .addImage({'type': 'file', 'data': File(pickedImage.path)});
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('경고'),
                content: const Text('사진은 최대 5개까지 등록할 수 있습니다.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('확인'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? Provider.of<StoreModel>(context, listen: false).startDate
          : Provider.of<StoreModel>(context, listen: false).endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      if (isStartDate) {
        Provider.of<StoreModel>(context, listen: false).updateStartDate(picked);
      } else {
        DateTime startDate =
            Provider.of<StoreModel>(context, listen: false).startDate;
        if (picked.isBefore(startDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('운영 종료일은 운영 시작일 이전으로 설정할 수 없습니다.'),
            ),
          );
        } else {
          Provider.of<StoreModel>(context, listen: false).updateEndDate(picked);
        }
      }
    }
  }

  bool _validateInputs(StoreModel store) {
    if (_nameController.text.isEmpty) {
      _showValidationDialog("스토어 이름을 입력해주세요.");
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      _showValidationDialog("스토어 설명을 입력해주세요.");
      return false;
    }
    if (store.location.isEmpty) {
      _showValidationDialog("스토어 위치를 선택해주세요.");
      return false;
    }
    if (_contactController.text.isEmpty) {
      _showValidationDialog("연락처를 입력해주세요.");
      return false;
    }
    if (widget.mode == "add" && _maxCapacityController.text.isEmpty) {
      _showValidationDialog("시간별 최대 인원을 입력해주세요.");
      return false;
    }
    if (store.schedule!.isEmpty) {
      _showValidationDialog("운영 시간을 설정해주세요.");
      return false;
    }
    if (selectedCategory == null) {
      _showValidationDialog("카테고리를 선택해주세요.");
      return false;
    }
    return true;
  }

  void _showValidationDialog(String message) {
    showAlert(context, "실패", message, () {
      Navigator.of(context).pop();
    });
  }

  Future<void> _pickLocation() async {
    if (!mounted) return;

    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RemediKopo(),
      ),
    );

    if (model != null && model.address != null) {
      if (mounted) {
        Provider.of<StoreModel>(context, listen: false)
            .updateLocation(model.address!);
      }
    }
  }

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

  void _showOperatingHoursModal(BuildContext context, StoreModel storeModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoreOperatingHoursModal(storeModel: storeModel);
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
      body: Consumer<StoreModel>(
        builder: (context, store, child) {
          return SingleChildScrollView(
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
                                onPressed: () => _pickImage(),
                                child: const Icon(Icons.add),
                              ),
                            ),
                            ...store.images
                                .map((image) => Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: image['type'] == 'file'
                                              ? Image.file(
                                                  image['data'],
                                                  width: 60,
                                                  height: 60,
                                                )
                                              : Image.network(
                                                  image['data'],
                                                  width: 60,
                                                  height: 60,
                                                ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () =>
                                                store.removeImage(image),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "펀딩 이름",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: '이름을 작성해주세요.'),
                        onChanged: (value) => store.name = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "펀딩 설명",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                        onChanged: (value) => store.description = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "펀딩 목표 금액",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                        onChanged: (value) => {store.name = value},
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/goods.png',
                                // width: screenHeight * 0.07 - 5,
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('8,900원'),
                                const Text('파일 폴더 및 액자 세트'),
                                const Text('제한수량 100개'),
                                SizedBox(
                                  width: screenWidth * 0.4,
                                  child: const Text(
                                    '쥐순이 랜덤 파일 폴더 및 액자가 들어있는 세트입니다.',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.close),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (_validateInputs(store)) {
                        if (widget.mode == "modify") {
                          storeModify(store);
                        } else if (widget.mode == "add") {
                          storeAdd(store);
                        }
                      }
                    },
                    child: const Text('완료'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
