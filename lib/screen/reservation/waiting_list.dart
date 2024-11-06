import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/waiting_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/log.dart';

class WaitingList extends StatefulWidget {
  final String popup;
  const WaitingList({Key? key, required this.popup}) : super(key: key);

  @override
  State<WaitingList> createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  List<WaitingModel> reserveList = [];
  bool isLoading = true;

  Future<void> getWaitingList() async {
    try {
      final data = await ReservationApi.getPopupWaiting("widget.popup");
      if (data.isNotEmpty && !data.toString().contains("fail")) {
        setState(() {
          reserveList = data;
          isLoading = false;
        });
      } else {
        Logger.debug('Error fetching reservation data');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Logger.debug('Error in getReserveList: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> waitingApi(String waiting) async {
    try {
      Map<String, dynamic> data =
          await ReservationApi.waitingadmission(waiting);

      if (!data.toString().contains("fail")) {
        await getWaitingList();
      }

      if (mounted) {
        ToastUtil.customToastMsg(('certified').tr(), context);
      }
    } catch (e) {
      Logger.debug('Error during waiting: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWaitingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return Scaffold(
      appBar: CustomTitleBar(
        titleName: "make_a_waiting".tr(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reserveList.isEmpty || reserveList[0].result.isEmpty
              ? Center(
                  child: Text(
                    ('there_is_no_reservation_list').tr(),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                )
              : ListView.builder(
                  itemCount: reserveList[0].result.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              width: 1, color: Constants.DEFAULT_COLOR),
                          bottom: BorderSide(
                              width: 1, color: Constants.DEFAULT_COLOR),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: SizedBox(
                          width: screenWidth,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  reserveList[0]
                                      .result[index]
                                      .userName
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  ('total_count_people').tr(args: [
                                    reserveList[0]
                                        .result[index]
                                        .capacity
                                        .toString(),
                                  ]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (reserveList[0].result[index].status ==
                                  "pending")
                                Expanded(
                                  flex: 1,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      waitingApi(reserveList[0]
                                          .result[index]
                                          .reservationId!);
                                    },
                                    child: const Text('입장'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
