import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';

class InquiryWritePage extends StatefulWidget {
  const InquiryWritePage({super.key});

  @override
  _InquiryWritePageState createState() => _InquiryWritePageState();
}

class _InquiryWritePageState extends State<InquiryWritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String category = "";
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    } catch (e) {
      Logger.debug('Error picking image: $e');
    }
  }

  List<Map<String, int>> categoryList = [
    {'기술 문의': 00},
    {'상품 문의': 01},
    {'고객 서비스 문의': 02},
    {'주문/배송 문의': 03},
    {'회원 가입/로그인 문의': 04},
  ];

  Future<void> inquiryAdd() async {
    String title = _titleController.text;
    String content = _contentController.text;

    Map<String, dynamic> data = _image == null
        ? await Api.inquiryAdd(title, content, category)
        : await Api.inquiryAddWithImage(
            title, content, category, File(_image!.path));

    if (!data.toString().contains("fail")) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InquiryPage(),
          ),
        );
      }
    } else {
      if (mounted) {
        showAlert(context, "경고", "문의 추가에 실패했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "문의 하기"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.05,
            bottom: screenHeight * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('문의 제목',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: '문의 제목을 입력하세요'),
            ),
            const SizedBox(height: 16),
            const Text('문의 내용',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: '문의 내용을 입력하세요'),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '카테고리'),
              items: categoryList.map((categoryMap) {
                String category = categoryMap.keys.first;
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  for (var categoryMap in categoryList) {
                    if (categoryMap.containsKey(value)) {
                      setState(() {
                        category = categoryMap[value]!.toString();
                      });
                      break;
                    }
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _pickImage,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(screenWidth / 2, 50),
              ),
              child: const Text('파일 첨부하기'),
            ),
            const SizedBox(height: 8),
            SizedBox(
                width: screenWidth,
                height: 40,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffd9d9d9),
                          width: 0.5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 5, left: 10, right: 10),
                      child: Text(_image != null ? _image!.name : '첨부된 파일 없음'),
                    ))),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: inquiryAdd,
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
