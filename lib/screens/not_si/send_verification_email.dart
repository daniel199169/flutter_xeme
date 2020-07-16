import 'package:flutter/material.dart';
import 'package:xenome/screens/base_widgets/login_register_button.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'package:xenome/screens/not_si/not_si_log_in.dart';
import 'package:xenome/screens/base_widgets/send_verify_email_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendVerificationEmail extends StatefulWidget {
  @override
  _SendVerificationEmailState createState() => _SendVerificationEmailState();
}

class _SendVerificationEmailState extends State<SendVerificationEmail> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email;
  String _errorMessage;

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
    });
    if (validateAndSave()) {
      try {
        _auth.sendPasswordResetEmail(email: _email);
        await SendVerifyEmailShowDialog(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotSiLogIn()));
      } catch (e) {
        setState(() {
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
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 50),
                  child: RichText(
                    text: TextSpan(
                      text: "Reset password",
                      style: TextStyle(
                        fontFamily: 'Roboto Medium',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                      LoginRegisterButton(
                        title: 'Reset Password',
                        onPressed: validateAndSubmit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
