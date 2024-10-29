import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pophub/utils/api/visit_api.dart';
import 'package:pophub/utils/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScan extends StatefulWidget {
  // final Function() refreshData;
  final String type;
  const QrScan({
    Key? key,
    required this.type,
    // required this.refreshData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        addSchedule(scanData.code);
      });
    });
  }

  Future<void> writeReview() async {}

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void addSchedule(String? code) async {
    if (code != null) {
      try {
        // 요청이 성공했다고 가정
        print('QR 코드가 인식되었습니다: $code');
        Map<String, dynamic> data =
            await VisitApi.reservationVisit(code, widget.type);

        if (!data.toString().contains("fail")) {
          // widget.refreshData;
          showAlert(context, "guide".tr(), "reservation_succses".tr(),
              () async {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          showAlert(context, "guide".tr(), "방문인증에 실패했습니다.", () async {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      } catch (e) {
        print('HTTP 요청 실패: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.6,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight * 0.075,
            decoration: const BoxDecoration(color: Colors.black54),
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, right: screenWidth * 0.05),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'reservation_select_text'.tr(),
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          // SizedBox(
          //   child: Center(
          //     child: (result != null)
          //         ? Text(
          //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         : const Text('Scan a code'),
          //   ),
          // )
        ],
      ),
    );
  }
}
