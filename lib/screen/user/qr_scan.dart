import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/alarm/alarm.dart';
import 'package:pophub/utils/api/visit_api.dart';
import 'package:pophub/utils/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QrScan extends StatefulWidget {
  final String type;
  const QrScan({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool hasScanned = false; // New variable to track if a scan has occurred

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!hasScanned) {
        // Only process the first scan
        setState(() {
          hasScanned = true; // Prevent further scans
          result = scanData;
          addSchedule(result!.code);
        });
      }
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
        print('QR 코드가 인식되었습니다: $code');
        Map<String, dynamic> data =
            await VisitApi.reservationVisit(code, widget.type);

        if (!data.toString().contains("실패")) {
          // 방문 인증 성공 시 알림 전송
          showAlert(context, "guide".tr(), "reservation_succses".tr(),
              () async {
            await sendAlarmAndNotification(); // 알림 전송 메소드 호출
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          // 방문 인증 실패 시 알림
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

  Future<void> sendAlarmAndNotification() async {
    final Map<String, String> alarmDetails = {
      'title': ('방문 확인 완료').tr(),
      'label': ('방문 확인이 성공적으로 완료되었습니다').tr(),
      'time': DateFormat(('MM월 dd일 hh시 mm분').tr()).format(DateTime.now()),
      'active': 'true',
    };

    // 서버에 알람 추가
    await http.post(
      Uri.parse('http://3.233.20.5:3000/alarm_add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': User().userName,
        'type': 'alarms',
        'alarmDetails': alarmDetails,
      }),
    );

    // Firestore에 알람 추가
    await FirebaseFirestore.instance
        .collection('users')
        .doc(User().userName)
        .collection('alarms')
        .add(alarmDetails);

    // 로컬 알림 발송
    await const AlarmList().showNotification(
        alarmDetails['title']!, alarmDetails['label']!, alarmDetails['time']!);
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'reservation_select_text'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
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
