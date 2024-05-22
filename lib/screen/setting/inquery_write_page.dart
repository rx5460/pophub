import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';

class InquiryWritePage extends StatefulWidget {
  @override
  _InquiryWritePageState createState() => _InquiryWritePageState();
}

class _InquiryWritePageState extends State<InquiryWritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  PlatformFile? _pickedFile;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  Future<void> _submitInquiry() async {
    String title = _titleController.text;
    String content = _contentController.text;
    String fileName = _pickedFile?.name ?? '';

    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'content': content,
        if (_pickedFile != null)
          'file': await MultipartFile.fromFile(_pickedFile!.path!,
              filename: fileName),
      });

      Dio dio = Dio();
      Response response = await dio.post(
        'https://example.com/api/inquiry',
        data: formData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('문의가 성공적으로 전송되었습니다.')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('문의 전송에 실패하였습니다.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('오류가 발생하였습니다: $e')));
    }
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
            bottom: screenHeight * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('문의 제목',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: '문의 제목을 입력하세요'),
            ),
            SizedBox(height: 16),
            Text('문의 내용',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: '문의 내용을 입력하세요'),
              maxLines: 6,
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: _pickFile,
              child: Text('파일 첨부하기'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(screenWidth / 2, 50),
              ),
            ),
            SizedBox(height: 8),
            Container(
                width: screenWidth,
                height: 40,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xffd9d9d9),
                          width: 0.5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 5, left: 10, right: 10),
                      child: Text(_pickedFile != null
                          ? _pickedFile!.name
                          : '첨부된 파일 없음'),
                    ))),
            Spacer(),
            OutlinedButton(
              onPressed: _submitInquiry,
              child: Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
