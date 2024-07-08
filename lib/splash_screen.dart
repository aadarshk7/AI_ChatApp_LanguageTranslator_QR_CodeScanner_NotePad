import 'package:flutter/material.dart';
import 'package:meroaichat/main.dart'; // Replace with your main screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to main screen after a delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/chat'); // Replace '/main' with your main screen route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            'assets/images/merochatbotimg.jpg',
            width: 200, // Adjust as needed
            height: 200, // Adjust as needed
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
