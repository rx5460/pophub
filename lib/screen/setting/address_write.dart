import 'package:easy_localization/easy_localization.dart';
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
        showAlert(context, ('success').tr(),
            ('address_registration_has_been_completed').tr(), () {
          Navigator.of(context).pop();
        });
      }
    } else {
      if (mounted) {
        showAlert(
            context, ('warning').tr(), ('address_registration_failed').tr(),
            () {
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
        showAlert(context, ('success').tr(),
            ('address_modification_has_been_completed').tr(), () {
          Navigator.of(context).pop();
        });
      }
    } else {
      if (mounted) {
        showAlert(
            context, ('warning').tr(), ('address_modification_failed').tr(),
            () {
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
        builder: (context) => RemediKopo(),
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
        appBar: CustomTitleBar(
          titleName: ('titleName_10').tr(),
          onBackPressed: () {
            Navigator.pop(context, totalAddress);
          },
        ),
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
                      Text(
                        ('find_address').tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.BUTTON_GREY),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            ('my_address').tr(),
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
                      Text(
                        ('detailed_address').tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                  labelText: ('labelText_7').tr()),
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
                                  showAlert(
                                      context,
                                      ('failure').tr(),
                                      ('please_write_your_detailed_address')
                                          .tr(), () {
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  ('input').tr(),
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
                      const SizedBox(height: 10),
                    ],
                  )),
              Text(
                ('my_address').tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                          isShow ? ('complete').tr() : ('correction').tr(),
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
              //     child: Text(
              //       ('complete').tr(),
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
