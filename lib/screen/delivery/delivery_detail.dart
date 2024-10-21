import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/delivery_model.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/screen/delivery/tracking_list.dart';
import 'package:pophub/screen/setting/tracking_write.dart';

class DeliveryDetail extends StatefulWidget {
  final DeliveryModel delivery;
  final GoodsModel goods;
  final String popupName;

  const DeliveryDetail({
    super.key,
    required this.delivery,
    required this.goods,
    required this.popupName,
  });

  @override
  State<DeliveryDetail> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail> {
  String kakopayLink = "";
  Map<String, dynamic>? profile;
  int usePoint = 0;
  int? addressId;
  String? totalAddress;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          ('orderpayment').tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                      Text(('product_information').tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.popupName,
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
                          Image.asset(
                            'assets/images/goods.png',
                            width: screenWidth * 0.2,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.goods.productName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                '_won_x__pieces___won',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).tr(args: [
                                formatCurrency(widget.goods.price),
                                widget.delivery.quantity.toString(),
                                (widget.delivery.paymentAmount).toString()
                              ]),
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
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            formatCurrency(widget.delivery.paymentAmount)
                          ]),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(('delivery').tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                    Container(
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1,
                          color: Constants.BUTTON_GREY,
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: InkWell(
                            onTap: () => {
                              if (widget.delivery.trackingNumber == null ||
                                  widget.delivery.trackingNumber!.isEmpty)
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrackingWritePage(
                                          deliveryId:
                                              widget.delivery.deliveryId),
                                    ),
                                  )
                                }
                              else
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrackingListPage(
                                        courier:
                                            widget.delivery.courier.toString(),
                                        trackingNum: widget
                                            .delivery.trackingNumber
                                            .toString(),
                                      ),
                                    ),
                                  )
                                }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.delivery.trackingNumber == null ||
                                          widget
                                              .delivery.trackingNumber!.isEmpty
                                      ? "titleName_9"
                                      : "delivery_list",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ).tr(),
                              ],
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
            // SizedBox(
            //   height: screenHeight * 0.03,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: Container(
            //     width: screenWidth * 0.9,
            //     height: screenHeight * 0.07,
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.all(Radius.circular(10)),
            //       border: Border.all(
            //         width: 2,
            //         color: Constants.DEFAULT_COLOR,
            //       ),
            //       color: Constants.DEFAULT_COLOR,
            //     ),
            //     child: InkWell(
            //       onTap: () async {
            //         if (context.mounted) {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => PurchasePage(
            //           //       api: kakopayLink,
            //           //       goods: widget.goods,
            //           //       addressId: addressId,
            //           //       count: widget.count,
            //           //     ),
            //           //   ),
            //           // );
            //         }
            //         Logger.debug("kakopayLink $kakopayLink");
            //       },
            //       child: Center(
            //         child: Text(
            //           ('payment').tr() + ('cancellation').tr(),
            //           style: const TextStyle(
            //             fontWeight: FontWeight.w600,
            //             color: Colors.white,
            //             fontSize: 22,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
