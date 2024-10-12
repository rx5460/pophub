import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
  String selectedCategory = ('text_11').tr();
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
        showAlert(context, ('success').tr(),
            ('inquiry_registration_has_been_completed').tr(), () {
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
        showAlert(
            context, ('warning').tr(), ('inquiry_registration_failed').tr(),
            () {
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
      appBar: CustomTitleBar(titleName: ('titleName_12').tr()),
      body: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.05,
            bottom: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ('inquiry_category').tr(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<CategoryModel>(
              decoration: InputDecoration(
                labelText: ('labelText_8').tr(),
                border: const OutlineInputBorder(),
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
            if (selectedCategory == ('advertisement_inquiry').tr())
              Text(
                ('please_register_images_at_a_11_rationads_are_registered_in_popup_banner_formatnnwhen_registering_an_ad_modification_or_deletion_is_not_possible')
                    .tr(),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              ('inquiry_subject').tr(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: ('hintText_11').tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              ('inquiry_details').tr(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: ('hintText_12').tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ('attach_image').tr(),
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                _selectedImage == null
                    ? OutlinedButton(
                        onPressed: _pickImage,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE6A3B3)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ('attach_1').tr(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Icon(
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
                          OutlinedButton(
                            onPressed: _pickImage,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFE6A3B3)),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ('select_again').tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const Icon(
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
            child: Text(
              ('complete').tr(),
              style: const TextStyle(
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
