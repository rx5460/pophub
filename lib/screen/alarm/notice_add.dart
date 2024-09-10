import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NoticeAdd extends StatelessWidget {
  const NoticeAdd({Key? key}) : super(key: key);

  Future<void> noticeNotification(
      BuildContext context, String title, String label) async {
    try {
      String formattedTime =
          DateFormat('MM월 dd일 HH시 mm분').format(DateTime.now());

      // Firestore에 공지사항 저장
      await FirebaseFirestore.instance.collection('alarms').add({
        'active': true,
        'label': label,
        'time': formattedTime,
        'title': title,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('공지사항이 성공적으로 전송되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('공지사항 전송에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '공지사항',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '공지사항 제목',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '공지사항 제목을 입력하세요',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '공지사항 내용',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '공지사항 내용을 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  noticeNotification(
                    context,
                    titleController.text,
                    contentController.text,
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6A3B3),
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
