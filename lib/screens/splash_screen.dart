import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/screens/title_sentence.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.indigo,
  Colors.pinkAccent,
  Color(0xFF2B8DD8),
];

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginCheck()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.room_service,
                          color: Colors.orange[500],
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                      ),
                      TitleSentence(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    const Text.rich(
                      TextSpan(
                        // default text style
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Made by ',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF2B8DD8),
                                  fontFamily: 'Roboto')),
                          TextSpan(
                              text: 'Ruben from Spain',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontFamily: 'Roboto')),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
