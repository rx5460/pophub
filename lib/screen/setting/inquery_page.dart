import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquery_answer_page.dart';
import 'package:pophub/screen/setting/inquery_write_page.dart';

class InqueryPage extends StatefulWidget {
  const InqueryPage({super.key});

  @override
  _InqueryPageState createState() => _InqueryPageState();
}

class Notice {
  final String title;
  final String date;
  final String content;

  Notice({required this.title, required this.date, required this.content});
}

class _InqueryPageState extends State<InqueryPage> {
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
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
        appBar: const CustomTitleBar(titleName: "문의 내역"),
        body: Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.02, bottom: screenHeight * 0.05),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NoticeTile(
                        title: notices[index].title,
                        date: notices[index].date,
                        content: notices[index].content,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight * 0.02, right: screenHeight * 0.02),
                  child: OutlinedButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InquiryAnswerPage()))
                            // builder: (context) => InquiryWritePage()))
                          },
                      //    child: const Text("문의 하기")),
                      child: const Text("문의 답변 하기")),
                )
              ],
            )));
  }
}

class NoticeTile extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  NoticeTile({required this.title, required this.date, required this.content});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Container(
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Constants.LIGHT_GREY,
                  width: 0.5,
                ),
                borderRadius: const BorderRadius.all(Radius.zero)),
            child: ExpansionTile(
              title: Text(title),
              subtitle: SizedBox(
                width: screenWidth * 0.8,
                child: Row(
                  children: [
                    Text(date),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 50.0,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text("접수"),
                      ),
                    ),
                  ],
                ),
              ),
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
