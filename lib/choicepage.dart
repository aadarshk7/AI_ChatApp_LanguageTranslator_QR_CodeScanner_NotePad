import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meroaichat/main.dart';

import 'LanguageTranslator/languagetranslator.dart';
import 'QR_Code_Reader/qr_code_reader.dart';



class ChoicePage extends StatefulWidget {
  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage>
    with TickerProviderStateMixin {
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
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/merochatbotimg.jpg'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: 12,
                          width: 70,
                          height: 180,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                      Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                    AssetImage('assets/images/'))),
                          )),
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
                                ),
                              ),
                            ),
                          )),
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
                                  offset: Offset(0, 10))
                            ]),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  // builder: (BuildContext context) =>
                                  //     LoginScreen()));
                                    builder: (BuildContext context) =>
                                        LanguageTranslator()));
                              },
                              child: Text(
                                "Language Translator",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => ChatScreen()));
                                // builder: (BuildContext context) =>
                                //      AdminDriver()));
                                //  builder: (BuildContext context) =>
                                //      AdminPage(collectionName: 'users')));
                              },
                              child: Text(
                                "AI-Chat",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        QR_Code_Reader()));
                              },
                              child: Text(
                                "QR Code Reader",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      // Emergency button with left-right animation
                      // Emergency button with left-right animation
                      // AnimatedContainer(
                      //   duration: Duration(milliseconds: 500),
                      //   width: _emergencyVisible ? 100 : 0,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     color: _emergencyVisible
                      //         ? Colors.red
                      //         : Colors.transparent,
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                      //   child: Center(
                      //     child: TextButton(
                      //       onPressed: () {
                      //         // Add emergency action here
                      //         // For example, navigate to user's phone
                      //         // Replace 'UserMobilePhonePage' with the actual page
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => LoginScreen(),
                      //           ),
                      //         );
                      //       },
                      //       child: Text(
                      //         "102",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),





                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
