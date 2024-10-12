import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/notice_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/notice_detail.dart';
import 'package:pophub/screen/setting/notice_write.dart';
import 'package:pophub/utils/api/notice_api.dart';
import 'package:pophub/utils/log.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  void initState() {
    getPopupData();
    super.initState();
  }

  List<NoticeModel> notices = [];
  Future<void> getPopupData() async {
    try {
      final data = await NoticeApi.getNoticeList();
      setState(() {
        notices = data;
      });
      Logger.debug("### $data");
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return Scaffold(
      appBar: CustomTitleBar(titleName: ('titleName_13').tr()),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoticeWrite(),
          ),
        );
      }),
      body: notices.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 0.5, color: Constants.DARK_GREY))),
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return NoticeTile(
                    title: ('title_2').tr(),
                    date: "2024-08-24",
                    content: ('content').tr(),
                  );
                },
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 0.5, color: Constants.DARK_GREY))),
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return NoticeTile(
                    title: ('title_2').tr(),
                    date: "2024-08-24",
                    content: ('content').tr(),
                  );
                },
              ),
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
    return DecoratedBox(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Constants.DARK_GREY)),
            borderRadius: BorderRadius.all(Radius.zero)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoticeDetail(
                  title: title,
                  date: date,
                  content: content,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat("yyyy.MM.dd").format(DateTime.parse(date)),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                ),
              ],
            ),
          ),
        ));
  }
}
