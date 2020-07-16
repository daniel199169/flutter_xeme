import 'package:flutter/material.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'package:xenome/screens/view/view_xmap.dart';

class ViewScreen extends StatefulWidget {
  final VoidCallback loginCallback;

  ViewScreen({this.loginCallback});
  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        floatingActionButton: MyFloatingActionButton(),
        body:NotSiHome(loginCallback: widget.loginCallback,));
  }
}

class MyFloatingActionButton extends StatefulWidget{
  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool showFab = true;

  void checkSignin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ViewXmap()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return showFab
        ? Padding(
      padding: const EdgeInsets.only(
          bottom: 160.0,
          right:25.0),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Image.asset(
          'assets/icos/arrow_forward@3x.png',
          fit: BoxFit.cover,
        ),
        onPressed: checkSignin,
      ),
    )
        : Container();
  }
  void showFoatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}
