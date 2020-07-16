import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:xenome/screens/base_widgets/login_register_button.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'package:xenome/screens/not_si/not_si_log_in.dart';
import 'package:xenome/screens/not_si/not_si_log_in_dynamic.dart';
import 'login_sentence.dart';
import 'package:url_launcher/url_launcher.dart';

class NotSiRegisterDyna extends StatefulWidget {
  NotSiRegisterDyna({this.dynalink, this.auth, this.loginCallback});
  final String dynalink;

  BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _NotSiRegisterDynaState createState() => _NotSiRegisterDynaState();
}

class _NotSiRegisterDynaState extends State<NotSiRegisterDyna> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Pleaes enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Please enter a valid email address';
  }

  _launchURL() async {
    const url = 'https://xenome.app/terms-policy/';

    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String _tellname;
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

// Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = await Auth().signUp(_tellname, _email, _password);
        //auth.sendEmailVerification();
//        userId = await widget.auth.registerUser(_email, _password);
        // widget.auth.sendEmailVerification();
        //_showVerifyEmailSentDialog();
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NotSiLogInDyna(dynalink: widget.dynalink,)));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
            ]),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Container(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new IconButton(
                          icon: Icon(Icons.navigate_before,
                              size: 25, color: Color(0xFF868E9C)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => NotSiHome()),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 30, right: 30),
            child: ListView(
              children: <Widget>[
                TitleSentence(),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Mix with like-minded critical thinkers",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Embrace the opportunity to have your say or",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "create your own experience maps while gathering",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "valuable insights from the community",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: new BorderRadius.circular(14.0)),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: 'Roboto Reqular',
                              color: Color(0xFFFFFFFF),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Tell us your name',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF868E9C),
                                //color: myEmailFocusNode.hasFocus ? Color(0xFFFFFFFF) : Color(0xFF868E9C)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFFFFFFFF),
                                    style: BorderStyle.solid),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF868E9C),
                                    style: BorderStyle.solid),
                              ),
                            ),
                            onSaved: (value) => _tellname = value,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: new BorderRadius.circular(14.0)),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: 'Roboto Reqular',
                              color: Color(0xFFFFFFFF),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF868E9C),
                                //color: myEmailFocusNode.hasFocus ? Color(0xFFFFFFFF) : Color(0xFF868E9C)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFFFFFFFF),
                                    style: BorderStyle.solid),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF868E9C),
                                    style: BorderStyle.solid),
                              ),
                            ),
                            validator: _validateEmail,
                            onSaved: (value) => _email = value,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: new BorderRadius.circular(14.0)),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: 'Roboto Reqular',
                              color: Color(0xFFFFFFFF),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF868E9C),
                                //color: myEmailFocusNode.hasFocus ? Color(0xFFFFFFFF) : Color(0xFF868E9C)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFFFFFFFF),
                                    style: BorderStyle.solid),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF868E9C),
                                    style: BorderStyle.solid),
                              ),
                            ),
                            obscureText: true,
                            validator: pwdValidator,
                            onSaved: (value) => _password = value,
                          ),
                        ),
                      ),
                      LoginRegisterButton(
                        title: 'Create account',
                        onPressed: validateAndSubmit,
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child: Center(
                //     child: RichText(
                //       text: TextSpan(
                //         text: "Or continue with...",
                //         style: Theme.of(context).textTheme.subtitle,
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Expanded(
                //         child: MaterialButton(
                //           onPressed: () {},
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                //             children: <Widget>[
                //               IconTheme(
                //                 data:
                //                     new IconThemeData(color: Color(0xFFFFFFFF)),
                //                 child:
                //                     new Icon(FontAwesomeIcons.facebookSquare),
                //               ),
                //               Text(
                //                 'Facebook',
                //                 style: TextStyle(
                //                     fontSize: 15,
                //                     fontFamily: 'Roboto Medium',
                //                     color: Color(0xFFFFFFFF)),
                //               )
                //             ],
                //           ),
                //           color: Color(0xFF4267B2),
                //           elevation: 0,
                //           minWidth: 150,
                //           height: 40,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(50)),
                //         ),
                //       ),
                //       Container(
                //         width: 10,
                //       ),
                //       Expanded(
                //         child: MaterialButton(
                //           onPressed: () {},
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                //             children: <Widget>[
                //               IconTheme(
                //                 data:
                //                     new IconThemeData(color: Color(0xFFFFFFFF)),
                //                 child: new Icon(FontAwesomeIcons.google),
                //               ),
                //               Text(
                //                 'Google',
                //                 style: TextStyle(
                //                     fontSize: 15,
                //                     fontFamily: 'Roboto Medium',
                //                     color: Color(0xFFFFFFFF)),
                //               )
                //             ],
                //           ),
                //           color: Color(0xFFDB4437),
                //           elevation: 0,
                //           minWidth: 150,
                //           height: 40,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(50)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "By completing you agree to our ",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        TextSpan(
                          text: "Terms & Policy",
                          style: Theme.of(context).textTheme.headline,
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL();
                            },
                        )
                      ]),
                    ),
                  ),
                ),
                LoginSentence()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
