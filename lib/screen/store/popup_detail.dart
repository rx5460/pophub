import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/review_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/screen/alarm/alarm_page.dart';
import 'package:pophub/screen/goods/goods_list.dart';
import 'package:pophub/screen/reservation/reserve_date.dart';
import 'package:pophub/screen/store/pending_reject_page.dart';
import 'package:pophub/screen/store/store_add_page.dart';
import 'package:pophub/screen/store/store_list_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';
import 'package:provider/provider.dart';

class PopupDetail extends StatefulWidget {
  final String storeId;
  final String mode;
  const PopupDetail({Key? key, required this.storeId, this.mode = "view"})
      : super(key: key);

  @override
  State<PopupDetail> createState() => _PopupDetailState();
}

class _PopupDetailState extends State<PopupDetail> {
  late KakaoMapController mapController;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  PopupModel? popup;
  List<ReviewModel>? reviewList;
  bool isLoading = true;
  double rating = 0;
  bool like = false;
  bool allowSuccess = false;
  LatLng center = LatLng(37.5586677131962, 126.953450474616);
  Set<Marker> markers = {};

  Future<void> getPopupData() async {
    try {
      PopupModel? data = await Api.getPopup(widget.storeId, true);

      setState(() {
        popup = data;
        center = LatLng(double.parse(popup!.y.toString()),
            double.parse(popup!.x.toString()));
        markers.add(Marker(markerId: '마커', latLng: center));
        isLoading = false;
      });
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  Future<void> getAddressData() async {
    final data = await Api.getAddress(popup!.location.toString());

    // JSON 문자열을 파싱합니다.
    // var jsonData = json.decode(data);

    // x와 y 좌표를 추출합니다.
    var documents = data['documents'];
    if (documents != null && documents.isNotEmpty) {
      var firstDocument = documents[0];
      var x = firstDocument['x'];
      var y = firstDocument['y'];

      setState(() {});
    } else {
      print('No documents found');
    }

    Logger.debug("### $data");
  }

  Future<void> popupStoreAllow() async {
    try {
      final response = await Api.popupAllow(widget.storeId);
      final responseString = response.toString();
      final applicantUsername =
          RegExp(r'\{data: (.+?)\}').firstMatch(responseString)?.group(1) ??
              ''; // userName 찾는 정규식

      if (applicantUsername.isNotEmpty && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('승인 완료되었습니다.'),
          ),
        );

        final alarmDetails = {
          'title': '팝업 승인 완료',
          'label': '성공적으로 팝업 등록이 완료되었습니다.',
          'time': DateFormat('MM월 dd일 HH시 mm분').format(DateTime.now()),
          'active': true,
          'storeId': widget.storeId,
        };

        // 서버에 알람 추가
        await http.post(
          Uri.parse('https://pophub-fa05bf3eabc0.herokuapp.com/alarm_add'),
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
        await AlarmPage().showNotification(
            alarmDetails['title'], alarmDetails['label'], alarmDetails['time']);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('승인 완료되었습니다.'),
          ),
        );
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StoreListPage()));

        setState(() {
          allowSuccess = true;
          isLoading = false;
        });
      } else {
        Logger.debug("승인에 실패했습니다.");
      }
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching popup data: $error');
    }
  }

  Future<void> fetchReviewData() async {
    try {
      List<ReviewModel>? dataList = await Api.getReviewList(widget.storeId);

      if (dataList.isNotEmpty) {
        setState(() {
          reviewList = dataList;
          for (int i = 0; i < dataList.length; i++) {
            rating += dataList[i].rating!;
          }
          rating = rating / dataList.length;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching review data: $error');
    }
  }

  Future<void> writeReview() async {
    Map<String, dynamic> data =
        await Api.writeReview(widget.storeId, 4, '볼거리가 많아요 !', User().userId);

    if (!data.toString().contains("fail")) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ReserveDate()),
      // );
      setState(() {
        isLoading = true;
      });
      getPopupData();
      fetchReviewData();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> popupLike() async {
    Map<String, dynamic> data =
        await Api.storeLike(User().userName, widget.storeId);

    if (data.toString().contains("추가")) {
      setState(() {
        like = true;
      });
    } else {
      setState(() {
        like = false;
      });
    }
  }

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    await getPopupData(); // getPopupData가 완료될 때까지 기다립니다.
    await getAddressData(); // getPopupData가 완료된 후 getAddressData를 호출합니다.
    fetchReviewData(); // fetchReviewData를 호출합니다.

    Logger.debug("###### $markers");
    Logger.debug("###### $center");
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    Set<Marker> markers = {};

    return Scaffold(
      body: !isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: screenHeight * 0.9,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          height: AppBar().preferredSize.height,
                          decoration: const BoxDecoration(color: Colors.white),
                        ),
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                sliderWidget(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Transform.translate(
                                      offset: Offset(0, -screenWidth * 0.1),
                                      child: Container(
                                        width: screenWidth * 0.17,
                                        height: screenWidth * 0.06,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${(_current + 1).toString()}/${popup!.image!.length}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.05,
                                      right: screenWidth * 0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                          popup?.name ?? '',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            (popup?.start != null &&
                                                    popup!.start!.isNotEmpty)
                                                ? DateFormat("yyyy.MM.dd")
                                                    .format(DateTime.parse(
                                                        popup!.start!))
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            ' ~ ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            (popup?.end != null &&
                                                    popup!.end!.isNotEmpty)
                                                ? DateFormat("yyyy.MM.dd")
                                                    .format(DateTime.parse(
                                                        popup!.end!))
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            (popup?.start != null &&
                                                    popup!.start!.isNotEmpty)
                                                ? DateFormat("hh:mm").format(
                                                    DateTime.parse(
                                                        popup!.start!))
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            ' ~ ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            (popup?.end != null &&
                                                    popup!.end!.isNotEmpty)
                                                ? DateFormat("HH:mm").format(
                                                    DateTime.parse(popup!.end!))
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        width: screenWidth * 0.9,
                                        child: Text(
                                          popup?.description ?? '',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * 0.2,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        )),
                                        child: KakaoMap(
                                          onMapCreated: ((controller) async {
                                            mapController = controller;

                                            await getAddressData();
                                            markers.add(Marker(
                                              markerId: UniqueKey().toString(),
                                              latLng: center,
                                            ));

                                            Logger.debug(center.toString());
                                            Logger.debug(markers.toString());

                                            setState(() {});
                                          }),
                                          markers: markers.toList(),
                                          center: center,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                            ),
                                            Text('서울특별시 마포구 양화로 162')
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          writeReview();
                                        },
                                        child: SizedBox(
                                          width: screenWidth * 0.9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: List.generate(
                                                  5,
                                                  (starIndex) => Icon(
                                                    starIndex <
                                                            (rating) // null 대비
                                                        ? Icons.star
                                                        : Icons
                                                            .star_border_outlined,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          // 최근 리뷰 3개 만 보여줌
                                          for (int index = 0;
                                              index < (reviewList?.length ?? 0);
                                              index++)
                                            if (reviewList != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12),
                                                child: Container(
                                                  width: screenWidth * 0.9,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // const Icon(
                                                            //   Icons
                                                            //       .ac_unit_rounded,
                                                            //   size: 20,
                                                            // ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                reviewList![index]
                                                                        .user ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children:
                                                              List.generate(
                                                            5,
                                                            (starIndex) => Icon(
                                                              starIndex <
                                                                      (reviewList![index]
                                                                              .rating ??
                                                                          0) // null 대비
                                                                  ? Icons.star
                                                                  : Icons
                                                                      .star_border_outlined,
                                                              size: 20,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(reviewList![index]
                                                                .content ??
                                                            ''),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, bottom: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GoodsList(
                                                            popup: popup!,
                                                          )),
                                                );
                                              },
                                              child: SizedBox(
                                                width: screenWidth * 0.9,
                                                child: const Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '굿즈',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.9,
                                                height: screenWidth * 0.8,
                                                // ListView
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0,
                                                      right:
                                                          screenWidth * 0.05),
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: SizedBox(
                                                      width: screenWidth * 0.5,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                // Image.network(
                                                                //   '${popup.image![0]}',
                                                                //   // width: screenHeight * 0.07 - 5,
                                                                //   width: screenWidth * 0.5,
                                                                //   fit: BoxFit.cover,
                                                                // ),
                                                                Image.asset(
                                                              'assets/images/Untitled.png',
                                                              width:
                                                                  screenWidth *
                                                                      0.5,
                                                            ),
                                                            //   fit: BoxFit.cover,)
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 8.0),
                                                            child: Text(
                                                              '굿즈 이름',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                          ),
                                                          const Text(
                                                            '수량',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -AppBar().preferredSize.height + 5,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.transparent,
                                child: AppBar(
                                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  leading: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: screenWidth,
                    height: screenHeight * 0.1,
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(
                        width: 2,
                        color: Color(0xFFADD8E6),
                      ),
                    )),
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05,
                            bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible: widget.mode == "view",
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      popupLike();
                                    },
                                    child: Icon(
                                      like
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: like ? Colors.red : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    '26',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: widget.mode == "view",
                              child: const Spacer(),
                            ),
                            Visibility(
                              visible: widget.mode == "view",
                              child: Container(
                                width: screenWidth * 0.3,
                                height: screenHeight * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFFADD8E6),
                                  ),
                                  color: const Color(0xFFADD8E6),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReserveDate(
                                          popup: popup!.id!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Center(
                                    child: Text(
                                      '예약하기',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.mode == "pending",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    width: screenWidth * 0.45,
                                    height: screenHeight * 0.06,
                                    child: OutlinedButton(
                                      onPressed: () => {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('팝업 승인'),
                                              content: const Text('승인 하시겠습니까?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('취소'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    popupStoreAllow();
                                                  },
                                                  child: const Text('승인하기'),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      },
                                      child: const Text("승인하기"),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    width: screenWidth * 0.45,
                                    height: screenHeight * 0.06,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        disabledForegroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Constants.DEFAULT_COLOR,
                                          width: 1.0,
                                        ),
                                      ),
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MultiProvider(
                                                        providers: [
                                                          ChangeNotifierProvider(
                                                              create: (_) =>
                                                                  StoreModel())
                                                        ],
                                                        child:
                                                            PendingRejectPage(
                                                          id: popup!.id
                                                              .toString(),
                                                        ))))
                                      },
                                      child: const Text(
                                        "거절하기",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: widget.mode == "modify",
                              child: Container(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.06,
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: OutlinedButton(
                                    onPressed: () => {
                                          if (mounted)
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MultiProvider(
                                                              providers: [
                                                                ChangeNotifierProvider(
                                                                    create: (_) =>
                                                                        StoreModel())
                                                              ],
                                                              child:
                                                                  StoreCreatePage(
                                                                mode: "modify",
                                                                popup: popup,
                                                              ))))
                                            }
                                        },
                                    child: const Text("수정하기")),
                              ),
                            )
                          ],
                        ))),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: popup!.image!.map(
        (img) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  img,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              );
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }
}
