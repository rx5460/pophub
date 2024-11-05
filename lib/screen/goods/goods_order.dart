import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/address_model.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/setting/address_write.dart';
import 'package:pophub/screen/user/purchase.dart';
import 'package:pophub/utils/api/address_api.dart';
import 'package:pophub/utils/api/payment_api.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';

class GoodsOrder extends StatefulWidget {
  final int count;
  final GoodsModel goods;
  final PopupModel popup;
  const GoodsOrder({
    super.key,
    required this.count,
    required this.goods,
    required this.popup,
  });

  @override
  State<GoodsOrder> createState() => _GoodsOrderState();
}

class _GoodsOrderState extends State<GoodsOrder> {
  String kakopayLink = "";
  Map<String, dynamic>? profile;
  int usePoint = 0;
  int? addressId;
  String? totalAddress;

  Future<void> testApi() async {
    final data = await PaymentApi.postPay(
        User().userName,
        widget.goods.productName,
        widget.count,
        widget.goods.price,
        widget.goods.price ~/ 10,
        0,
        widget.goods.store,
        widget.goods.product);

    setState(() {
      print("kakopayLink $kakopayLink");
      kakopayLink = data['data'];
    });
  }

  Future<void> profileApi() async {
    try {
      Map<String, dynamic> data = await UserApi.getProfile(User().userId);

      if (!data.toString().contains("fail")) {
        setState(() {
          profile = data;
          print(profile);
        });

        User().userName = data['userName'];
        User().phoneNumber = data['phoneNumber'];
        User().age = data['age'];
        User().gender = data['gender'];
        User().file = data['userImage'] ?? '';
        User().role = data['userRole'] ?? '';
      }
    } catch (e) {
      Logger.debug('$e');
    }
  }

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
    await profileApi();
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
                              widget.popup.name!,
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
                          widget.goods.image != null &&
                                  widget.goods.image!.isNotEmpty
                              ? Image.network(
                                  widget.goods.image![0],
                                  width: screenWidth * 0.2,
                                  height: screenWidth * 0.2,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
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
                                widget.count.toString(),
                                (widget.goods.price * widget.count).toString()
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(('point').tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ('point').tr(),
                            style: const TextStyle(
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
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      ('use_all').tr(),
                                      style: const TextStyle(
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
                        formatCurrency(
                            widget.goods.price * widget.count - usePoint)
                      ]),
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
                            formatCurrency(widget.goods.price * widget.count)
                          ]),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ('point_discount').tr(),
                            style: const TextStyle(
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
                                    overflow: TextOverflow.ellipsis,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(('payment_method').tr(),
                          style: const TextStyle(
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
                    await testApi();
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PurchasePage(
                            api: kakopayLink,
                            goods: widget.goods,
                            addressId: addressId,
                            count: widget.count,
                          ),
                        ),
                      );
                    }
                    Logger.debug("kakopayLink $kakopayLink");
                  },
                  child: Center(
                    child: Text(
                      ('make_payment').tr(),
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
        ),
      ),
    );
  }
}
