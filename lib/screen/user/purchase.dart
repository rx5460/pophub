import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pophub/screen/alarm/alarm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PurchasePage extends StatefulWidget {
  final String api;
  final String storeId;

  const PurchasePage({super.key, required this.api, required this.storeId});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late final WebViewController _webViewController;
  String token = "";
  String profileData = "";

  @override
  void initState() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            /// 황지민 : 결제시 intent 버그를 막기위한 작업
            /// 2024/05/20 재 수정 ..
            ///
            Logger.debug("### ${request.url} efwaewaf");

            if (request.url.startsWith('intent')) {
              String parseUrl = request.url;
              if (parseUrl.contains("intent")) {
                parseUrl = parseUrl.replaceAll("intent", "kakaotalk");
              }
              launchUrlString(parseUrl);
              return NavigationDecision.prevent;
            } else if (request.url.contains("partner_user_id")) {
              showAlert(context, "결제", "결제 성공했습니다.", () async {
                // 결제 완료 알림
                const String title = '결제 완료';
                const String label = '성공적으로 결제가 완료되었습니다.';
                final String time =
                    DateFormat('MM월 dd일 HH시 mm분').format(DateTime.now());

                final Map<String, String> alarmDetails = {
                  'title': title,
                  'label': label,
                  'time': time,
                  'active': 'true',
                };

                // 서버에 알람 추가
                await http.post(
                  Uri.parse('http://3.88.120.90:3000/alarm/alarm_add'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'userName': User().userName,
                    'type': 'orderAlarms',
                    'alarmDetails': alarmDetails,
                  }),
                );
                // 판매자 알람 추가
                final Map<String, String> sellerAlarmDetails = {
                  'title': '주문 들어옴',
                  'label': '자사 굿즈 주문이 들어왔습니다.',
                  'time': time,
                  'active': 'true',
                };

                await http.post(
                  Uri.parse('http://3.88.120.90:3000/alarm/seller_alarm_add'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'storeId': widget.storeId,
                    'type': 'orderAlarms',
                    'alarmDetails': sellerAlarmDetails,
                  }),
                );

                await const AlarmList().showNotification(alarmDetails['title']!,
                    alarmDetails['label']!, alarmDetails['time']!);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('http://localhost')) {
              showAlert(context, "결제", "결제 실패했습니다.", () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(
          Uri.parse(widget.api.toString().replaceAll("aInfo", "mInfo")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebViewWidget(controller: _webViewController),
    ));
  }
}
