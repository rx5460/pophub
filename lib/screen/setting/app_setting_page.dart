import 'package:flutter/material.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/alarm_setting_page.dart';
import 'package:pophub/screen/setting/withdrawal_page.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          const CustomTitleBar(titleName: "앱 설정"),
          ListTile(
            title: Text('알림 설정'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 알림 설정 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmSettingsPage()),
              );
            },
          ),
          ListTile(
            title: Text('약관'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 약관 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Container()),
              );
            },
          ),
          ListTile(
            title: Text('로그아웃'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 로그아웃 처리
              // 예: AuthService.logout();
            },
          ),
          ListTile(
            title: Text('회원 탈퇴'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WithdrawalPage()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('앱버전 0.1234'),
          ),
        ],
      ),
    );
  }
}
