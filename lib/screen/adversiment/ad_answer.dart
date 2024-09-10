import 'package:flutter/material.dart';

class AdAnswer extends StatefulWidget {
  const AdAnswer({super.key});

  @override
  State<AdAnswer> createState() => _AdAnswerState();
}

class _AdAnswerState extends State<AdAnswer> {
  final TextEditingController queryTitleController = TextEditingController();
  final TextEditingController queryContentController = TextEditingController();
  final TextEditingController answerTitleController = TextEditingController();
  final TextEditingController answerContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 답변 하기',
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '문의 제목',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: queryTitleController,
                      decoration: const InputDecoration(
                        hintText: '문의 제목을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '문의 내용',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: queryContentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: '문의 내용을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '답변 제목',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: answerTitleController,
                      decoration: const InputDecoration(
                        hintText: '답변 제목을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '답변 내용',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: answerContentController,
                      maxLines: 13,
                      decoration: const InputDecoration(
                        hintText: '답변 내용을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 완료 로직
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6A3B3),
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
