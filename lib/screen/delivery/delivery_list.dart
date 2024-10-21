import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/delivery_model.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/delivery/delivery_detail.dart';
import 'package:pophub/utils/api/delivery_api.dart';
import 'package:pophub/utils/api/goods_api.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/log.dart';

class DeliveryListPage extends StatefulWidget {
  final String? storeId;
  const DeliveryListPage({
    Key? key,
    required this.storeId,
  }) : super(key: key);

  @override
  State<DeliveryListPage> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryListPage> {
  Map<String, List<DeliveryModel>> groupedDeliveries = {};
  var countFormat = NumberFormat('###,###,###,###');

  Future<void> fetchDeliveryData() async {
    try {
      List<DeliveryModel> dataList;
      if (User().role == 'President') {
        dataList = await DeliveryApi.getDeliveryListByPresident(
            User().userName, widget.storeId);
      } else {
        dataList = await DeliveryApi.getDeliveryListByUser(User().userName);
      }

      for (DeliveryModel model in dataList) {
        if (model.productId != "") {
          GoodsModel? data =
              await GoodsApi.getPopupGoodsDetail(model.productId);
          model.userName = "${model.userName}/${data.productName}";
        }
      }

      // Sort the list by date in descending order
      dataList.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      // Group deliveries by date
      groupedDeliveries = {};
      for (var delivery in dataList) {
        String dateKey = DateFormat('yyyy.MM.dd').format(delivery.orderDate);
        if (!groupedDeliveries.containsKey(dateKey)) {
          groupedDeliveries[dateKey] = [];
        }
        groupedDeliveries[dateKey]!.add(delivery);
      }

      setState(() {});
    } catch (error) {
      Logger.debug('Error fetching delivery data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDeliveryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          ('text_9').tr(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: groupedDeliveries.isEmpty
          ? Center(
              child: Text(
                ('there_is_no_payment_history').tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '총 ${groupedDeliveries.values.expand((e) => e).length}건',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedDeliveries.length,
                    itemBuilder: (context, index) {
                      String date = groupedDeliveries.keys.elementAt(index);
                      List<DeliveryModel> deliveries = groupedDeliveries[date]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Text(
                              DateFormat('MM.dd')
                                  .format(deliveries[0].orderDate),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...deliveries.map((delivery) => GestureDetector(
                                onTap: () async {
                                  GoodsModel? data =
                                      await GoodsApi.getPopupGoodsDetail(
                                          delivery.productId);

                                  PopupModel? popup = await StoreApi.getPopup(
                                      data.store.toString(), false, "");

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeliveryDetail(
                                        delivery: delivery,
                                        goods: data,
                                        popupName: popup.name.toString(),
                                      ),
                                    ),
                                  );
                                  // if (delivery.trackingNumber == null ||
                                  //     delivery.trackingNumber!.isEmpty) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => TrackingWritePage(
                                  //           deliveryId: delivery.deliveryId),
                                  //     ),
                                  //   );
                                  // } else {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => TrackingListPage(
                                  //         courier: delivery.courier.toString(),
                                  //         trackingNum: delivery.trackingNumber
                                  //             .toString(),
                                  //       ),
                                  //     ),
                                  //   );
                                  // }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              delivery.userName.split("/")[1],
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '• ${delivery.status}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${delivery.paymentAmount > 0 ? '+' : ''}${countFormat.format(delivery.paymentAmount)}원',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: delivery.paymentAmount > 0
                                                  ? Colors.black
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          if (index < groupedDeliveries.length - 1)
                            const Divider(color: Colors.grey, height: 1),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
