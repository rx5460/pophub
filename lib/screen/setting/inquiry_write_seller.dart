import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  NoticePageState createState() => NoticePageState();
}

class NoticePageState extends State<NoticePage> {
  String selectedCategory = '광고';
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '문의 하기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '문의 카테고리',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: <String>['광고', '기타'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '문의 제목',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const TextField(
              decoration: InputDecoration(
                hintText: '문의 제목을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '문의 내용',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: '문의 내용을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (selectedCategory == '광고')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이미지 첨부',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  _selectedImage == null
                      ? ElevatedButton(
                          onPressed: _pickImage,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('첨부하기'),
                        )
                      : Column(
                          children: [
                            Image.file(
                              _selectedImage!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: _pickImage,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('다시 선택'),
                            ),
                          ],
                        ),
                  const SizedBox(height: 16.0),
                ],
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 완료 api
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6A3B3),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
