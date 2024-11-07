import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/waiting_model.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/log.dart';

class WaitingInfo extends StatefulWidget {
  final PopupModel popup;
  const WaitingInfo({
    super.key,
    required this.popup,
  });

  @override
  State<WaitingInfo> createState() => _WaitingInfoState();
}

class _WaitingInfoState extends State<WaitingInfo> {
  bool isLoading = true;
  List<WaitingResultModel> reserveList = [];
  Future<void> getWaitingData() async {
    try {
      final data = await ReservationApi.getWaitingData(widget.popup.id!);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWaitingData();
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
                        child: Row(
                          children: [
                            Text(
                              widget.popup.name!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 24,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        child: Text(
                          ('display').tr(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Constants.DARK_GREY),
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
                            // bottom: screenHeight * 0.03,
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ('my_order').tr(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    reserveList[0].position.toString(),
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    ('th').tr(),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  ('waiting_number').tr(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${reserveList[0].position}번',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${DateFormat('yyyy.MM.dd HH:mm').format(reserveList[0].createdAt!)} 등록',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Constants.DARK_GREY),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.03),
                        child: Container(
                          height: 2,
                          width: screenWidth,
                          color: Constants.DEFAULT_COLOR,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.03,
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Text(
                          ('properties').tr(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${reserveList[0].capacity} 명',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
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
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          ('close').tr(),
                          style: const TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
    );
  }
}
