import 'dart:async';
import 'package:flutter/material.dart';
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
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/light-2.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 75,
                    top: 380,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Mero AI Chat",
                          style: TextStyle(
                            color: Colors.lightBlue.shade900,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildOptionButton(
                    context,
                    "Language Translator",
                    LanguageTranslator(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildOptionButton(
                    context,
                    "AI-Chat",
                    ChatScreen(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildOptionButton(
                    context,
                    "QR Code Reader",
                    QR_Code_Reader(),
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

  Widget _buildOptionButton(BuildContext context, String text, Widget page) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(143, 148, 251, 1),
            Color.fromRGBO(143, 148, 251, .6),
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
