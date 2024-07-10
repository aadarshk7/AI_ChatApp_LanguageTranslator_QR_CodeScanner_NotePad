import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QR_Code_Reader extends StatefulWidget {
  @override
  _QR_Code_ReaderState createState() => _QR_Code_ReaderState();
}

class _QR_Code_ReaderState extends State<QR_Code_Reader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      String decodedQrCode = await _decodeQrCodeFromFile(file);

      setState(() {
        qrText = decodedQrCode;
      });
    }
  }

  Future<String> _decodeQrCodeFromFile(File file) async {
    try {
      // Read file as bytes
      List<int> imageBytes = await file.readAsBytes();

      // Use Flutter Barcode Scanner plugin to decode QR code from image bytes
      String result = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666', // Scanner overlay color
        'Cancel', // Cancel button text
        false, // Use flash
        ScanMode.DEFAULT, // Scan mode
      );

      return result;
    } catch (e) {
      print('Error decoding QR code: $e');
      return 'Failed to decode QR code';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: QR_Code_Reader(),
  ));
}
