import 'package:flutter/material.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/notifier/GoodsNotifier.dart';
import 'package:pophub/screen/goods/goods_add_page.dart';
import 'package:pophub/screen/goods/goods_detail.dart';
import 'package:provider/provider.dart';

class GoodsList extends StatefulWidget {
  final PopupModel popup;
  const GoodsList({super.key, required this.popup});

  @override
  State<GoodsList> createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
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
          '굿즈',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.02,
        ),
        child: Column(
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
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GoodsDetail(),
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
                                child: Image.asset(
                                  'assets/images/goods.png',
                                  width: screenWidth * 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '굿즈 이름',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8),
                                child: Text(
                                  '가격',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                '수량',
                                style: TextStyle(
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
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                if (mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(providers: [
                                ChangeNotifierProvider(
                                    create: (_) => GoodsNotifier())
                              ], child: const GoodsCreatePage(mode: "add"))));
                }
              },
              child: const Text('굿즈 추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}
