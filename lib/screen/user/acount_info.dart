import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/user/reset_passwd.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class AcountInfo extends StatefulWidget {
  final VoidCallback refreshProfile;
  const AcountInfo({super.key, required this.refreshProfile});

  @override
  State<AcountInfo> createState() => _AcountInfoState();
}

class _AcountInfoState extends State<AcountInfo> {
  TextEditingController nicknameController = TextEditingController();
  String? nicknameInput;

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    } catch (e) {
      Logger.debug('Error picking image: $e');
    }
  }

  String? fileName;
  bool checked = false;

  Future<void> nameCheckApi() async {
    Map<String, dynamic> data = await Api.nameCheck(nicknameInput ?? '');

    if (mounted) {
      if (!data.toString().contains("Exists")) {
        showAlert(context, "안내", "닉네임이 사용 가능합니다.", () {
          Navigator.of(context).pop();
        });
        setState(() {
          checked = true;
        });
      } else {
        showAlert(context, "경고", "닉네임이 중복되었습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> profileModify() async {
    Map<String, dynamic> data =
        await Api.profileModify(User().userId, nicknameInput!);

    if (!data.toString().contains("fail")) {
      widget.refreshProfile;
      if (mounted) Navigator.of(context).pop();
    } else {}
  }

  Future<void> profileModifyImage() async {
    Map<String, dynamic> data = await Api.profileModifyImage(
        User().userId, nicknameInput!, File(_image!.path));

    print(!data.toString().contains("fail"));
    if (!data.toString().contains("fail")) {
      widget.refreshProfile();
      closePage();
    } else {}
  }

  void closePage() {
    Navigator.pop(context);
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
                          backgroundImage: _image == null
                              ? NetworkImage(User().file)
                              : FileImage(File(_image!.path)) as ImageProvider,
                          radius: 1000,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(screenWidth * 0.2 - 18, -48),
                        child: GestureDetector(
                          onTap: () {
                            _pickImage();
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
                            checked = false;
                            nicknameInput = value;
                          });
                        },
                        readOnly: checked,
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
                          if (checked) {
                            setState(() {
                              checked = false;
                            });
                          } else if (nicknameInput != '') {
                            nameCheckApi();
                          }
                        },
                        child: Center(
                          child: Text(
                            checked ? '수정' : '중복확인',
                            style: const TextStyle(
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiProvider(providers: [
                                  ChangeNotifierProvider(
                                      create: (_) => UserNotifier())
                                ], child: const ResetPasswd())));
                  },
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
            onTap: () {
              if (checked) {
                if (_image == null) {
                  profileModify();
                } else {
                  profileModifyImage();
                }
              } else {
                showAlert(context, "경고", "닉네임 중복확인을 해주세요.", () {
                  Navigator.of(context).pop();
                });
              }
            },
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
