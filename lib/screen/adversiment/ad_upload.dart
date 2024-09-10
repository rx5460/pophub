import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdUpload extends StatefulWidget {
  const AdUpload({Key? key}) : super(key: key);

  @override
  AdUploadState createState() => AdUploadState();
}

class AdUploadState extends State<AdUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  DateTime? startDate;
  DateTime? endDate;

  final Color pinkColor = const Color(0xFFE6A3B3);

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
      print('이미지 선택 중 오류 발생: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: pinkColor, width: 2),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '성공',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '광고 등록이 완료되었습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: pinkColor,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: pinkColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 추가',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              '광고 이미지',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              '이미지는 1:1 비율로 등록해주세요.\n광고는 팝업 배너 형식으로 등록됩니다.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _selectedImage == null
                  ? ListTile(
                      title: const Text('첨부하기'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _pickImage,
                    )
                  : Column(
                      children: [
                        Image.file(
                          _selectedImage!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8.0),
                        ListTile(
                          title: const Text('다시 선택'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: _pickImage,
                        ),
                      ],
                    ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '광고 미리보기',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              '게시 기간',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        startDate == null
                            ? '시작 날짜'
                            : '${startDate!.year}.${startDate!.month.toString().padLeft(2, '0')}.${startDate!.day.toString().padLeft(2, '0')}',
                      ),
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('~', style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        endDate == null
                            ? '종료 날짜'
                            : '${endDate!.year}.${endDate!.month.toString().padLeft(2, '0')}.${endDate!.day.toString().padLeft(2, '0')}',
                      ),
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
              minimumSize: const Size(double.infinity, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
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
      ),
    );
  }
}
