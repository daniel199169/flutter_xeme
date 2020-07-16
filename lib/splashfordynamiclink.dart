import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'package:xenome/screens/not_si/not_si_log_in_dynamic.dart';
import 'package:xenome/screens/not_si/not_si_register_dynamic.dart';

class SplashForDynamLinkScreen extends StatefulWidget {
  SplashForDynamLinkScreen({this.dynalink});
  final String dynalink;
  @override
  _SplashForDynamLinkScreenState createState() =>
      _SplashForDynamLinkScreenState();
}

List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.indigo,
  Colors.pinkAccent,
  Color(0xFF2B8DD8),
];

class _SplashForDynamLinkScreenState extends State<SplashForDynamLinkScreen> {
  @override
  void initState() {
    super.initState();
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
                      // CircleAvatar(
                      //   backgroundColor: Colors.white,
                      //   radius: 50.0,
                      //   // child: Icon(
                      //   //   Icons.room_service,
                      //   //   color: Colors.orange[500],
                      //   //   size: 50.0,
                      //   // ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                      ),
                      TitleSentence(),
                      Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Text(
                            'Accept Invitation',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'You have been invited to participate in an',
                            style: TextStyle(
                                color: Color(0xFF868E9C), fontSize: 12),
                            textAlign: TextAlign.center,
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 30),
                          child: Text(
                            'experience map - please log in to get started',
                            style: TextStyle(
                                color: Color(0xFF868E9C), fontSize: 12),
                            textAlign: TextAlign.center,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: new TextSpan(
                              text: 'Log in',
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                        MaterialPageRoute<Null>(
                                            builder: (BuildContext context) {
                                      return NotSiLogInDyna(
                                          dynalink: widget.dynalink);
                                    })),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' or ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF868E9C))),
                                TextSpan(
                                    text: 'create an account',
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                              .push(MaterialPageRoute<Null>(
                                                  builder:
                                                      (BuildContext context) {
                                            return NotSiRegisterDyna(
                                              dynalink: widget.dynalink,
                                            );
                                          })),
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white)),
                              ],
                            ),
                          )
                        ],
                      )
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
                    // const Text.rich(
                    //   TextSpan(
                    //     // default text style
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //           text: ' Made by ',
                    //           style: TextStyle(
                    //               fontSize: 12.0,
                    //               fontWeight: FontWeight.normal,
                    //               color: Color(0xFF2B8DD8),
                    //               fontFamily: 'Roboto')),
                    //       TextSpan(
                    //           text: 'Ruben from Spain',
                    //           style: TextStyle(
                    //               fontSize: 12.0,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.orange,
                    //               fontFamily: 'Roboto')),
                    //     ],
                    //   ),
                    // )
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
