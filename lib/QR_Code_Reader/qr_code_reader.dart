import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // For clipboard
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
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: qrText!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to Clipboard')),
                        );
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
                  ElevatedButton(
                    onPressed: () {
                      _pickImage();
                    },
                    child: Text('Pick QR Code Image from Gallery'),
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
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
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
      // Here you can use any QR code decoding library to decode the image
      // For simplicity, we will set the image path as the QR code text
      // You might want to use a QR code decoding library here
      setState(() {
        qrText = pickedFile.path; // Set this to the decoded QR code string
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
