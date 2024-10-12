import 'dart:io' show File;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfileAdd extends StatefulWidget {
  final VoidCallback refreshProfile;
  final bool useCallback;
  final bool isUser;
  const ProfileAdd({
    super.key,
    required this.refreshProfile,
    required this.useCallback,
    required this.isUser,
  });

  @override
  State<ProfileAdd> createState() => _ProfileAddState();
}

class _ProfileAddState extends State<ProfileAdd> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? nicknameInput;
  bool nicknameChecked = false;
  String? _gender = 'M'; // 기본 선택 옵션을 ('man').tr()로 설정

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

  Future<void> nameCheckApi() async {
    Map<String, dynamic> data = await UserApi.getNameCheck(nicknameInput ?? '');

    if (mounted) {
      if (!data.toString().contains("Exists")) {
        showAlert(context, ('guide').tr(), ('nicknames_are_available').tr(),
            () {
          Navigator.of(context).pop();
        });
        setState(() {
          nicknameChecked = true;
        });
      } else {
        showAlert(context, ('warning').tr(), ('nickname_is_duplicated').tr(),
            () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> profileAdd() async {
    print(User().userName);
    Map<String, dynamic> data = _image == null
        ? await UserApi.postProfileAdd(
            User().role == "President" || !widget.isUser
                ? User().userId
                : nicknameInput != null
                    ? nicknameInput.toString()
                    : User().userId,
            User().role == "President" || !widget.isUser
                ? '0'
                : _gender.toString(),
            User().role == "President" || !widget.isUser
                ? '0'
                : ageController.text != ""
                    ? ageController.text
                    : '0',
            phoneController.text)
        : await UserApi.postProfileAddWithImage(
            User().role == "President" || !widget.isUser
                ? User().userId
                : nicknameInput != null
                    ? nicknameInput.toString()
                    : "",
            User().role == "President" || !widget.isUser
                ? '0'
                : _gender.toString(),
            User().role == "President" || !widget.isUser
                ? '0'
                : ageController.text != ""
                    ? ageController.text
                    : '0',
            _image == null ? null : File(_image!.path),
            phoneController.text);

    if (!data.toString().contains("fail")) {
      if (widget.useCallback) {
        widget.refreshProfile();
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationPage(),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        showAlert(context, ('warning').tr(), ('adding_profile_failed').tr(),
            () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  void closePage() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomTitleBar(
            titleName: ('titleName_4').tr(),
            onBackPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MultiProvider(providers: [
                            ChangeNotifierProvider(
                                create: (_) => UserNotifier())
                          ], child: const BottomNavigationPage())));
            }),
        body: Padding(
          padding: const EdgeInsets.only(
              left: Constants.DEFAULT_PADDING * 1.2,
              right: Constants.DEFAULT_PADDING,
              bottom: Constants.DEFAULT_PADDING),
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        Constants.DEFAULT_PADDING,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.2,
                                  child: CircleAvatar(
                                    backgroundImage: _image != null
                                        ? FileImage(File(_image!.path))
                                        : (User().file.isNotEmpty
                                                ? NetworkImage(User().file)
                                                : const AssetImage(
                                                    'assets/images/logo.png'))
                                            as ImageProvider,
                                    radius: 1000,
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(screenWidth * 0.2 - 18, -48),
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Constants.DEFAULT_COLOR,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
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
                        Visibility(
                            visible: User().role == "General Member" ||
                                widget.isUser,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                Text(
                                  ('labelText').tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                SizedBox(
                                  width: screenWidth * 0.85,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: nicknameController,
                                          onChanged: (value) {
                                            setState(() {
                                              nicknameChecked = false;
                                              nicknameInput = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            labelText: ('labelText').tr(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.1,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.22,
                                        height: screenHeight * 0.065,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if (nicknameChecked) {
                                              setState(() {
                                                nicknameChecked = false;
                                              });
                                            } else if (nicknameInput != '') {
                                              nameCheckApi();
                                            }
                                          },
                                          child: Center(
                                            child: Text(
                                              nicknameChecked
                                                  ? ('correction').tr()
                                                  : ('duplicate_check').tr(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  ('labelText_1').tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                SizedBox(
                                  width: screenWidth * 0.85,
                                  child: TextField(
                                    controller: ageController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      labelText: ('labelText_1').tr(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                SizedBox(height: screenHeight * 0.01),
                              ],
                            )),
                        Text(
                          ('cell_phone_number').tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        SizedBox(
                          width: screenWidth * 0.85,
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: ('labelText_2').tr(),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: User().role == "General Member" ||
                                widget.isUser,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                Text(
                                  ('gender').tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                    height: screenHeight * 0.003,
                                    width: screenWidth * 0.003),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // 남자 선택
                                    Radio<String>(
                                      value: 'M',
                                      groupValue: _gender,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _gender = 'M';
                                        });
                                      },
                                      child: Text(('man').tr()),
                                    ),
                                    const SizedBox(width: 20), // 라디오 버튼 간의 간격
                                    // 여자 선택
                                    Radio<String>(
                                      value: 'F',
                                      groupValue: _gender,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _gender = 'F';
                                        });
                                      },
                                      child: Text(('female').tr()),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.03),
                              ],
                            )),
                        const Spacer(),
                        SizedBox(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.07,
                          child: OutlinedButton(
                              onPressed: () {
                                if (User().role == "General Member" ||
                                    widget.isUser) {
                                  if (nicknameChecked &&
                                      nicknameInput != null &&
                                      nicknameInput!.isNotEmpty &&
                                      ageController.text.isNotEmpty &&
                                      phoneController.text.isNotEmpty) {
                                    profileAdd();
                                  } else {
                                    showAlert(
                                        context,
                                        ('warning').tr(),
                                        ('please_enter_all_fields_correctly_and_check_for_duplicate_nicknames')
                                            .tr(), () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                } else {
                                  if (phoneController.text.isNotEmpty) {
                                    profileAdd();
                                  } else {
                                    showAlert(
                                        context,
                                        ('warning').tr(),
                                        ('please_enter_all_fields_correctly_and_check_for_duplicate_nicknames')
                                            .tr(), () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
                              },
                              child: Text(('complete').tr())),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ));
  }
}
