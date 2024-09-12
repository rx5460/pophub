import 'package:flutter/material.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/utils/api/delivery_api.dart';
import 'package:pophub/utils/utils.dart';

class TrackingWritePage extends StatefulWidget {
  final String deliveryId;
  const TrackingWritePage({super.key, this.deliveryId = ""});

  @override
  _TrackingWritePageState createState() => _TrackingWritePageState();
}

class _TrackingWritePageState extends State<TrackingWritePage> {
  final _trackingNumberController = TextEditingController();
  String selectedCourier = "cjlogistics";

  List<CategoryModel> categoryList = [];

  @override
  void dispose() {
    _trackingNumberController.dispose();
    super.dispose();
  }

  Future<void> addTracking() async {
    Map<String, dynamic> data = await DeliveryApi.postTrackingNumber(
        "da4c607c-d90c-4887-b45e-13c34eb0f9ca",
        //widget.deliveryId,
        //Todo : 황지민 배송 넘겨받는거 .. 작업
        selectedCourier,
        _trackingNumberController.text);

    if (!data.toString().contains("fail")) {
      if (mounted) {
        showAlert(context, "성공", "운송장 등록을 완료했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    } else {
      if (mounted) {
        showAlert(context, "경고", "운송장 등록에 실패했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
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
        appBar: const CustomTitleBar(titleName: "운송장 등록"),
        body: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "택배사 선택하기",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                DropdownButtonFormField<String>(
                  value: selectedCourier,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'cjlogistics',
                      child: Text('cj대한통운'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'logen',
                      child: Text('로젠택배'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'epost',
                      child: Text('우체국택배'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'hanjin',
                      child: Text('한진택배'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'lotte',
                      child: Text('롯데택배'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedCourier = value ?? 'cjlogistics';
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "운송장",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _trackingNumberController,
                )
              ]),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    addTracking();
                  },
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
