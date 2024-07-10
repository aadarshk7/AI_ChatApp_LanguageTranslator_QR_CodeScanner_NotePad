import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  // File? _image;
  File ? _selectedImage;

Future _pickImageFromGallery() async{
 final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);

 setState(() {
   _selectedImage = File(returnedImage!.path);
 });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Image from Gallery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : Text('No image selected.'),
            SizedBox(height: 20),
            MaterialButton(
              onPressed:()
            {},
            ),
            _selectedImage ! = null ? Image.file(_selectedImage) : const Text("Select an image")
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: ImagePickerDemo(),
));
