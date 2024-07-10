import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meroaichat/NotePad/notepad.dart';
import 'package:meroaichat/main.dart';
import 'LanguageTranslator/languagetranslator.dart';
import 'QR_Code_Reader/qr_code_reader.dart';

class ChoicePage extends StatefulWidget {
  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> with TickerProviderStateMixin {
  AnimationController? _controller;
  bool _emergencyVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    // Start blinking animation for emergency
    Timer.periodic(Duration(milliseconds: 350), (timer) {
      setState(() {
        _emergencyVisible = !_emergencyVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/merochatbotimg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 12,
                    width: 70,
                    height: 180,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/light-1.png'),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   right: 40,
                  //   top: 40,
                  //   width: 80,
                  //   height: 150,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: AssetImage('assets/images/light-2.png'),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 1),
              // child: Text(
              //   "Mero AI Chat",
              //   style: TextStyle(
              //     color: Colors.lightBlue.shade900,
              //     fontSize: 30,
              //     fontWeight: FontWeight.bold,
              //     shadows: [
              //       Shadow(
              //         blurRadius: 10.0,
              //         color: Colors.black45,
              //         offset: Offset(2.0, 2.0),
              //       ),
              //     ],
              //   ),
              // ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "App Features..",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildOptionButton(
                    context,
                    "Language Translator",
                    LanguageTranslator(),
                    secondaryColor,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildOptionButton(
                    context,
                    "AI-Chat",
                    ChatScreen(),
                    secondaryColor,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildOptionButton(
                    context,
                    "QR Code Reader",
                    QR_Code_Reader(),
                    secondaryColor,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildOptionButton(
                    context,
                    "NotePad",
                    NotePad(),
                    secondaryColor,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, String text, Widget page, Color color) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => page,
            ));
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
