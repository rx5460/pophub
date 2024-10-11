import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/funding_support_model.dart';
import 'package:pophub/model/fundingitem_model.dart';
import 'package:pophub/utils/api/funding_api.dart';
import 'package:pophub/utils/log.dart';

class FundingListDetail extends StatefulWidget {
  final String mode;
  final FundingSupportModel support;
  const FundingListDetail(
      {super.key, this.mode = 'General', required this.support});

  @override
  State<FundingListDetail> createState() => _FundingListDetailState();
}

class _FundingListDetailState extends State<FundingListDetail> {
  var countFomat = NumberFormat('###,###,###,###');
  FundingItemModel? item;
  bool isLoading = false;

  Future<void> getItemData() async {
    try {
      FundingItemModel? data =
          await FundingApi.getFundingItemDetail(widget.support.itemId!);
      print(data);
      setState(() {
        item = data;
        isLoading = true;
      });
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching item data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getItemData();
    print('ad');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                '펀딩 리스트',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: widget.mode == 'General'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.05,
                              right: screenWidth * 0.05,
                              top: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.support.userName!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat("yyyy.MM.dd hh:mm").format(
                                            DateTime.parse(
                                                widget.support.createdAt!)),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item!.images![0],
                                        width: screenWidth * 0.2,
                                        height: screenWidth * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item!.itemName!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.7 - 8,
                                          child: Text(
                                            item!.content!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines:
                                                3, // 최대 줄 수를 설정 (필요에 맞게 변경 가능)
                                            softWrap: true, // 자동 줄바꿈을 활성화
                                            overflow: TextOverflow
                                                .visible, // 생략 기호 제거
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '수량: ${(widget.support.amount! ~/ int.parse(item!.amount.toString())).toString()}',
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                                '${countFomat.format(item!.amount!)}원')
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              width: screenWidth,
                              height: 1,
                              color: Constants.DEFAULT_COLOR,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '상품 금액',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${countFomat.format(widget.support.amount)}원',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '수량',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      ' ${(widget.support.amount! ~/ int.parse(item!.amount.toString())).toString()}개',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              width: screenWidth,
                              height: 1,
                              color: Constants.DEFAULT_COLOR,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('총 결제 금액',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    )),
                                Text(
                                  '${countFomat.format(widget.support.amount)}원',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Constants.DEFAULT_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: 2,
                                color: Constants.DEFAULT_COLOR,
                              ),
                              color: Constants.DEFAULT_COLOR),
                          child: InkWell(
                            onTap: () async {},
                            child: const Center(
                              child: Text(
                                '펀딩 취소',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.05,
                              right: screenWidth * 0.05,
                              top: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/goods.png',
                                      width: screenWidth * 0.2,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "파일 폴더 및 액자 세트",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.7 - 8,
                                          child: const Text(
                                            '쥐순이 랜텀 파일 폴더 및 액자가 들어있는 세트 입니다.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines:
                                                3, // 최대 줄 수를 설정 (필요에 맞게 변경 가능)
                                            softWrap: true, // 자동 줄바꿈을 활성화
                                            overflow: TextOverflow
                                                .visible, // 생략 기호 제거
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              width: screenWidth,
                              height: 1,
                              color: Constants.DEFAULT_COLOR,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '서울특별시 구로구 고척동 445-5 3호관 210-1호',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '황지민',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "010-1234-5678",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              width: screenWidth,
                              height: 1,
                              color: Constants.DEFAULT_COLOR,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '상품 금액',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'ds원',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '포인트 할인',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '-20p',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              width: screenWidth,
                              height: 1,
                              color: Constants.DEFAULT_COLOR,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('총 결제 금액',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    )),
                                Text(
                                  'dsa원',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Constants.DEFAULT_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: 2,
                                color: Constants.DEFAULT_COLOR,
                              ),
                              color: Constants.DEFAULT_COLOR),
                          child: InkWell(
                            onTap: () async {},
                            child: const Center(
                              child: Text(
                                '운송장 등록',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        : const Scaffold();
  }
}
