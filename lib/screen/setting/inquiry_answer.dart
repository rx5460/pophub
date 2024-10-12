import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/model/inquiry_model.dart';
import 'package:pophub/screen/alarm/alarm.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry.dart';
import 'package:pophub/utils/api/inquiryl_api.dart';
import 'package:pophub/utils/utils.dart';

class InquiryAnswerPage extends StatefulWidget {
  final int inquiryId;
  const InquiryAnswerPage({super.key, required this.inquiryId});

  @override
  _InquiryAnswerPageState createState() => _InquiryAnswerPageState();
}

class _InquiryAnswerPageState extends State<InquiryAnswerPage> {
  final _answerContentController = TextEditingController();
  InquiryModel? inquiry;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getInquiryData();
  }

  Future<void> _submitInquiry() async {
    String content = _answerContentController.text;

    // 서버로부터 데이터를 받아옴
    Map<String, dynamic> data =
        await InquiryApi.postInquiryAnswer(widget.inquiryId, content);

    if (!data.toString().contains("fail")) {
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InquiryPage(),
          ),
        );
      }

      // 서버로부터 받은 데이터에서 userName 추출
      String userName = data['userName'];

      final Map<String, String> alarmDetails = {
        'title': ('inquiry_response_completed').tr(),
        'label': ('an_administrator_has_responded_to_this_inquiry').tr(),
        'time': DateFormat(('mm_month_dd_day_hh_hours_mm_minutes').tr())
            .format(DateTime.now()),
        'active': 'true',
        'inquiryId': widget.inquiryId.toString(),
      };

      // 알람을 서버와 Firestore에 각각 한 번만 추가
      await Future.wait([
        // 서버에 알람 추가
        http.post(
          Uri.parse('http://3.233.20.5:3000/alarm/alarm_add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userName': userName,
            'type': 'alarms',
            'alarmDetails': alarmDetails,
          }),
        ),
        // Firestore에 알람 추가
        FirebaseFirestore.instance
            .collection('users')
            .doc(userName)
            .collection('alarms')
            .add(alarmDetails)
      ]);

      // 로컬 알림 발송
      await const AlarmList().showNotification(alarmDetails['title']!,
          alarmDetails['label']!, alarmDetails['time']!);
    } else {
      if (mounted) {
        showAlert(context, ('warning').tr(), ('failed_to_add_answer').tr(), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> getInquiryData() async {
    final content = await InquiryApi.getInquiry(widget.inquiryId);
    setState(() {
      inquiry = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: CustomTitleBar(titleName: ('titleName_8').tr()),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.05,
          bottom: screenHeight * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(('inquiry_subject').tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    inquiry != null ? inquiry!.title.toString() : "",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(('inquiry_details').tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiry != null ? inquiry!.content.toString() : "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        inquiry != null
                            ? inquiry!.image != null
                                ? Image.network(
                                    inquiry!.image.toString(),
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  )
                                : Container()
                            : Container(),
                      ],
                    )),
              ),
              const SizedBox(height: 16),
              Text(('answer_content').tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _answerContentController,
                decoration: InputDecoration(hintText: ('hintText_10').tr()),
                maxLines: 6,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _submitInquiry,
                child: Text(('complete').tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
