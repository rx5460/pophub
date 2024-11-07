import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/waiting_model.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/log.dart';

class WaitingList extends StatefulWidget {
  final String popup;
  const WaitingList({super.key, required this.popup});

  @override
  State<WaitingList> createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  List<WaitingModel> reserveList = [];
  Future<void> getWaitingList() async {
    try {
      final data = await ReservationApi.getPopupWaiting(widget.popup);
      if (!data.toString().contains("fail")) {
        setState(() {
          reserveList = data;
        });
      } else {
        Logger.debug('Error fetching reservation data');
      }
    } catch (e) {
      Logger.debug('Error in getReserveList: $e');
    }
  }

  Future<void> waitingApi(String waiting) async {
    try {
      Map<String, dynamic> data =
          await ReservationApi.waitingadmission(waiting);

      if (data.toString().contains("fail")) {
      } else {
        setState(() {});
      }
    } catch (e) {
      print('Error during waiting: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int index = 0; index < (reserveList.length ?? 0); index++)
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 1, color: Constants.DEFAULT_COLOR),
                        bottom: BorderSide(
                            width: 1, color: Constants.DEFAULT_COLOR))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(reserveList[0].result[index].userName.toString()),
                      Visibility(
                          visible:
                              reserveList[0].result[index].status == "pending",
                          child: OutlinedButton(
                              onPressed: () {
                                waitingApi(reserveList[0]
                                    .result[index]
                                    .reservationId!);
                              },
                              child: const Text('입장'))),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
