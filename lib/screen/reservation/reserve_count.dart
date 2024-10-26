import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/alarm/alarm.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/utils.dart';

class ReserveCount extends StatefulWidget {
  final String date;
  final String popup;
  final String time;
  const ReserveCount(
      {super.key, required this.date, required this.popup, required this.time});

  @override
  State<ReserveCount> createState() => _ReserveCountState();
}

class _ReserveCountState extends State<ReserveCount> {
  int count = 1;

  Future<void> reservationApi() async {
    try {
      String userName = User().userName;
      Map<String, dynamic> data =
          await ReservationApi.postPopupReservationWithDetails(
              userName, widget.popup, widget.date, widget.time, count);

      if (data.toString().contains("fail")) {
        if (mounted) {
          // 예약 실패 알림 표시 및 대기 목록 추가 확인
          showAlert(
              context,
              ('warning').tr(),
              ('advance_reservation_failed_would_you_like_to_be_added_to_the_waiting_list')
                  .tr(), () async {
            Navigator.of(context).pop();
            await addToWaitlist();
          });
        }
      } else {
        await sendAlarmAndNotification();
        print(('reservation_successful').tr());
        if (mounted) {
          print(('reservation_successful_mount').tr());
          showAlert(context, ('guide').tr(), ('preorder_was_successful').tr(),
              () async {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      print('Error during reservation: $e');
      if (mounted) {
        showAlert(
            context,
            ('error').tr(),
            ('an_error_occurred_while_making_a_reservation_please_try_again')
                .tr(), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> addToWaitlist() async {
    try {
      String userName = User().userName;
      final response = await http.post(
        Uri.parse('http://3.233.20.5:3000/alarm/waitlist_add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': userName,
          'storeId': widget.popup,
          'date': widget.date,
          'desiredTime': widget.time,
        }),
      );

      if (response.statusCode == 201) {
        showAlert(context, ('alarm').tr(),
            ('you_have_been_successfully_added_to_the_waiting_list').tr(), () {
          Navigator.of(context).pop();
        });
      } else {
        showAlert(
            context, ('error').tr(), ('adding_to_standby_list_failed').tr(),
            () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print('Error during adding to waitlist: $e');
      showAlert(
          context,
          ('error').tr(),
          ('an_error_occurred_while_adding_to_the_standby_list_please_try_again')
              .tr(), () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> sendAlarmAndNotification() async {
    final Map<String, String> alarmDetails = {
      'title': ('preorder_completed').tr(),
      'label': ('your_preorder_has_been_completed_successfully').tr(),
      'time': DateFormat(('mm_month_dd_day_hh_hours_mm_minutes').tr())
          .format(DateTime.now()),
      'active': 'true',
    };

    // 서버에 알람 추가
    await http.post(
      Uri.parse('http://3.233.20.5:3000/alarm_add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': User().userName,
        'type': 'alarms',
        'alarmDetails': alarmDetails,
      }),
    );

    // Firestore에 알람 추가
    await FirebaseFirestore.instance
        .collection('users')
        .doc(User().userName)
        .collection('alarms')
        .add(alarmDetails);

    // 로컬 알림 발송
    await const AlarmList().showNotification(
        alarmDetails['title']!, alarmDetails['label']!, alarmDetails['time']!);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          ('make_a_reservation').tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ('please_select_the_number_of_people_who_will_visit').tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ('number_of_people').tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (count != 1) count -= 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Icon(
                              Icons.remove,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              count += 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Icon(
                              Icons.add,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight * 0.18,
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
              width: 1,
              color: Constants.DEFAULT_COLOR,
            ))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 12,
                      bottom: 16,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ('number_of_visitors').tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ('total_count_people').tr(args: [count.toString()]),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.07,
                    child: OutlinedButton(
                        onPressed: () {
                          reservationApi();
                        },
                        child: Text(
                          ('next').tr(),
                          style: const TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
