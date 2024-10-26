import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/notice.dart';
import 'package:pophub/utils/api/notice_api.dart';
import 'package:pophub/utils/utils.dart';

class NoticeWritePage extends StatefulWidget {
  const NoticeWritePage({super.key});

  @override
  _NoticeWritePageState createState() => _NoticeWritePageState();
}

class _NoticeWritePageState extends State<NoticeWritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitInquiry() async {
    String title = _titleController.text;
    String content = _contentController.text;
    try {
      Map<String, dynamic> data = await NoticeApi.postNoticeAdd(title, content);

      if (!data.toString().contains("fail")) {
        if (mounted) {
          showAlert(context, ('success').tr(),
              ('inquiry_registration_has_been_completed').tr(), () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoticePage(),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('an_error_occurred_during_upload').tr()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: CustomTitleBar(titleName: "text_5".tr()),
      body: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.05,
            bottom: screenHeight * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('notice_title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                .tr(),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'hintText_8'.tr()),
            ),
            const SizedBox(height: 16),
            const Text('notice_contents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                .tr(),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: 'hintText_8'.tr()),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            const Spacer(),
            OutlinedButton(
              onPressed: _submitInquiry,
              child: const Text('complete').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
