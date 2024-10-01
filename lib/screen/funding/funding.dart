import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/funding_model.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/GoodsNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/funding/funding_add.dart';
import 'package:pophub/screen/funding/funding_detail.dart';
import 'package:pophub/screen/funding/funding_list.dart';
import 'package:pophub/screen/goods/goods_add.dart';
import 'package:pophub/screen/goods/goods_view.dart';
import 'package:pophub/utils/api/funding_api.dart';
import 'package:pophub/utils/api/goods_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class Funding extends StatefulWidget {
  final String mode;
  const Funding({super.key, this.mode = "view"});

  @override
  State<Funding> createState() => _FundingState();
}

class _FundingState extends State<Funding> {
  List<FundingModel>? fundingList;

  Future<void> fetchFundingData() async {
    try {
      List<FundingModel>? dataList = await FundingApi.getFundingList();

      if (dataList.isNotEmpty) {
        setState(() {
          fundingList = dataList;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching funding data: $error');
    }
  }

  Future<void> fetchMyFundingData() async {
    try {
      List<FundingModel>? dataList = await FundingApi.getFundingList();

      if (dataList.isNotEmpty) {
        setState(() {
          fundingList = dataList;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching funding data: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.mode == 'select') {
      fetchMyFundingData();
    } else {
      fetchFundingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: const CustomTitleBar(
        titleName: "펀딩 리스트",
      ),
      floatingActionButton: widget.mode == 'select'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FundingAddPage()),
                );
              },
              heroTag: null,
              backgroundColor: Constants.DEFAULT_COLOR,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
            )
          : null,
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int index = 0;
                      index < (fundingList?.length ?? 0);
                      index++)
                    if (fundingList != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.mode == 'select') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FundingList(
                                          funding:
                                              fundingList![index].fundingId!,
                                        )),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FundingDetail(
                                        funding: fundingList![index])),
                              );
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.35,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: fundingList![index].images !=
                                                    null &&
                                                fundingList![index]
                                                    .images!
                                                    .isNotEmpty
                                            ? Image.network(
                                                '${fundingList![index].images![0]}',
                                                // width: screenHeight * 0.07 - 5,
                                                width: screenWidth * 0.35,
                                                height: screenWidth * 0.35,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/logo.png',
                                                width: screenWidth * 0.35,
                                                height: screenWidth * 0.35,
                                                fit: BoxFit.cover,
                                              )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        fundingList![index].title ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            fundingList![index].donation == 0 ||
                                                    fundingList![index]
                                                            .donation ==
                                                        null ||
                                                    fundingList![index]
                                                            .amount ==
                                                        0 ||
                                                    fundingList![index]
                                                            .amount ==
                                                        null
                                                ? '0%' // 목표 금액 또는 후원 금액이 없을 때 '0%'로 표시
                                                : '${((fundingList![index].donation! / fundingList![index].amount!.toDouble()) * 100).toInt()}% 달성', // 도달률 계산 후 퍼센트로 표시
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Constants.DEFAULT_COLOR,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            fundingList![index].closeDate !=
                                                    null
                                                ? '${DateTime.parse(fundingList![index].closeDate!).difference(DateTime.now()).inDays}일 남음' // 종료일까지 남은 일수 계산
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
                                    Text(
                                      fundingList![index].content ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
