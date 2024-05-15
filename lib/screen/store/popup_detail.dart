import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/screen/reservation/reserve_add.dart';
import 'package:pophub/utils/api.dart';
import 'package:intl/intl.dart';

class PopupDetail extends StatefulWidget {
  final int storeId;
  const PopupDetail({Key? key, required this.storeId}) : super(key: key);

  @override
  State<PopupDetail> createState() => _PopupDetailState();
}

class _PopupDetailState extends State<PopupDetail> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  PopupModel? popup;
  bool isLoading = true;

  Future<void> getPopupData() async {
    try {
      // Api.getPopup()을 사용하여 팝업 데이터를 가져옵니다.
      PopupModel? data = await Api.getPopup(widget.storeId);
      // 데이터가 있으면 상태를 업데이트하여 화면을 다시 그립니다.
      setState(() {
        popup = data; // 단일 데이터만 받아온 것으로 가정합니다.
        isLoading = false;
      });
    } catch (error) {
      // 오류 처리
      print('Error fetching popup data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // 홈 화면이 로드될 때 팝업 데이터를 가져옵니다.
    getPopupData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
        body: !isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: screenHeight * 0.9,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth,
                            height: AppBar().preferredSize.height,
                            decoration:
                                const BoxDecoration(color: Colors.white),
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
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            color:
                                                Colors.white.withOpacity(0.2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${(_current + 1).toString()}/${popup!.image!.length}',
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.05,
                                        right: screenWidth * 0.05),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Text(
                                            popup?.name ?? '',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              (popup?.start != null &&
                                                      popup!.start!.isNotEmpty)
                                                  ? DateFormat("yyyy.MM.dd")
                                                      .format(DateTime.parse(
                                                          popup!.start!))
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Text(
                                              ' ~ ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              (popup?.end != null &&
                                                      popup!.end!.isNotEmpty)
                                                  ? DateFormat("yyyy.MM.dd")
                                                      .format(DateTime.parse(
                                                          popup!.end!))
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              (popup?.start != null &&
                                                      popup!.start!.isNotEmpty)
                                                  ? DateFormat("hh:mm").format(
                                                      DateTime.parse(
                                                          popup!.start!))
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Text(
                                              ' ~ ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              (popup?.end != null &&
                                                      popup!.end!.isNotEmpty)
                                                  ? DateFormat("hh:mm").format(
                                                      DateTime.parse(
                                                          popup!.end!))
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 12, bottom: 12),
                                          width: screenWidth * 0.9,
                                          // height: screenHeight * 0.12,
                                          child: Text(
                                            popup?.description ?? '',
                                            // overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
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
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
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
                                    systemOverlayStyle:
                                        SystemUiOverlayStyle.dark,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    leading: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 하단 좋아요 및 예약 버튼
                  Container(
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFFADD8E6),
                                  ),
                                  color: const Color(0xFFADD8E6)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ReserveAdd()),
                                  );
                                },
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
                      ))
                ],
              )
            : const SizedBox());
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: popup!.image!.map(
        (img) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  img,
                  width: MediaQuery.of(context).size.width,
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
