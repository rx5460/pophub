import 'package:flutter/material.dart';

class GoodsOrder extends StatefulWidget {
  const GoodsOrder({super.key});

  @override
  State<GoodsOrder> createState() => _GoodsOrderState();
}

class _GoodsOrderState extends State<GoodsOrder> {
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
      body: Column(
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
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '팝업스토어 이름',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '위치 확인하기',
                            style: TextStyle(
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
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '굿즈 이름',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '10,000원 (1개)',
                              style: TextStyle(
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
                  color: const Color(0xFFAdd8E6),
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
                            const Text(
                              '2,000p',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFADD8E6),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: const Color(0xFFADD8E6)),
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
                    const Text(
                      '잔여 포인트 : 2,000p',
                      style: TextStyle(
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
                  color: const Color(0xFFAdd8E6),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05, right: screenWidth * 0.05),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 결제 금액',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        )),
                    Text(
                      '8,000원',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFADD8E6),
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
                  color: const Color(0xFFAdd8E6),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05, right: screenWidth * 0.05),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '상품 금액',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '10,000원',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '포인트 할인',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '-2,000원',
                          style: TextStyle(
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
                  color: const Color(0xFFAdd8E6),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('결제 방법',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.08,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color(
                            0xFFADD8E6,
                          ),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.dashboard),
                    ),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              // duration: const Duration(milliseconds: 300),
              width: screenWidth * 0.9,

              height: screenHeight * 0.07,

              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFFADD8E6),
                  ),
                  color: const Color(0xFFADD8E6)),
              child: InkWell(
                onTap: () {
                  setState(() {});
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
    );
  }
}
