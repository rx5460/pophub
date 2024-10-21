import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                ('funding_list').tr(),
                style: const TextStyle(
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
                                            const Text('quantity_').tr(args: [
                                              (widget.support.amount! ~/
                                                      int.parse(item!.amount
                                                          .toString()))
                                                  .toString()
                                            ]),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text('won').tr(args: [
                                              countFomat.format(item!.amount!)
                                            ])
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
                                    Text(
                                      ('product_amount').tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      'won',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ).tr(args: [
                                      countFomat.format(widget.support.amount)
                                    ]),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ('labelText_5').tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      'count_1',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ).tr(args: [
                                      (widget.support.amount! ~/
                                              int.parse(
                                                  item!.amount.toString()))
                                          .toString()
                                    ]),
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
                                Text(('total_payment_amount').tr(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    )),
                                const Text(
                                  'won',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Constants.DEFAULT_COLOR,
                                  ),
                                ).tr(args: [
                                  countFomat.format(widget.support.amount)
                                ]),
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
                            child: Center(
                              child: Text(
                                ('funding_cancellation').tr(),
                                style: const TextStyle(
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
                                    Image.network(
                                      item!.images![0],
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
                                        Text(
                                          widget.support.itemName!,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   ('room_2101_building_3_4455_gocheokdong_gurogu_seoul')
                                //       .tr(),
                                //   style: const TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.grey,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                                Text(
                                  widget.support.userName!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Row(
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ('product_amount').tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      countFomat.format(widget.support.amount!),
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
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       ('point_discount').tr(),
                                //       style: const TextStyle(
                                //         fontSize: 14,
                                //         color: Colors.grey,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //     const Text(
                                //       '-20p',
                                //       style: TextStyle(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // ),
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
                                Text(('total_payment_amount').tr(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    )),
                                const Text(
                                  'won',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Constants.DEFAULT_COLOR,
                                  ),
                                ).tr(args: [
                                  formatCurrency(widget.support.amount!)
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          )
        : const Scaffold();
  }
}
