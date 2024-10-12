import 'package:flutter/material.dart';
import 'package:pophub/model/achieve_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';
import 'package:intl/intl.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '업적',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Achievement>>(
        future: ClassAchieve.getAchiveList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Logger.debug('Error fetching achievements: ${snapshot.error}');
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
                    'assets/images/${getImageForAchievement(achievement.achieveTitle)}',
                    color: achievement.completeAt.isBefore(DateTime.now())
                        ? null
                        : Colors.grey,
                  ),
                  title: Text(achievement.achieveTitle),
                  subtitle: Text(
                    '완료일: ${formatDate(achievement.completeAt)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Icon(
                    achievement.completeAt.isBefore(DateTime.now())
                        ? Icons.check_circle
                        : Icons.lock,
                    color: achievement.completeAt.isBefore(DateTime.now())
                        ? const Color(0xFFE6A3B3)
                        : Colors.red,
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
    case '오랜 친구':
      return 'long_friend.png';
    case 'wating...':
      return 'waiting';
    default:
      return 'logo.png';
  }
}

class ClassAchieve {
  static String domain = "http://3.233.20.5:3000";

  static Future<List<Achievement>> getAchiveList() async {
    try {
      final List<dynamic> dataList = await getListData(
        '$domain/user/achieveHub/?userName=${User().userName}',
        {},
      );
      return dataList.map((data) => Achievement.fromJson(data)).toList();
    } catch (e) {
      Logger.debug('Failed to fetch achive list: $e');
      throw Exception('Failed to fetch achive list');
    }
  }
}
