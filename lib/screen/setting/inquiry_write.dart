import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry.dart';
import 'package:pophub/utils/api/category_api.dart';
import 'package:pophub/utils/api/inquiryl_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';

class InquiryWritePage extends StatefulWidget {
  const InquiryWritePage({Key? key}) : super(key: key);

  @override
  InquiryWritePageState createState() => InquiryWritePageState();
}

class InquiryWritePageState extends State<InquiryWritePage> {
  String selectedCategory = '광고';
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<CategoryModel> categoryList = [];

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  Future<void> getCategory() async {
    final data = await CategoryApi.getCategoryList();
    if (mounted) {
      setState(() {
        categoryList = data.where((item) => item.categoryId < 10).toList();
      });
    }
  }

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
      Logger.debug('Error picking image: $e');
    }
  }

  Future<void> inquiryAdd() async {
    String title = _titleController.text;
    String content = _contentController.text;

    Map<String, dynamic> data = _selectedImage == null
        ? await InquiryApi.postInquiryAdd(title, content, selectedCategory)
        : await InquiryApi.postInquiryAddWithImage(
            title, content, selectedCategory, File(_selectedImage!.path));

    if (!data.toString().contains("fail")) {
      if (mounted) {
        showAlert(context, "성공", "문의 등록을 완료했습니다.", () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InquiryPage(),
            ),
          );
        });
      }
    } else {
      if (mounted) {
        showAlert(context, "경고", "문의 등록에 실패했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: const CustomTitleBar(titleName: "문의 하기"),
      body: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.05,
            bottom: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '문의 카테고리',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<CategoryModel>(
              decoration: const InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(),
              ),
              items: categoryList.map((categoryModel) {
                return DropdownMenuItem<CategoryModel>(
                  value: categoryModel,
                  child: Text(categoryModel.categoryName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value.categoryName;
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              '문의 제목',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '문의 제목을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '문의 내용',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
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
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  _selectedImage == null
                      ? ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE6A3B3)),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '첨부하기',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ],
                          ),
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
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.white,
                                side:
                                    const BorderSide(color: Color(0xFFE6A3B3)),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '다시 선택',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 16.0),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.02),
          child: ElevatedButton(
            onPressed: inquiryAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6A3B3),
              minimumSize: const Size(double.infinity, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: const Text(
              '완료',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
