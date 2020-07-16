import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'package:xenome/screens/view/cloud_message.dart';
import 'package:xenome/utils/session_manager.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class LoginCheck extends StatefulWidget {
  LoginCheck({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

//  void loginCallback() {
//    widget.auth.getCurrentUser().then((user) {
//      setState(() {
//        _userId = user.uid.toString();
//      });
//    });
//    setState(() {
//      authStatus = AuthStatus.LOGGED_IN;
//    });
//  }
//
//  void logoutCallback() {

//
//    setState(() {
//      authStatus = AuthStatus.NOT_LOGGED_IN;
//      _userId = "";
//    });
//  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  AuthStatus CheckAuthState(){
      String userId = SessionManager.getUserId();
      if(userId == null || userId.length==0) return AuthStatus.NOT_LOGGED_IN;
      return AuthStatus.LOGGED_IN;
  }

  @override
  Widget build(BuildContext context) {
    authStatus = CheckAuthState();
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new NotSiHome(
          auth: widget.auth,
//          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new CloudMessage();
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
