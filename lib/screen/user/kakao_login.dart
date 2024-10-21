import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoLoginPage extends StatefulWidget {
  const KakaoLoginPage({super.key, required this.url});
  final String url;

  @override
  State<KakaoLoginPage> createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
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
            String parseUrl = request.url;

            parseUrl =
                parseUrl.replaceAll('3.88.120.90:3000', '3.233.20.5:3000');
            Logger.debug("### $parseUrl");
            if (parseUrl.contains("callback?code=")) {
              final response = await http.get(Uri.parse(parseUrl));
              Logger.debug('response: $response');
              if (response.statusCode == 201) {
                try {
                  String data = response.body;

                  var jsonData = jsonDecode(data);
                  Logger.debug('Parsed JSON: $jsonData');

                  String token = jsonData['token'];
                  String id = jsonData['userId'].toString();

                  await _storage.write(key: 'token', value: token);
                  User().userId = id;

                  if (mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavigationPage()));
                  }
                } catch (e) {
                  if (mounted) {
                    showAlert(
                        context, ('warning').tr(), ('simple_login_failed').tr(),
                        () {
                      Navigator.of(context).pop();
                    });
                  }
                }
              } else {
                // 에러 처리
                if (mounted) {
                  showAlert(context, ('warning').tr(),
                      ('failed_to_retrieve_simple_login_information').tr(), () {
                    Navigator.of(context).pop();
                  });
                }

                Logger.debug(" ${response.body}");
              }

              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
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
