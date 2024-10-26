import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/reservation/waiting_registration.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/utils.dart';

class WaitingCount extends StatefulWidget {
  final String popup;
  const WaitingCount({super.key, required this.popup});

  @override
  State<WaitingCount> createState() => _WaitingCountState();
}

class _WaitingCountState extends State<WaitingCount> {
  int count = 1;

  Future<void> waitingApi() async {
    try {
      Map<String, dynamic> data =
          await ReservationApi.postPopupWaiting(widget.popup, count);

      if (data.toString().contains("fail")) {
        if (mounted) {
          // 예약 실패 알림 표시 및 대기 목록 추가 확인
          showAlert(context, ('warning').tr(), ('현장 대기에 실패했습니다.').tr(),
              () async {
            Navigator.of(context).pop();
          });
        }
      } else {
        print(('reservation_successful').tr());
        if (mounted) {
          print(('reservation_successful_mount').tr());
          showAlert(context, ('guide').tr(), '현장 대기에 성공했습니다.', () async {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      print('Error during waiting: $e');
    }
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
          ('make_a_waiting').tr(),
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
            height: screenHeight * 0.19,
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
              width: 1,
              color: Constants.DEFAULT_COLOR,
            ))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 18,
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
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      bottom: screenHeight * 0.04),
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.07,
                    child: OutlinedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => WaitingRegistration(
                          //       popup: widget.popup,
                          //       count: count,
                          //     ),
                          //   ),
                          // );
                          waitingApi();
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
