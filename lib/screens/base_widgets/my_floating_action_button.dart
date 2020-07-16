import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatefulWidget {
  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool showFab = true;

  void checkSignin() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (_) => ViewXmap()),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return showFab ? Container() : Container();
  }

  void showFoatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}
