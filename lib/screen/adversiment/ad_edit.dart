import 'package:flutter/material.dart';
import 'package:pophub/model/ad_model.dart';
import '../../utils/log.dart';

class AdEditPage extends StatelessWidget {
  final AdModel ad;

  const AdEditPage({required this.ad, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '광고 상세 정보',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ad.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${ad.startDate?.year}.${ad.startDate?.month.toString().padLeft(2, '0')}.${ad.startDate?.day.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            if (ad.imageUrls.isNotEmpty)
              Image.network(
                ad.imageUrls as String,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  Logger.error('이미지 로드 중 에러 발생: $error');
                  Logger.error('스택 트레이스: $stackTrace');
                  return Column(
                    children: [
                      const Text('이미지를 불러올 수 없습니다.'),
                      const SizedBox(height: 8),
                      Text('에러: $error',
                          style: const TextStyle(color: Colors.red)),
                    ],
                  );
                },
              )
            else
              const Text('이미지가 없습니다.'),
            const SizedBox(height: 16),
            Text(
              ad.content ?? '내용 없음',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
