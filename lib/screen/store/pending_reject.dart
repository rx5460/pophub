import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/screen/alarm/alarm.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/store/store_list.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/log.dart';

class PendingRejectPage extends StatefulWidget {
  final String id; // final로 수정

  const PendingRejectPage({super.key, required this.id});

  @override
  State<PendingRejectPage> createState() => _PendingRejectPageState();
}

class _PendingRejectPageState extends State<PendingRejectPage> {
  TextEditingController denyController = TextEditingController();

  Future<void> popupStoreDeny() async {
    try {
      final response =
          await StoreApi.postPopupDeny(widget.id, denyController.text);
      final responseString = response.toString();
      final applicantUsername =
          RegExp(r'\{data: (.+?)\}').firstMatch(responseString)?.group(1) ??
              ''; // userName 찾는 정규식

      if (applicantUsername.isNotEmpty && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(('rejection_has_been_completed').tr()),
          ),
        );

        final Map<String, String> alarmDetails = {
          'title': ('popup_registration_rejected').tr(),
          'label': ('our_popup_registration_has_been_rejected').tr(),
          'time': DateFormat(('mm_month_dd_day_hh_hours_mm_minutes').tr())
              .format(DateTime.now()),
          'active': 'true',
          'storeId': widget.id,
        };

        // 서버에 알람 추가
        await http.post(
          Uri.parse('http://3.233.20.5:3000/alarm/alarm_add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userName': applicantUsername,
            'type': 'alarms',
            'alarmDetails': alarmDetails,
          }),
        );

        // Firestore에 알람 추가
        await FirebaseFirestore.instance
            .collection('users')
            .doc(applicantUsername)
            .collection('alarms')
            .add(alarmDetails);

        // 로컬 알림 발송
        await const AlarmList().showNotification(alarmDetails['title']!,
            alarmDetails['label']!, alarmDetails['time']!);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(('rejection_has_been_completed').tr()),
          ),
        );
        Navigator.of(context).pop();

        final data = await StoreApi.getPendingList();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreListPage(
                      popups: data,
                      titleName: ('titleName_1').tr(),
                      mode: "pending",
                    )));
      } else {
        Logger.debug(('rejection_failed').tr());
      }
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleBar(titleName: ('titleName_24').tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ('reason_for_rejection').tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              controller: denyController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  popupStoreDeny();
                },
                child: Text(
                  ('complete').tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
