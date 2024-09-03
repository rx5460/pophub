import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmSettingsPage extends StatefulWidget {
  const AlarmSettingsPage({super.key});

  @override
  _AlarmSettingsPageState createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  bool _pushNotification = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isNotified = prefs.getBool('isNotified') ?? false;
    setState(() {
      _pushNotification = isNotified;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    setState(() {
      _pushNotification = value;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotified', value);

    if (value) {
      // 푸시 알림을 켤 때 FCM 구독
      await FirebaseMessaging.instance.subscribeToTopic('all_users');
    } else {
      // 푸시 알림을 끌 때 FCM 구독 해제
      await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '알림 설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              title: const Text(
                '푸시 알림 ON / OFF',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _pushNotification,
              onChanged: (bool value) {
                _toggleNotification(value);
              },
              activeColor: const Color(0xFFE6A3B3),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
