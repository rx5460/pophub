import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/utils/log.dart';
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
            Logger.debug("### ${request.url}");
            String parseUrl = request.url;
            if (parseUrl.contains("code=")) {
              String token = parseUrl.split("code=")[1];
              await _storage.write(key: 'token', value: token);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomNavigationPage()));
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
