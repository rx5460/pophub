import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';

class WaitingInfo extends StatefulWidget {
  const WaitingInfo({super.key});

  @override
  State<WaitingInfo> createState() => _WaitingInfoState();
}

class _WaitingInfoState extends State<WaitingInfo> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '예약하기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: const Row(
                    children: [
                      Text(
                        '서울 라이프 팝업스토어',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 24,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: const Text(
                    '전시',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Constants.DARK_GREY),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.04),
                  child: Container(
                    height: 2,
                    width: screenWidth,
                    color: Constants.DEFAULT_COLOR,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      // bottom: screenHeight * 0.03,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "나의 순서",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "18",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              "번째",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "대기 번호 ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "18번",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '2024.07.30 17:21 등록',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Constants.DARK_GREY),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                  child: Container(
                    height: 2,
                    width: screenWidth,
                    color: Constants.DEFAULT_COLOR,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: const Text(
                    '등록 정보',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      bottom: screenHeight * 0.03,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "총 입장 인원",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '2 명',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.04),
            child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.07,
              child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    '닫기',
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
