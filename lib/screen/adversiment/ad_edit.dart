import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pophub/model/ad_model.dart';
import '../../utils/log.dart';

class AdEditPage extends StatefulWidget {
  final AdModel ad;

  const AdEditPage({required this.ad, Key? key}) : super(key: key);

  @override
  State<AdEditPage> createState() => _AdEditPageState();
}

class _AdEditPageState extends State<AdEditPage> {
  final Color pinkColor = const Color(0xFFE6A3B3);

  Future<void> _registerAd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 등록할 광고를 SharedPreferences에 저장
    List<String>? storedAds = prefs.getStringList('selected_ads');
    storedAds = storedAds ?? [];

    if (!storedAds.contains(jsonEncode(widget.ad.toJson()))) {
      storedAds.add(jsonEncode(widget.ad.toJson()));
    }

    await prefs.setStringList('selected_ads', storedAds);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.ad.title} 광고가 등록되었습니다!")),
    );

    // 광고 등록 후 true 값을 반환
    Navigator.pop(context, true);
  }

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
              widget.ad.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.ad.startDate?.year}.${widget.ad.startDate?.month.toString().padLeft(2, '0')}.${widget.ad.startDate?.day.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.ad.img.isNotEmpty)
              Image.network(
                widget.ad.img,
                width: 500,
                height: 500,
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerAd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  '광고 등록',
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
