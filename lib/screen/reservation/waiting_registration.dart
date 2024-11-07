import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/waiting_model.dart';
import 'package:pophub/screen/reservation/waiting_info.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';

class WaitingRegistration extends StatefulWidget {
  final int count;
  final PopupModel popup;
  const WaitingRegistration(
      {super.key, required this.count, required this.popup});

  @override
  State<WaitingRegistration> createState() => _WaitingRegistrationState();
}

class _WaitingRegistrationState extends State<WaitingRegistration> {
  bool isLoading = true;
  List<WaitingModel> reserveList = [];
  Future<void> getWaitingList() async {
    try {
      final data = await ReservationApi.getPopupWaiting(widget.popup.id!);
      if (!data.toString().contains("fail")) {
        setState(() {
          reserveList = data;
          isLoading = false;
        });
      } else {
        Logger.debug('Error fetching reservation data');
      }
    } catch (e) {
      Logger.debug('Error in getReserveList: $e');
    }
  }

  Future<void> waitingApi() async {
    try {
      Map<String, dynamic> data =
          await ReservationApi.postPopupWaiting(widget.popup.id!, widget.count);

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaitingInfo(
                popup: widget.popup,
              ),
            ),
          );
          // showAlert(context, ('guide').tr(), '현장 대기에 성공했습니다.', () async {
          //   Navigator.pop(context);
          //   Navigator.pop(context);
          // });
        }
      }
    } catch (e) {
      print('Error during waiting: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWaitingList();
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        child: Text(
                          widget.popup.name!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        child: Text(
                          ('would_you_like_to_register_for_a_reservation').tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        child: Container(
                          height: screenHeight * 0.12,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: Constants.DEFAULT_COLOR),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                ('currently_waiting').tr(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    reserveList[0].count.toString(),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    ('team').tr(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Container(
                          height: 2,
                          width: screenWidth,
                          color: Constants.DEFAULT_COLOR,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.03,
                            bottom: screenHeight * 0.03,
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ('total_number_of_attendees').tr(),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${widget.count} 명',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Text(
                          ('precautions_for_waiting_in_store').tr(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Text(
                          ('please_be_sure_to_check_the_admission_information_notice')
                              .tr(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Text(
                          ('entry_order_may_change_depending_on_the_number_of_people')
                              .tr(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      )
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
                          waitingApi();
                        },
                        child: Text(
                          ('register').tr(),
                          style: const TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
    );
  }
}
