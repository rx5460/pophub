import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/api.dart';

class AcountInfo extends StatefulWidget {
  const AcountInfo({super.key});

  @override
  State<AcountInfo> createState() => _AcountInfoState();
}

class _AcountInfoState extends State<AcountInfo> {
  TextEditingController nicknameController = TextEditingController();
  String? nicknameInput;

  // XFile? _image; //이미지를 담을 변수 선언
  // final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  // //이미지를 가져오는 함수
  // Future getImage(ImageSource imageSource) async {
  //   //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
  //   final XFile? pickedFile = await picker.pickImage(source: imageSource);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
  //       // print(_image.path);
  //     });
  //   }
  // }

  String? fileName;

  Future<void> nameCheckApi() async {
    Map<String, dynamic> data = await Api.nameCheck(nicknameInput!);

    if (!data.toString().contains("fail")) {
      print(data);
    }
  }

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
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(User().file),
                          radius: 1000,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(screenWidth * 0.2 - 18, -48),
                        child: GestureDetector(
                          onTap: () {
                            // getImage(ImageSource.gallery);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFFADD8E6),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                color: Colors.white),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.settings_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Color(0xFFADD8E6),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Color(0xFFADD8E6),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: User().userName,
                          labelStyle: const TextStyle(
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
                        onTap: () {
                          if (nicknameInput != '') {
                            nameCheckApi();
                          }
                        },
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
                child: Center(
                  child: Text(
                    '성별 : ${User().gender}',
                    style: const TextStyle(
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
                child: Center(
                  child: Text(
                    '나이 : ${User().age}',
                    style: const TextStyle(
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
