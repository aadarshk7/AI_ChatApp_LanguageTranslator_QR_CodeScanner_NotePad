import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QR_Code_Reader extends StatefulWidget {
  @override
  _QR_Code_ReaderState createState() => _QR_Code_ReaderState();
}

class _QR_Code_ReaderState extends State<QR_Code_Reader> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                child: Text('Pick QR Code Image from Gallery'),
              ),
              SizedBox(height: 20),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 20),
              _buildQrView(context),
              SizedBox(height: 20),
              _buildScanResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400
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
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Widget _buildScanResult() {
    return qrText != null
        ? GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: qrText!));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied to Clipboard')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Scan Result: $qrText',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    )
        : Container();
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

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No permission')));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        qrText = pickedFile.path; // Placeholder for decoded QR code string
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true); // for iOS
    } else {
      throw 'Could not launch $url';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: QR_Code_Reader(),
  ));
}
