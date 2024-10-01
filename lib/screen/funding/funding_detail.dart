import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/funding_model.dart';
import 'package:pophub/model/fundingitem_model.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/user/login.dart';
import 'package:pophub/utils/api/funding_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';

class FundingDetail extends StatefulWidget {
  final FundingModel funding;

  const FundingDetail({
    Key? key,
    required this.funding,
  }) : super(key: key);

  @override
  State<FundingDetail> createState() => _FundingDetailState();
}

class _FundingDetailState extends State<FundingDetail> {
  var countFormat = NumberFormat('###,###,###,###');
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isLoading = true;
  bool isBuying = false;
  int selected = 0;

  int count = 1;

  List<FundingItemModel>? fundingItem;

  Future<void> fetchItemData() async {
    try {
      print('펀딩 아이디 : ${widget.funding}');
      List<FundingItemModel> dataList =
          await FundingApi.getFundingItemList(widget.funding.fundingId!);
      print('펀딩 아이디 : ${widget.funding}');
      if (dataList.isNotEmpty) {
        setState(() {
          fundingItem = dataList;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching item data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItemData();
    // fetchGoodsData();
    // getGoodsData();
  }

  // Future<void> fetchGoodsData() async {
  //   try {
  //     List<GoodsModel>? dataList =
  //         await GoodsApi.getPopupGoodsList(widget.popupId);

  //     if (dataList.isNotEmpty) {
  //       setState(() {
  //         goodsList = dataList;
  //       });
  //     }
  //   } catch (error) {
  //     Logger.debug('Error fetching goods data: $error');
  //   }
  // }

  // Future<void> getGoodsData() async {
  //   try {
  //     GoodsModel? data = await GoodsApi.getPopupGoodsDetail(widget.goodsId);

  //     if (User().userName != "") {
  //       List<dynamic> popupData = await StoreApi.getMyPopup(User().userName);

  //       if (!popupData.toString().contains("없습니다")) {
  //         setState(() {
  //           goods = data;
  //           isLoading = true;
  //           popup = PopupModel.fromJson(popupData[0]);
  //         });
  //         if (goods != null) {
  //           if (popup.id == goods!.store) {
  //             setState(() {
  //               addGoodsVisible = true;
  //             });
  //           }
  //         }
  //       } else {
  //         setState(() {
  //           goods = data;
  //           isLoading = true;
  //           addGoodsVisible = false;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         goods = data;
  //         isLoading = true;
  //         addGoodsVisible = false;
  //       });
  //     }
  //   } catch (error) {
  //     // 오류 처리
  //     Logger.debug('Error fetching goods data: $error');
  //   }
  // }

  // Future<void> goodsDelete(String productId) async {
  //   final data = await GoodsApi.deleteGoods(productId);

  //   if (!data.toString().contains("fail") && mounted) {
  //     showAlert(context, "성공", "굿즈가 삭제되었습니다.", () {
  //       Navigator.of(context).pop();
  //       Navigator.of(context).pop();

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => GoodsList(
  //             popup: popup,
  //           ),
  //         ),
  //       ).then((value) {
  //         if (mounted) {
  //           setState(() {});
  //         }
  //       });
  //     });
  //   } else {
  //     if (mounted) {
  //       showAlert(context, "실패", "굿즈 삭제 실패했습니다.", () {
  //         Navigator.of(context).pop();
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      body: !isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height:
                          isBuying ? screenHeight * 0.8 : screenHeight * 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: screenWidth,
                              height: AppBar().preferredSize.height,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
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
                                            height: screenWidth * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${(_current + 1).toString()}/${widget.funding.images!.length ?? 0}',
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
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  widget.funding.title ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  widget.funding.closeDate !=
                                                          null
                                                      ? '${DateTime.parse(widget.funding.closeDate!).difference(DateTime.now()).inDays}일 남음' // 종료일까지 남은 일수 계산
                                                      : '종료일 없음', // 종료일이 없을 경우
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Constants.DARK_GREY,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                '목표금액 :  ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Constants.DARK_GREY),
                                              ),
                                              Text(
                                                '${countFormat.format(widget.funding.amount)}원',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Constants
                                                        .DEFAULT_COLOR),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.funding.donation == 0 ||
                                                        widget.funding
                                                                .donation ==
                                                            null ||
                                                        widget.funding.amount ==
                                                            0 ||
                                                        widget.funding.amount ==
                                                            null
                                                    ? '0% 달성' // 목표 금액 또는 후원 금액이 없을 때 '0%'로 표시
                                                    : '${((widget.funding.donation! / widget.funding.amount!.toDouble()) * 100).toInt()}% 달성',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Constants.DEFAULT_COLOR,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: screenWidth * 0.2,
                                                height: 22,
                                                decoration: const BoxDecoration(
                                                    color:
                                                        Constants.DEFAULT_COLOR,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: const Center(
                                                  child: Text(
                                                    '999명 참여',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            width: screenWidth * 0.9,
                                            child: Text(
                                              widget.funding.content!,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 10),
                                                child: SizedBox(
                                                  width: screenWidth * 0.9,
                                                  child: const Text(
                                                    '제품 선택하기',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          for (int index = 0;
                                              index <
                                                  (fundingItem?.length ?? 0);
                                              index++)
                                            if (fundingItem != [])
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selected = index;
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        selected == index
                                                            ? const Icon(
                                                                Icons
                                                                    .check_box_outlined,
                                                                color: Colors
                                                                    .black)
                                                            : const Icon(
                                                                Icons
                                                                    .check_box_outline_blank_rounded,
                                                                color: Constants
                                                                    .DARK_GREY,
                                                              ),
                                                        Text(
                                                          "${countFormat.format(fundingItem![index].amount)}원",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: fundingItem![
                                                                        index]
                                                                    .images !=
                                                                []
                                                            ? Image.network(
                                                                fundingItem![
                                                                        index]
                                                                    .images![0],
                                                                width:
                                                                    screenWidth *
                                                                        0.32,
                                                                height:
                                                                    screenWidth *
                                                                        0.32,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/goods.png',
                                                                // width: screenHeight * 0.07 - 5,
                                                                width:
                                                                    screenWidth *
                                                                        0.32,
                                                                height:
                                                                    screenWidth *
                                                                        0.32,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            fundingItem![index]
                                                                .itemName
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "잔여수량 ${fundingItem![index].amount.toString()}개",
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.4,
                                                    child: Text(
                                                      fundingItem![index]
                                                          .content
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
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
                                  top: -AppBar().preferredSize.height + 20,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: AppBar(
                                      systemOverlayStyle:
                                          SystemUiOverlayStyle.dark,
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
                      // duration: const Duration(milliseconds: 300),
                      width: screenWidth,
                      height:
                          isBuying ? screenHeight * 0.2 : screenHeight * 0.1,
                      decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Constants.DEFAULT_COLOR,
                            ),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05,
                            bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            isBuying
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.favorite_border,
                                          size: 30,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                isBuying
                                    ? SizedBox(
                                        width: screenWidth * 0.8,
                                        height: screenHeight * 0.1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    fundingItem![selected]
                                                        .itemName!,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  Text(
                                                    '${formatNumber(fundingItem![selected].amount! * count)}원',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (count != 0) {
                                                        count -= 1;
                                                      }
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Text(
                                                    count.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      count += 1;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                Container(
                                  // duration: const Duration(milliseconds: 300),
                                  width: isBuying
                                      ? screenWidth * 0.9
                                      : screenWidth * 0.3,
                                  height: isBuying
                                      ? screenHeight * 0.06
                                      : screenHeight * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      width: 2,
                                      color: Constants.DEFAULT_COLOR,
                                    ),
                                    color: Constants.DEFAULT_COLOR,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (User().userName != "") {
                                        setState(() {
                                          if (!isBuying) {
                                            isBuying = !isBuying;
                                          } else {
                                            // 결제페이지
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           GoodsOrder(
                                            //             popupName:
                                            //                 widget.popupName,
                                            //             goods: goods!,
                                            //             count: count,
                                            //           )),
                                            // );
                                          }
                                        });
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                        );
                                      }
                                    },
                                    child: const Center(
                                      child: Text(
                                        '펀딩하기',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 16,
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
                  ],
                ),
                if (isBuying)
                  Positioned(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBuying = false;
                            });
                          },
                          child: Container(
                            // duration: const Duration(milliseconds: 400),
                            height: screenHeight * 0.8,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: widget.funding.images!.map(
        (img) {
          return Builder(
            builder: (context) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Image.network(
                        img,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 0, // 그림자의 위치 조정
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30, // 그림자의 높이 조정
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 50,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 300,
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
