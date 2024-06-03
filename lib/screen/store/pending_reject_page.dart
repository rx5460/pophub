import 'package:flutter/material.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/store/store_list_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';

class PendingRejectPage extends StatefulWidget {
  String id = "";
  PendingRejectPage({super.key, required this.id});

  @override
  State<PendingRejectPage> createState() => _PendingRejectPageState();
}

class _PendingRejectPageState extends State<PendingRejectPage> {
  TextEditingController denyController = TextEditingController();

  Future<void> popupStoreDeny() async {
    try {
      final data = await Api.popupDeny(widget.id, denyController.text);

      if (!data.toString().contains("fail") && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('거절 완료되었습니다.'),
          ),
        );

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('거절 완료되었습니다.'),
          ),
        );
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StoreListPage()));
      } else {}
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "승인 거절"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '거절 사유',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              controller: denyController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  popupStoreDeny();
                },
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
