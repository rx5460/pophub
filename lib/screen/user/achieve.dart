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
    throw Exception('Failed to load achievements');
  }
}

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('업적'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Achievement>>(
        future: fetchAchievements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('업적을 불러오는데 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('아직 달성한 업적이 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final achievement = snapshot.data![index];
                return ListTile(
                  leading: Image.asset(
                    'assets/img/${achievement.imageUrl}.png',
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
