import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/GoodsNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/goods/goods_add.dart';
import 'package:pophub/screen/goods/goods_view.dart';
import 'package:pophub/utils/api/goods_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class GoodsList extends StatefulWidget {
  final PopupModel popup;
  const GoodsList({super.key, required this.popup});

  @override
  State<GoodsList> createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  List<GoodsModel>? goodsList;

  Future<void> fetchGoodsData() async {
    try {
      List<GoodsModel>? dataList =
          await GoodsApi.getPopupGoodsList(widget.popup.id!);

      if (dataList.isNotEmpty) {
        setState(() {
          goodsList = dataList;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching goods data: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGoodsData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: CustomTitleBar(
        titleName: ('titleName_7').tr(),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    widget.popup.name!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                for (int index = 0; index < (goodsList?.length ?? 0); index++)
                  if (goodsList != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoodsDetail(
                                goodsId: goodsList![index].product,
                                popup: widget.popup,
                              ),
                            ),
                          );
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
                                    child: Image.network(
                                      '${goodsList![index].image![0]}',
                                      // width: screenHeight * 0.07 - 5,
                                      width: screenWidth * 0.35,
                                      height: screenWidth * 0.35,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      goodsList![index].productName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8),
                                    child: const Text(
                                      'won',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ).tr(args: [
                                      formatNumber(goodsList![index].price)
                                          .toString()
                                    ]),
                                  ),
                                  const Text(
                                    'things',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ).tr(args: [
                                    goodsList![index].quantity.toString()
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: User().userName == widget.popup.username,
              child: OutlinedButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                          create: (_) => GoodsNotifier())
                                    ],
                                    child: GoodsCreatePage(
                                        mode: "add", popup: widget.popup))));
                  }
                },
                child: Text(('add_goods').tr()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
