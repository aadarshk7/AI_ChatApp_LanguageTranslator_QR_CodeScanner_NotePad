import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(NotePad());

class NotePad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Picker Demo',
      home: FilePickerWidget(),
    );
  }
}

class FilePickerWidget extends StatefulWidget {
  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  Future<void> _pickFile() async {
    final XFile? selectedFile = await _picker.pickFiles();
    setState(() {
      _file = selectedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _file != null ? Text('File path: ${_file!.path}') : Text('No file selected.'),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
