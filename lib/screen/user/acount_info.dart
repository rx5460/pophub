import 'package:flutter/material.dart';

class AcountInfo extends StatefulWidget {
  const AcountInfo({super.key});

  @override
  State<AcountInfo> createState() => _AcountInfoState();
}

class _AcountInfoState extends State<AcountInfo> {
  TextEditingController nicknameController = TextEditingController();
  String? nicknameInput;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '계정 정보',
          style: TextStyle(color: Colors.black),
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/Untitled.png'),
                          radius: 1000,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(screenWidth * 0.2 - 10, -40),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.07,
                      child: TextField(
                        controller: nicknameController,
                        onChanged: (value) {
                          setState(() {
                            nicknameInput = value;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Color(0xFFADD8E6),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Color(0xFFADD8E6),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: '닉네임',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontFamily: 'recipe',
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.22,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFFE6A3B3),
                        ),
                        // color: const Color(0xFFE6A3B3)
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: const Center(
                          child: Text(
                            '중복확인',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                width: screenWidth * 0.85,
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFFADD8E6),
                  ),
                  // color: const Color(0xFFE6A3B3)
                ),
                child: InkWell(
                  onTap: () {},
                  child: const Center(
                    child: Text(
                      '비밀번호 재설정',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                width: screenWidth * 0.85,
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFFADD8E6),
                  ),
                  // color: const Color(0xFFE6A3B3)
                ),
                child: const Center(
                  child: Text(
                    '성별',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                width: screenWidth * 0.85,
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xFFADD8E6),
                  ),
                  // color: const Color(0xFFE6A3B3)
                ),
                child: const Center(
                  child: Text(
                    '나이',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.1,
              color: const Color(0xFFADD8E6),
              child: const Center(
                child: Text(
                  '수정하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
