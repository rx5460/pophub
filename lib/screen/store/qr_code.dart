import 'package:flutter/material.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QrCode extends StatefulWidget {
  final PopupModel popup;
  const QrCode({super.key, required this.popup});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  late final WebViewController _webViewController;
  dynamic qr;

  Future<void> popupQr() async {
    Map<String, dynamic> data = await StoreApi.postPopupQR(widget.popup.id!);

    if (data.toString().contains('fail')) {
      // Handle failure case if needed
    } else {
      setState(() {
        qr = data;
      });

      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(qr['QRcode']));
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeQr(); // Call the new method
  }

  // New method to handle async call
  Future<void> _initializeQr() async {
    await popupQr(); // Await the popupQr method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: qr != null // Check if qr is not null
          ? WebViewWidget(controller: _webViewController)
          : const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            ),
    );
  }
}
