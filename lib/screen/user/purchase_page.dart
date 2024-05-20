import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final WebViewController _webViewController;
  String token = "";
  String profileData = "";

  Future<void> _showToken() async {
    token = (await _storage.read(key: 'token'))!;
    setState(() {});
  }

  @override
  void initState() {
    _showToken();
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
            if (request.url.startsWith('intent')) {
              String parseUrl = request.url;
              if (parseUrl.contains("intent")) {
                parseUrl = parseUrl.replaceAll("intent", "kakaotalk");
              }
              launchUrlString(parseUrl);
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('http://localhost')) {
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://online-pay.kakao.com/mockup/v1/ecc24646dccedae14bd1235b66dc40cfe0a4198128b6371fdb3e594a1e70d8b5/mInfo'));
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
