import 'package:flutter/material.dart';

class AlarmSettingsPage extends StatefulWidget {
  const AlarmSettingsPage({super.key});

  @override
  _AlarmSettingsPageState createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  bool _pushNotification = false;

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
              title: const Text('푸시 알림 ON / OFF'),
              value: _pushNotification,
              onChanged: (bool value) {
                setState(() {
                  _pushNotification = value;
                });
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
