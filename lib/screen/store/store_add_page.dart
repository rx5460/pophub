import 'package:flutter/material.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:provider/provider.dart';
// import 'package:remedi_kopo/remedi_kopo.dart';
import 'dart:io';

class StoreCreationPage extends StatelessWidget {
  final List<String> categories = [
    '카페',
    '식당',
    '옷가게',
    '서점',
    '기타',
  ];

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
        Provider.of<StoreModel>(context, listen: false).updateEndDate(picked);
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    // final pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   Provider.of<StoreModel>(context, listen: false)
    //       .addImage(File(pickedFile.path));
    // }
  }

  Future<void> _pickLocation(BuildContext context) async {
    // KopoModel model = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => RemediKopo(),
    //   ),
    // );
    // if (model.address != null) {
    //   Provider.of<StoreModel>(context, listen: false)
    //       .updateLocation(model.address!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('스토어 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StoreModel>(
          builder: (context, store, child) {
            return ListView(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () => _pickImage(context),
                    ),
                    ...store.images
                        .map((image) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                image,
                                width: 50,
                                height: 50,
                              ),
                            ))
                        .toList(),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(labelText: '스토어 이름'),
                  onChanged: (value) => store.name = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: '스토어 설명'),
                  maxLines: 4,
                  onChanged: (value) => store.description = value,
                ),
                ListTile(
                  title: Text('스토어 위치'),
                  subtitle: Text(store.location),
                  trailing: Icon(Icons.location_on),
                  onTap: () => _pickLocation(context),
                ),
                ListTile(
                  title: Text('운영 시간'),
                  trailing: Icon(Icons.access_time),
                  onTap: () {
                    // 운영 시간 설정 페이지로 이동 (여기서는 생략)
                  },
                ),
                ListTile(
                  title: Text('운영 기간'),
                  subtitle: Text(
                      '${store.startDate.toLocal()} ~ ${store.endDate.toLocal()}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
                ListTile(
                  title: Text('운영 종료 기간'),
                  subtitle: Text('${store.endDate.toLocal()}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
                TextField(
                  decoration: InputDecoration(labelText: '연락처'),
                  onChanged: (value) => store.contact = value,
                ),
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
                ElevatedButton(
                  onPressed: () {
                    // 완료 버튼 누를 때 처리 로직
                  },
                  child: Text('완료'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StoreModel(),
      child: MaterialApp(
        home: StoreCreationPage(),
      ),
    ),
  );
}
