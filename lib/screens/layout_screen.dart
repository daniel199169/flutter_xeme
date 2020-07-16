import 'package:flutter/material.dart';
import 'package:xenome/screens/view_screen.dart';
import 'package:xenome/screens/not_si/not_si_create_profile.dart';

class LayoutScreen extends StatefulWidget {
  final VoidCallback loginCallback;

  LayoutScreen({this.loginCallback});

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}
bool is_signin= false;

class _LayoutScreenState extends State<LayoutScreen> {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ViewScreen(loginCallback: widget.loginCallback);

  }
}

class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: BoxDecoration(
        color: Color(0xFF272D3A),
      ),
      child: Column(
        children: <Widget>[
          NotSiCreateProfile(),
        ],
      ),
    );
  }
}

