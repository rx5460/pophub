import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pophub/screen/alarm/push_auto_token.dart';
import 'package:pophub/screen/nav/bottom_navigation_page.dart';
import 'package:pophub/utils/log.dart';

import 'assets/style.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log("백그라운드 메시지 처리: ${message.notification!.body!}",
      name: 'app.background');
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'PopHub_channel', 'PopHub Notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // FCM 알림 초기화
  initializeNotification();

  final pushNotificationService = PushNotificationService();
  await pushNotificationService.init();

  await dotenv.load(fileName: 'assets/config/.env');

  AuthRepository.initialize(
    appKey: dotenv.env['APP_KEY'] ?? '',
  );

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.setLogLevel(LogLevel.debug); // 로그 레벨 설정
    Logger.debug('APP start ! ');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'pophub',
      theme: theme,
      home: const BottomNavigationPage(),
    );
  }
}
