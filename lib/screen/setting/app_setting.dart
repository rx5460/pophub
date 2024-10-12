import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/screen/setting/alarm_setting.dart';
import 'package:pophub/screen/setting/withdrawal.dart';
import 'package:pophub/utils/http.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  Future<void> logout() async {
    await secureStorage.deleteAll();
    User().clear();

    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigationPage()));
    }
  }

  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          CustomTitleBar(titleName: ('titleName_15').tr()),
          ListTile(
            title: Text(('notification_settings').tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 알림 설정 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AlarmSettingsPage()),
              );
            },
          ),
          // ListTile(
          //   title: Text('약관'),
          //   trailing: const Icon(Icons.arrow_forward_ios),
          //   onTap: () {
          //     // 약관 페이지로 이동
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Container()),
          //     );
          //   },
          // ),
          ListTile(
            title: Text(('log_out').tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              logout();
            },
          ),
          ListTile(
            title: Text(('titleName_11').tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WithdrawalPage()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(('app_version_01').tr()),
          ),
        ],
      ),
    );
  }
}
