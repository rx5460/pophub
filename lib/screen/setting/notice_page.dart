import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  _NoticePageState createState() => _NoticePageState();
}

class Notice {
  final String title;
  final String date;
  final String content;

  Notice({required this.title, required this.date, required this.content});
}

class _NoticePageState extends State<NoticePage> {
  @override
  void initState() {
    getPopupData();
    super.initState();
  }

  Future<void> getPopupData() async {
    try {
      final data = await Api.getNoticeList();
      Logger.debug("### $data");
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  ///TODO : 황지민 api 붙이기
  List<Notice> notices = [
    Notice(
      title: '점검 안내 공지',
      date: '2024.05.17',
      content: '''안녕하세요, 팝허브입니다. ... (생략) ... 최선을 다하겠습니다.''',
    ),
    Notice(
      title: '점검 안내 공지',
      date: '2024.04.17',
      content: '''안녕하세요, 팝허브입니다. ... (생략) ... 최선을 다하겠습니다.''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "공지 사항"),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (BuildContext context, int index) {
          return NoticeTile(
            title: notices[index].title,
            date: notices[index].date,
            content: notices[index].content,
          );
        },
      ),
    );
  }
}

class NoticeTile extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  const NoticeTile(
      {super.key,
      required this.title,
      required this.date,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        // Card를 사용하여 그림자와 테두리를 추가
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Constants.LIGHT_GREY,
                  width: 0.5,
                ),
                borderRadius: const BorderRadius.all(Radius.zero)),
            child: ExpansionTile(
              title: Text(title),
              subtitle: Text(date),
              children: <Widget>[
                Container(
                  color: Constants.LIGHT_GREY,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(content),
                ),
              ],
            )));
  }
}
