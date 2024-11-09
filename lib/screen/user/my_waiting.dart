import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/model/waiting_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/reservation/waiting_info.dart';
import 'package:pophub/utils/api/reservation_api.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';

class MyWaiting extends StatefulWidget {
  const MyWaiting({super.key});

  @override
  State<MyWaiting> createState() => _MyWaitingState();
}

class _MyWaitingState extends State<MyWaiting> {
  List<WaitingResultModel> reserveList = [];
  List<String> imageList = [];
  List<String> storeName = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await getReserveList();
    } catch (e) {
      Logger.debug('Error initializing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getReserveList() async {
    try {
      final data = await ReservationApi.getWaitingByUserName();
      if (!data.toString().contains("fail")) {
        setState(() {
          reserveList = data;
        });
        await getPopupData(reserveList);
      } else {
        Logger.debug('Error fetching reservation data');
      }
    } catch (e) {
      Logger.debug('Error in getReserveList: $e');
    }
  }

  Future<void> alarmDelete(reserveId) async {
    try {
      final data = await ReservationApi.deleteWaiting(reserveId);
      if (!data.toString().contains("fail") && mounted) {
        showAlert(
            context, ('success').tr(), ('notification_has_been_deleted').tr(),
            () {
          Navigator.of(context).pop();
          setState(() {
            reserveList
                .removeWhere((element) => element.reservationId == reserveId);
          });
          _refreshData();
        });
      }
    } catch (e) {
      Logger.debug('Error in alarmDelete: $e');
    }
  }

  Future<void> getPopupData(List<WaitingResultModel> list) async {
    imageList = [];
    storeName = [];
    for (WaitingResultModel reserve in list) {
      try {
        PopupModel? popup = await StoreApi.getPopup(
            reserve.storeId.toString(), false, reserve.userName.toString());
        setState(() {
          imageList.add(popup.image != null && popup.image!.isNotEmpty
              ? popup.image![0]
              : 'assets/images/logo.png');
          storeName.add(popup.name ?? 'No name');
        });
      } catch (error) {
        Logger.debug('Error fetching popup data: $error');
        setState(() {
          imageList.add('assets/images/logo.png');
          storeName.add('No name');
        });
      }
    }
  }

  Future<void> viewWaitingInfo(String popupId) async {
    try {
      PopupModel? data =
          await StoreApi.getPopup(popupId, false, User().userName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingInfo(
            mode: 'info',
            popup: data,
          ),
        ),
      );
    } catch (e) {
      Logger.debug('Error in getPopupData: $e');
    }
  }

  Future<void> _refreshData() async {
    await initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTitleBar(titleName: '현장대기 내역'),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : reserveList.isEmpty
                ? Center(
                    child: Text(
                      ('there_is_no_reservation_list').tr(),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  )
                : ListView.builder(
                    itemCount: reserveList.length,
                    itemBuilder: (context, index) {
                      final reserve = reserveList[index];
                      return GestureDetector(
                        onTap: () {
                          viewWaitingInfo(reserve.storeId!);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageList.length > index
                                    ? Image.network(
                                        imageList[index],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/logo.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storeName.length > index
                                          ? storeName[index]
                                          : 'No name',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          (reserve.createdAt != null)
                                              ? DateFormat("yyyy.MM.dd HH:mm")
                                                  .format(DateTime.parse(reserve
                                                      .createdAt
                                                      .toString()))
                                              : '',
                                        ),
                                        // const SizedBox(width: 5.0), // 간격 추가
                                        // Text((reserve.time != null &&
                                        //         reserve.time!.isNotEmpty)
                                        //     ? DateFormat("HH:mm").format(
                                        //         DateFormat("HH:mm:ss")
                                        //             .parse(reserve.time!))
                                        //     : ''),
                                      ],
                                    ),
                                    // Visibility(
                                    //   visible: widget.mode == "store",
                                    //   child: Row(
                                    //     children: [
                                    //       const Text("id_").tr(args: [
                                    //         reserve.userName != null
                                    //             ? reserve.userName.toString()
                                    //             : ""
                                    //       ]),
                                    //     ],
                                    //   ),
                                    // ),
                                    Row(
                                      children: [
                                        const Text("number_of_people__people")
                                            .tr(args: [
                                          (reserve.capacity != null)
                                              ? reserve.capacity.toString()
                                              : ''
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(('delete').tr()),
                                        content: Text(
                                            ('are_you_sure_you_want_to_delete_the_notification')
                                                .tr()),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(('cancellation').tr()),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              alarmDelete(
                                                  reserve.reservationId);
                                            },
                                            child: Text(('delete').tr()),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
