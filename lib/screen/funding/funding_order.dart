import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/address_model.dart';
import 'package:pophub/model/fundingitem_model.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/setting/address_write.dart';
import 'package:pophub/screen/user/purchase.dart';
import 'package:pophub/utils/api/address_api.dart';
import 'package:pophub/utils/api/payment_api.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';

class FundingOrder extends StatefulWidget {
  final int count;
  final FundingItemModel item;

  const FundingOrder({
    super.key,
    required this.count,
    required this.item,
  });

  @override
  State<FundingOrder> createState() => _FundingOrderState();
}

class _FundingOrderState extends State<FundingOrder> {
  String kakopayLink = "";
  Map<String, dynamic>? profile;
  int usePoint = 0;
  int? addressId;
  String? totalAddress;

  Future<void> getAddress() async {
    AddressModel data = await AddressApi.getAddress(User().userName);

    if (data.addressId != null) {
      setState(() {
        totalAddress = data.address;
        addressId = data.addressId;
      });
    }
  }

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
    getAddress();
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
        title: const Text(
          '주문/결제',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      const Text('상품 정보',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.item.itemName!,
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
                                widget.item.itemName!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${formatCurrency(widget.item.amount!)}원 x ${widget.count}개 = ${formatCurrency(widget.item.amount! * widget.count)}원',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('포인트',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '포인트',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${formatCurrency(usePoint)}p',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    usePoint = profile?['pointScore'];
                                  });
                                },
                                child: Container(
                                  width: screenWidth * 0.2,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Constants.DEFAULT_COLOR,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: Constants.DEFAULT_COLOR,
                                  ),
                                  child: const Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(
                                      '모두사용',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        '잔여 포인트 : ${formatCurrency(profile?['pointScore'] ?? 0)}p',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
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
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('총 결제 금액',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      Text(
                        '${formatCurrency(widget.item.amount! * widget.count - usePoint)}원',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Constants.DEFAULT_COLOR,
                        ),
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
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            '${formatCurrency(widget.item.amount! * widget.count)}원',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '포인트 할인',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '-${formatCurrency(usePoint)}p',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('배송',
                          style: TextStyle(
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
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddressWritePage()))
                                  .then((newAddress) {
                                setState(() {
                                  totalAddress = newAddress;
                                });
                              })
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  totalAddress != null ? totalAddress! : "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('결제 방법',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Constants.DEFAULT_COLOR),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/kakaopay.png',
                          width: screenWidth * 0.1,
                          // height: 24,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 2,
                    color: Constants.DEFAULT_COLOR,
                  ),
                  color: Constants.DEFAULT_COLOR,
                ),
                child: InkWell(
                  onTap: () async {
                    // if (context.mounted) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => PurchasePage(
                    //         api: kakopayLink,
                    //         goods: widget.goods,
                    //         addressId: addressId,
                    //         count: widget.count,
                    //       ),
                    //     ),
                    //   );
                    // }
                    Logger.debug("kakopayLink $kakopayLink");
                  },
                  child: const Center(
                    child: Text(
                      '결제하기',
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
      ),
    );
  }
}
