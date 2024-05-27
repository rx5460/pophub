import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/kopo_model.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/store/store_operate_hour_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/remedi_kopo.dart';
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
    getPendingList();
    super.initState();
  }

  final List<String> categories = [
    '카페',
    '식당',
    '옷가게',
    '서점',
    '기타',
  ];

  final ImagePicker _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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
            SnackBar(
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
      setState(() {});
    } else {}
  }

  Future<void> getPendingList() async {
    final data = await Api.getPendingList();

    if (!data.toString().contains("fail")) {
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Icon(Icons.add),
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
                                        child: Icon(
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
                SizedBox(height: 20),
                Text(
                  "스토어 이름",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: '이름을 작성해주세요.'),
                  onChanged: (value) => store.name = value,
                ),
                SizedBox(height: 20),
                Text(
                  "스토어 설명",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      labelText: '스토어 설명을 작성해주세요.', alignLabelWithHint: true),
                  maxLines: 4,
                  onChanged: (value) => store.description = value,
                ),
                SizedBox(height: 20),
                Text(
                  "스토어 위치",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    title: Text('스토어 위치'),
                    subtitle: Text(store.location),
                    trailing: Icon(Icons.location_on),
                    onTap: () => _pickLocation(context),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "운영 시간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    title: Text('운영 시간'),
                    trailing: Icon(Icons.access_time),
                    onTap: () {
                      Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //   builder: (context) => MultiProvider(providers: [
                        //     ChangeNotifierProvider(create: (_) => store)
                        //   ], child: StoreOperatingHoursPage()),
                        // )
                        MaterialPageRoute(
                            builder: (context) => StoreOperatingHoursPage()),
                      );
                      // 운영 시간 설정 페이지로 이동 (여기서는 생략)
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "운영 기간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          title: Text('운영 시작일'),
                          subtitle: Text(_dateFormat.format(store.startDate)),
                          trailing: Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          title: Text('운영 종료일'),
                          subtitle: Text(_dateFormat.format(store.endDate)),
                          trailing: Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "연락처",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: '연락처'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  onChanged: (value) => store.contact = value,
                ),
                SizedBox(height: 20),
                Text(
                  "카테고리",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: '카테고리'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) => store.category = value ?? '',
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      // 완료 버튼 누를 때 처리 로직
                      storeAdd(store);
                    },
                    child: Text('완료'),
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
