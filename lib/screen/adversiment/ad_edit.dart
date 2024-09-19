import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/model/ad_model.dart';

class AdEditPage extends StatefulWidget {
  final AdModel ad;

  const AdEditPage({required this.ad, Key? key}) : super(key: key);

  @override
  AdEditPageState createState() => AdEditPageState();
}

class AdEditPageState extends State<AdEditPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  DateTime? startDate;
  DateTime? endDate;
  String adTitle = '';
  final Color pinkColor = const Color(0xFFE6A3B3);

  @override
  void initState() {
    super.initState();
    adTitle = widget.ad.title;
    startDate = DateTime.parse(widget.ad.startDate as String);
    endDate = widget.ad.endDate ?? DateTime.now();
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

  Future<void> _updateAd() async {
    if (adTitle.isEmpty || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("모든 값을 입력해주세요.")),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://3.88.120.90:3000/admin/event/update/${widget.ad.id}'),
    );
    request.fields['title'] = adTitle;
    request.fields['startDate'] = startDate.toString();
    request.fields['endDate'] = endDate.toString();

    if (_selectedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("광고가 성공적으로 수정되었습니다.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("광고 수정 실패: ${response.reasonPhrase}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: pinkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              '광고 제목',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(text: adTitle),
              decoration: const InputDecoration(
                hintText: '광고 제목을 입력하세요',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  adTitle = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              '광고 이미지',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            if (widget.ad.imageUrl != null && _selectedImage == null)
              Image.network(widget.ad.imageUrl, height: 200, fit: BoxFit.cover),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 8.0),
            ListTile(
              title: const Text('이미지 다시 선택'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _pickImage,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '게시 기간',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
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
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateAd,
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
          ],
        ),
      ),
    );
  }
}
