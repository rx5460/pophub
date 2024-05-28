import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/kopo_model.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/store/store_operate_hour_page.dart';
import 'package:pophub/screen/user/profile_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/remedi_kopo.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class StoreCreatePage extends StatefulWidget {
  @override
  _StoreCreatePageState createState() => _StoreCreatePageState();
}

class _StoreCreatePageState extends State<StoreCreatePage> {
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, int>> categoryList = [
    {'의류': 10},
    {'액세서리': 11},
    {'신발': 12},
    {'가방/지갑': 13},
    {'뷰티/화장품': 14},
    {'가전제품': 15},
    {'생활용품': 16},
    {'푸드/음료': 17},
    {'문구/책/잡화': 18},
    {'전자기기/액세서리': 19},
    {'건강/웰빙': 20},
    {'패션/라이프스타일': 21},
    {'예술/공예': 22},
  ];

  final ImagePicker _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _maxCapacityController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        Provider.of<StoreModel>(context, listen: false)
            .addImage(File(pickedImage.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? Provider.of<StoreModel>(context, listen: false).startDate
          : Provider.of<StoreModel>(context, listen: false).endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
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

  Future<void> _pickLocation(BuildContext context) async {
    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );

    if (model != null && model.address != null) {
      Provider.of<StoreModel>(context, listen: false)
          .updateLocation(model.address!);
    }
  }

  Future<void> storeAdd(StoreModel store) async {
    final data = await Api.storeAdd(store);

    if (!data.toString().contains("fail")) {
      showAlert(context, "성공", "팝업스토어 신청이 완료되었습니다.", () {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "스토어 등록"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StoreModel>(
          builder: (context, store, child) {
            return ListView(
              children: [
                SingleChildScrollView(
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
                                    child: Image.file(
                                      image,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => store.removeImage(image),
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
                const SizedBox(height: 20),
                const Text(
                  "스토어 이름",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '이름을 작성해주세요.'),
                  onChanged: (value) => store.name = value,
                ),
                const SizedBox(height: 20),
                const Text(
                  "스토어 설명",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: '스토어 설명을 작성해주세요.', alignLabelWithHint: true),
                  maxLines: 4,
                  onChanged: (value) => store.description = value,
                ),
                const SizedBox(height: 20),
                const Text(
                  "스토어 위치",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: const Text('스토어 위치'),
                    subtitle: Text(store.location),
                    trailing: const Icon(Icons.location_on),
                    onTap: () => _pickLocation(context),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: '상세 위치를 적어주세요.'),
                  onChanged: (value) => store.locationDetail = value,
                ),
                const SizedBox(height: 20),
                const Text(
                  "운영 시간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Visibility(
                  visible: store.schedule.isNotEmpty,
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.32,
                    child: Consumer<StoreModel>(
                      builder: (context, store, child) {
                        return ListView.builder(
                          itemCount: store.schedule.length,
                          itemBuilder: (context, index) {
                            Schedule schedule = store.schedule[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(schedule.dayOfWeek),
                                  Text(
                                      '${schedule.openTime} - ${schedule.closeTime}'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: const Text('운영 시간 설정하기'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreOperatingHoursPage(
                              storeModel: store,
                            ),
                          )
                          // MaterialPageRoute(
                          //     builder: (context) => StoreOperatingHoursPage()),
                          );
                      // 운영 시간 설정 페이지로 이동 (여기서는 생략)
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "운영 기간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: const Text('운영 시작일'),
                          subtitle: Text(_dateFormat.format(store.startDate)),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: const Text('운영 종료일'),
                          subtitle: Text(_dateFormat.format(store.endDate)),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "연락처",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: '연락처'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  onChanged: (value) => store.contact = value,
                ),
                const SizedBox(height: 20),
                const Text(
                  "시간별 최대 인원",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _maxCapacityController,
                  decoration: const InputDecoration(labelText: '시간별 최대 인원'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1000),
                  ],
                  onChanged: (value) => store.maxCapacity = int.parse(value),
                ),
                const SizedBox(height: 20),
                const Text(
                  "카테고리",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: '카테고리'),
                  items: categoryList.map((categoryMap) {
                    String category = categoryMap.keys.first;
                    int value = categoryMap[category]!;
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      for (var categoryMap in categoryList) {
                        if (categoryMap.containsKey(value)) {
                          //store.category = value;
                          store.category = categoryMap[value]!.toString();
                          break;
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      // 완료 버튼 누를 때 처리 로직
                      storeAdd(store);
                    },
                    child: const Text('완료'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
