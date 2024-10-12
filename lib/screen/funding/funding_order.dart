import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/address_model.dart';
import 'package:pophub/model/fundingitem_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/api/address_api.dart';
import 'package:pophub/utils/api/funding_api.dart';

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
  var countFomat = NumberFormat('###,###,###,###');
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

  Future<void> submit() async {
    final result = await FundingApi.postFundingSupport(
        widget.item.itemId!, (widget.count * widget.item.amount!).toString());

    if (!result.toString().contains("fail")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(('participated_in_funding').tr()),
        ),
      );
      Navigator.pop(context);
    } else {}
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          widget.item.images![0],
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                          fit: BoxFit.cover,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.7 - 8,
                              child: Text(
                                widget.item.content!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 3, // 최대 줄 수를 설정 (필요에 맞게 변경 가능)
                                softWrap: true, // 자동 줄바꿈을 활성화
                                overflow: TextOverflow.visible, // 생략 기호 제거
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
                        ).tr(args: [countFomat.format(widget.item.amount!)]),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'things',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ).tr(args: [widget.count.toString()]),
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
                      countFomat
                          .format(widget.item.amount! * widget.count)
                          .toString()
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(('notification').tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        )),
                    Text(
                        ('var_1_payment_will_be_made_after_funding_ends').tr()),
                    Text(('var_2_there_may_be_disadvantages_for_nonpayment')
                        .tr()),
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 2,
                    color: Constants.DEFAULT_COLOR,
                  ),
                  color: Constants.DEFAULT_COLOR),
              child: InkWell(
                onTap: () async {
                  submit();
                },
                child: Center(
                  child: Text(
                    ('participate_in_funding').tr(),
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
    );
  }
}
