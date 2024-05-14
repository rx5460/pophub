import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class PopupDetail extends StatefulWidget {
  const PopupDetail({Key? key}) : super(key: key);

  @override
  State<PopupDetail> createState() => _PopupDetailState();
}

class _PopupDetailState extends State<PopupDetail> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<String> imageList = [
    'assets/images/Untitled.png',
    'assets/images/Untitled.png',
    'assets/images/Untitled.png',
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                height: AppBar().preferredSize.height,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      sliderWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -screenWidth * 0.1),
                            child: Container(
                              width: screenWidth * 0.17,
                              height: screenWidth * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Text(
                                  '${(_current + 1).toString()}/${imageList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                '주술회전 팝업스토어',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                Text(
                                  '2024.03.08',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' ~ ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '2024.04.04',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  '10:30',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' ~ ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '22:00',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                ),
                              ],
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.12,
                              child: const Text(
                                '이래저래설명임',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.black,
                              )),
                              child: const Text('지도 영역'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                  ),
                                  Text('서울특별시 마포구 양화로 162')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 앱바
                  Positioned(
                    top: -AppBar().preferredSize.height + 5,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent,
                      child: AppBar(
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
                width: screenWidth,
                height: screenHeight * 0.1,
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(
                    width: 2,
                    color: Color(0xFFADD8E6),
                  ),
                )),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.favorite_border,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            '26',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              width: 2,
                              color: const Color(0xFFADD8E6),
                            ),
                            color: const Color(0xFFADD8E6)),
                        child: InkWell(
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              '예약하기',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: imageList.map(
        (img) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  img,
                  fit: BoxFit.fill,
                ),
              );
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }
}
