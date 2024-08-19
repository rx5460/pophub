import 'package:flutter/material.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            const TextField(
              decoration: InputDecoration(
                hintText: '점검 안내 공지',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '공지사항 내용',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            const Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText:
                      '안녕하세요, 팝허브입니다.\n\n보다 나은 서비스 제공을 위해 다음과 같이 시스템 점검을 실시할 예정입니다. 고객 여러분의 양해 부탁드립니다.\n\n점검 일정:\n• 일시: 2024년 5월 17일 00:00부터 2024년',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 완료 버튼 클릭 후 로직 추가해야됨
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('완료',
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
