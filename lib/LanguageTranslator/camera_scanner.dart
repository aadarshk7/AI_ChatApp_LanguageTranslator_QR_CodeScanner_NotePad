import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:translator/translator.dart';

import 'languagetranslator.dart';

//import 'main.dart'; // Import your main file to access the LanguageTranslatorProvider

class CameraScannerScreen extends StatefulWidget {
  @override
  _CameraScannerScreenState createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageTranslatorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (qrText != null)
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: qrText!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to Clipboard')),
                        );
                      },
                      onTap: () {
                        provider.translateText(qrText!);
                      },
                      child: Text(
                        'Scan Result: $qrText',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (provider.translatedText.isNotEmpty)
                    Text(
                      'Translated Text: ${provider.translatedText}',
                      style: TextStyle(fontSize: 18),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
