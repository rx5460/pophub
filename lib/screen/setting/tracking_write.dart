import 'package:easy_localization/easy_localization.dart';
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
        widget.deliveryId, selectedCourier, _trackingNumberController.text);

    if (!data.toString().contains("fail")) {
      if (mounted) {
        showAlert(context, ('success').tr(),
            ('the_waybill_registration_has_been_completed').tr(), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    } else {
      if (mounted) {
        showAlert(
            context, ('warning').tr(), ('the_waybill_registration_failed').tr(),
            () {
          Navigator.of(context).pop();
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
        appBar: CustomTitleBar(titleName: ('titleName_9').tr()),
        body: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ('select_a_courier_company').tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                DropdownButtonFormField<String>(
                  value: selectedCourier,
                  items: [
                    DropdownMenuItem<String>(
                      value: 'cjlogistics',
                      child: Text(('cj_korea_express').tr()),
                    ),
                    DropdownMenuItem<String>(
                      value: 'logen',
                      child: Text(('rosen_express').tr()),
                    ),
                    DropdownMenuItem<String>(
                      value: 'epost',
                      child: Text(('post_office_delivery').tr()),
                    ),
                    DropdownMenuItem<String>(
                      value: 'hanjin',
                      child: Text(('hanjin_express').tr()),
                    ),
                    DropdownMenuItem<String>(
                      value: 'lotte',
                      child: Text(('lotte_express').tr()),
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
                Text(
                  ('waybill').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
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
                  child: Text(
                    ('complete').tr(),
                    style: const TextStyle(
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
