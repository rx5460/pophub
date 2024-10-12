import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdUpload extends StatefulWidget {
  const AdUpload({Key? key, required String mode}) : super(key: key);

  @override
  AdUploadState createState() => AdUploadState();
}

class AdUploadState extends State<AdUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  DateTime? startDate;
  DateTime? endDate;
  String adTitle = '';

  final Color pinkColor = const Color(0xFFE6A3B3);

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path); // 이미지를 File 객체로 변환
        });
      } else {
        print(('image_selection_has_been_cancelled').tr());
      }
    } catch (e) {
      print(('an_error_occurred_while_selecting_image_e').tr());
    }
  }

  Future<void> uploadAd() async {
    if (_selectedImage == null ||
        startDate == null ||
        endDate == null ||
        adTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(('please_enter_all_values').tr())),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://3.233.20.5:3000/admin/event/create'),
      );
      request.fields['startDate'] = startDate!.toIso8601String();
      request.fields['endDate'] = endDate!.toIso8601String();
      request.fields['title'] = adTitle;
      request.files
          .add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text("ad_upload_failed_")
                  .tr(args: [response.reasonPhrase.toString()])),
        );
      }
    } catch (e) {
      print(('an_error_occurred_while_uploading_e').tr());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(('an_error_occurred_during_upload').tr())),
      );
    }
  }

  Future<void> _showSuccessDialog() async {
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
                Text(
                  ('success').tr(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  ('advertisement_registration_has_been_completed').tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                  child: Text(
                    ('close').tr(),
                    style: const TextStyle(
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

  // 날짜 선택 함수
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ('add_ad').tr(),
          style: const TextStyle(
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
            Text(
              ('advertisement_title').tr(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                hintText: ('hintText_5').tr(),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  adTitle = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              ('advertising_image').tr(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _selectedImage == null
                  ? ListTile(
                      title: Text(('attach').tr()),
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
                          title: Text(('select_again').tr()),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: _pickImage,
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 30.0),
            Text(
              ('posting_period').tr(),
              style: const TextStyle(
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
                            ? ('start_date').tr()
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
                            ? ('end_date').tr()
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
            onPressed: uploadAd,
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
              minimumSize: const Size(double.infinity, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              ('complete').tr(),
              style: const TextStyle(
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
