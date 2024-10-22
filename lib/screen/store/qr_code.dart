import 'package:flutter/material.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatefulWidget {
  final PopupModel popup;
  const QrCode({super.key, required this.popup});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  dynamic qr;

  Future<void> popupQr() async {
    Map<String, dynamic> data = await StoreApi.postPopupQR(widget.popup.id!);

    if (data.toString().contains(('fail'))) {
    } else {
      setState(() {
        qr = data;
      });
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
      body: qr != null // Check if qr is not null
          ? Center(
              child: QrImageView(
                data: qr['QRcode'],
                version: QrVersions.auto,
                size: 200.0,
              ),
            )
          : const Center(
              child:
                  CircularProgressIndicator()), // Show a loading indicator if qr is null
    );
  }
}
