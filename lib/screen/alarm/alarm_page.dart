import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pophub/model/user.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    initializeNotifications();
    setupListeners();
  }

  void initializeNotifications() {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialization);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void setupListeners() {
    List<String> collections = ['alarms', 'orderAlarms', 'waitAlarms'];
    for (var collection in collections) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(User().userId)
          .collection(collection)
          .snapshots()
          .listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            var data = change.doc.data() as Map<String, dynamic>;
            String notificationMessage;
            switch (collection) {
              case 'alarms':
                notificationMessage = "전체";
                break;
              case 'orderAlarms':
                notificationMessage = "주문";
                break;
              case 'waitAlarms':
                notificationMessage = "대기";
                break;
              default:
                notificationMessage = "알 수 없음";
            }
            showNotification("${data['title']} \n ${data['label']}",
                "새로운 $notificationMessage 알람이 왔습니다!");
            setState(() {});
          }
        }
      });
    }
  }

  Future<void> showNotification(String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      "channelId",
      "Local Notification",
      channelDescription: "Your description",
      importance: Importance.high,
    );
    var generalDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, body, generalDetails);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '알림',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: const Color(0xFFADD8E6),
          indicatorColor: const Color(0xFFADD8E6),
          indicatorWeight: 3.5,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 20),
          tabs: [
            Tab(
                child: Container(
              child: Center(child: Text('전체')),
              width: MediaQuery.of(context).size.width * 0.33,
            )),
            Tab(
                child: Container(
              child: Center(child: Text('주문')),
              width: MediaQuery.of(context).size.width * 0.33,
            )),
            Tab(
                child: Container(
              child: Center(child: Text('대기')),
              width: MediaQuery.of(context).size.width * 0.33,
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAlarmList('alarms'),
          buildAlarmList('orderAlarms'),
          buildAlarmList('waitAlarms'),
        ],
      ),
    );
  }

  Widget buildAlarmList(String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(User().userId)
          .collection(collection)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Text('No data available');
        }
        return ListView(
          children: snapshot.data!.docs.map((document) {
            var data = document.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 65,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          'https://www.valuevenue.co.kr/upload_files/event/202401/t1024_67a306e93f0610cbdfb5921de98d34ad.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data['title'] ?? 'No title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(data['label'] ?? 'No label'),
                        Text(data['time'] ?? 'No time'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      document.reference.delete();
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
