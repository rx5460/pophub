import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/address_model.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/model/kopo_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/utils/api/address_api.dart';
import 'package:pophub/utils/remedi_kopo.dart';
import 'package:pophub/utils/utils.dart';

class AddressWritePage extends StatefulWidget {
  const AddressWritePage({super.key});

  @override
  _AddressWritePageState createState() => _AddressWritePageState();
}

class _AddressWritePageState extends State<AddressWritePage> {
  final _locationController = TextEditingController();
  String? pickAddress = "";
  int? addressId = 0;
  String addressDetail = "";
  String? totalAddress = "";
  bool isShow = false;

  List<CategoryModel> categoryList = [];

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> getAddress() async {
    AddressModel data = await AddressApi.getAddress(User().userName);

    if (data.addressId != null) {
      setState(() {
        totalAddress = data.address;
        addressId = data.addressId;
        isShow = false;
      });
    } else {
      setState(() {
        isShow = true;
      });
    }
  }

  Future<void> addAddress() async {
    Map<String, dynamic> data = await AddressApi.postAddress(
        User().userName, totalAddress != null ? totalAddress! : "");

    if (!data.toString().contains("fail")) {
      if (mounted) {
        showAlert(context, "성공", "주소 등록을 완료했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    } else {
      if (mounted) {
        showAlert(context, "경고", "주소 등록에 실패했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> putAddress() async {
    Map<String, dynamic> data = await AddressApi.putAddress(
        addressId, totalAddress != null ? totalAddress! : "");

    if (!data.toString().contains("fail")) {
      if (mounted) {
        showAlert(context, "성공", "주소 수정을 완료했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    } else {
      if (mounted) {
        showAlert(context, "경고", "주소 수정을 실패했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> _pickLocation() async {
    if (!mounted) return;

    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RemediKopo(),
      ),
    );

    if (model != null && model.address != null) {
      setState(() {
        pickAddress = model.address;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
        appBar: const CustomTitleBar(titleName: "문의 하기"),
        body: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: isShow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "주소 찾기",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.BUTTON_GREY),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: const Text(
                            '스토어 위치',
                          ),
                          subtitle: pickAddress != ""
                              ? Text(pickAddress.toString())
                              : null,
                          trailing: const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          onTap: () => _pickLocation(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "상세 주소",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                  labelText: '상세 위치를 적어주세요.'),
                              onChanged: (value) => addressDetail = value,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: screenWidth * 0.22,
                            height: screenHeight * 0.065,
                            child: OutlinedButton(
                              onPressed: () {
                                if (_locationController.text != "") {
                                  setState(() {
                                    totalAddress =
                                        ("${pickAddress!} $addressDetail");
                                  });
                                } else {
                                  showAlert(context, "실패", "상세주소를 작성해주세요.", () {
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: const Center(
                                child: Text(
                                  '입력',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
              const Text(
                "내 주소",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1,
                          color: Constants.BUTTON_GREY,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          totalAddress != null ? totalAddress! : "",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: screenWidth * 0.22,
                    height: screenHeight * 0.065,
                    child: OutlinedButton(
                      onPressed: () {
                        if (isShow && totalAddress != null && addressId == 0) {
                          addAddress();
                        } else if (isShow &&
                            totalAddress != null &&
                            addressId != 0) {
                          putAddress();
                        }

                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      child: Center(
                        child: Text(
                          isShow ? '완료' : '수정',
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
              // const Spacer(),
              // SizedBox(
              //   width: double.infinity,
              //   child: OutlinedButton(
              //     onPressed: () {},
              //     child: const Text(
              //       '완료',
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
