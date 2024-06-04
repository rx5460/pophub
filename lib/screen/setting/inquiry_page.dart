import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry_write_page.dart';
import 'package:pophub/utils/log.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  void initState() {
    getInquiryData();
    super.initState();
  }

  List<String> notices = [];
  Future<void> getInquiryData() async {
    try {
      // final data = await Api.getInquiryList(User().userName);

      // Logger.debug("### $data");
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Scaffold(
        appBar: const CustomTitleBar(titleName: "문의 내역"),
        body: Padding(
          padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: notices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                  // return NoticeTile(
                  //   title: notices[index].title,
                  //   date: notices[index].time,
                  //   content: notices[index].content,
                  // );
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
                                builder: (context) =>
                                    // const InquiryAnswerPage()))
                                    const InquiryWritePage()))
                      },
                  child: const Text("문의 하기")),
              // child: const Text("문의 답변 하기")),
            )
          ]),
        ));
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
    return DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Constants.LIGHT_GREY,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.zero)),
        child: ExpansionTile(
          title: Text(title),
          subtitle: Text(DateFormat("yyyy.MM.dd").format(DateTime.parse(date))),
          children: <Widget>[
            Container(
              color: Constants.LIGHT_GREY,
              padding: const EdgeInsets.all(16.0),
              child: Text(content),
            ),
          ],
        ));
  }
}
