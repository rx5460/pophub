import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/model/achieve_model.dart';

// 업적 데이터 불러오기
Future<List<Achievement>> fetchAchievements() async {
  final response =
      await http.get(Uri.parse('http://3.88.120.90/user/achieveHub'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Achievement.fromJson(data)).toList();
  } else {
    throw Exception('업적 조회에 실패했습니다.');
  }
}

// 업적 아이콘 매핑
String getImageForAchievement(String title) {
  switch (title) {
    case '리뷰 스타터':
      return 'review_starter.png';
    case '어서와? PopHub는 처음이지?':
      return 'first.png';
    case '탐색의 여정':
      return 'search.png';
    case '응원의 손길':
      return 'cheer_up.png';
    case '첫 걸음':
      return 'first_start.png';
    case '탐험의 시작':
      return 'adventure.png';
    case '소중한 조언자':
      return 'good_answer.png';
    default:
      return 'logo.png';
  }
}

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '업적',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Achievement>>(
        future: fetchAchievements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                '업적을 불러오는데 오류가 발생했습니다.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                '아직 달성한 업적이 없습니다!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final achievement = snapshot.data![index];
                return ListTile(
                  leading: Image.asset(
                    'assets/img/${getImageForAchievement(achievement.title)}',
                    color: achievement.isUnlocked ? null : Colors.grey,
                  ),
                  title: Text(achievement.title),
                  subtitle: Text(achievement.description),
                  trailing: Icon(
                    achievement.isUnlocked ? Icons.check_circle : Icons.lock,
                    color: achievement.isUnlocked ? Colors.green : Colors.red,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
