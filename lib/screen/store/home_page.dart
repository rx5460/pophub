import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/screen/alarm/alarm_page.dart';
import 'package:pophub/screen/store/popup_detail.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  TextEditingController searchController = TextEditingController();
  String? searchInput;
  List<PopupModel>? poppularList;

  List imageList = [
    'assets/images/Untitled.png',
    'assets/images/Untitled.png',
    'assets/images/Untitled.png',
  ];
  Future<void> fetchPopupData() async {
    try {
      List<PopupModel>? dataList = await Api.getPopupList();

      if (dataList.isNotEmpty) {
        setState(() {
          poppularList = dataList;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching popup data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPopupData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white, surfaceTintColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          width: screenWidth * 0.14,
        ),
        // centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlarmPage()),
              );
            },
            child: const Icon(
              Icons.notifications_outlined,
              size: 32,
              color: Color.fromARGB(255, 106, 105, 105),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.055,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchInput = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Color(0xFFADD8E6),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Color(0xFFADD8E6),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    labelText: '검색',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontFamily: 'recipe',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search_sharp,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: sliderWidget(),
              ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '인기 있는 팝업스토어',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                            '더보기',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: screenWidth * 0.8,
                    child: ListView.builder(
                      itemCount: poppularList?.length ?? 0, // null 체크 추가
                      // physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final popup = poppularList![index];

                        // 팝업 데이터를 표시하는 위젯을 반환합니다.
                        return Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.05,
                              right: poppularList?.length == index + 1
                                  ? screenWidth * 0.05
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PopupDetail(
                                    storeId: popup.id!,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: screenWidth * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  popup.image != null && popup.image!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${popup.image![0]}',
                                            width: screenWidth * 0.5,
                                            height: screenWidth * 0.5,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/logo.png',
                                            width: screenWidth * 0.5,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '${popup.name}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat("yy.MM.dd").format(DateTime.parse(popup.start!))} ~ ${DateFormat("yy.MM.dd").format(DateTime.parse(popup.end!))}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
