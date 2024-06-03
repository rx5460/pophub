import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/review_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/goods/goods_list.dart';
import 'package:pophub/screen/reservation/reserve_date.dart';
import 'package:pophub/screen/store/store_list_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:intl/intl.dart';

class PopupDetail extends StatefulWidget {
  final String storeId;
  final String mode;
  const PopupDetail({Key? key, required this.storeId, this.mode = "view"})
      : super(key: key);

  @override
  State<PopupDetail> createState() => _PopupDetailState();
}

class _PopupDetailState extends State<PopupDetail> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  PopupModel? popup;
  List<ReviewModel>? reviewList;
  bool isLoading = true;
  double rating = 0;
  bool like = false;
  bool allowSuccess = false;

//수정 필요
  Future<void> getPopupData() async {
    try {
      PopupModel? data = await Api.getPopup(widget.storeId, User().userName);
      print('좋아요 : ${data.bookmark}');
      setState(() {
        popup = data;
        like = data.bookmark!;
        isLoading = false;
      });
    } catch (error) {
      // 오류 처리
      print('Error fetching popup data: $error');
    }
  }

  Future<void> popupStoreAllow(BuildContext context) async {
    try {
      final data = await Api.popupAllow(widget.storeId);

      if (!data.toString().contains("fail")) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('승인 완료되었습니다.'),
          ),
        );
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StoreListPage()));

        setState(() {
          allowSuccess = true;
          isLoading = false;
        });
      } else {}
    } catch (error) {
      // 오류 처리
      print('Error fetching popup data: $error');
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
      print('Error fetching review data: $error');
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
    super.initState();

    getPopupData();
    fetchReviewData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

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
                                        // child: KakaoMap(
                                        //   onMapCreated: ((controller) async {
                                        //     mapController = controller;

                                        //     markers.add(Marker(
                                        //       markerId: UniqueKey().toString(),
                                        //       latLng: await mapController.getCenter(),
                                        //     ));

                                        //     setState(() {});
                                        //   }),
                                        //   markers: markers.toList(),
                                        //   center: LatLng(37.3608681, 126.9306506),
                                        // ),
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
                        mainAxisAlignment: widget.mode == "view"
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
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
                                  color: const Color(0xFFADD8E6)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReserveDate(
                                              popup: popup!.id!,
                                            )),
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('팝업 승인'),
                                                    content: const Text(
                                                        '승인 하시겠습니까?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('취소'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          // 여기서 실제 회원 탈퇴 로직을 구현
                                                          popupStoreAllow(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('승인하기'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            },
                                        child: const Text("승인하기")),
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
                                        onPressed: () => {},
                                        child: const Text(
                                          "거절하기",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  )
                                ],
                              )),
                        ],
                      ),
                    )),
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
