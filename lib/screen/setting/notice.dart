import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/notice_model.dart';
import 'package:pophub/model/user.dart';
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
      Logger.debug('Error fetching popup data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return Scaffold(
      appBar: CustomTitleBar(titleName: ('titleName_13').tr()),
      floatingActionButton: Visibility(
        visible: User().role == "Manager",
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoticeWritePage(),
              ),
            );
          },
          heroTag: null,
          backgroundColor: Constants.DEFAULT_COLOR,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: notices.isNotEmpty
          ? ListView.builder(
              itemCount: notices.length,
              itemBuilder: (BuildContext context, int index) {
                return NoticeTile(
                  title: notices[index].title,
                  date: notices[index].time,
                  content: notices[index].content,
                );
              },
            )
          : const Center(
              child: Text(
              "공지사항이 없습니다.",
              style: TextStyle(fontSize: 16),
            )),
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
