import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xenome/models/User.dart';
import 'package:xenome/screens/base_widgets/login_register_button.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'not_si_register.dart';
import 'package:xenome/screens/not_si/send_verification_email.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignInAccount googleSignInAccount;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String uid;

Future<String> signInWithGoogle() async {
  if (googleSignInAccount == null) {
    // Start the sign-in process:
    googleSignInAccount = await googleSignIn.signIn();
  }

  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  uid = user.uid;
  imageUrl = user.photoUrl;
  String userId = await Auth().signUpWithGoogle(name, email, uid, imageUrl);
  User userInfo = await Auth().getUserInfo(userId);
  SessionManager.saveUserInfoToLocal(userInfo);

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

class NotSiLogIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotSiLogInState();
}

class _NotSiLogInState extends State<NotSiLogIn> {
  final _formKey = new GlobalKey<FormState>();

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
        userId = await Auth().signIn(_email, _password);

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          //save user info in SessionManager (SharedPreference)
          User user = await Auth().getUserInfo(userId);
          SessionManager.saveUserInfoToLocal(user);

//          SessionManager.setUserId(userId);
//          SessionManager.setTellUsName(user.tellusname);
//          SessionManager.setEmail(user.email);
//          SessionManager.setImage(user.image);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
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

  bool _autoValidate = false;

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

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  _launchURL() async {
    const url = 'https://xenome.app/terms-policy/';

    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 14.0,
              color: Color(0xFFF93B46),
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size(null, 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
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
                      text: "Welcome back",
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
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(14.0)),
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          style: TextStyle(
                            fontFamily: 'Roboto Reqular',
                            color: Color(0xFFFFFFFF),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF868E9C),
                            ),
                            errorStyle: TextStyle(color: Color(0xFFF93B46)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFFF93B46),
                                  style: BorderStyle.solid),
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
                          onSaved: (value) => _email = value.trim(),
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
                          //focusNode: myPasswordFocusNode,
                          maxLines: 1,
                          obscureText: true,
                          autofocus: false,
                          style: TextStyle(
                            fontFamily: 'Roboto Reqular',
                            color: Color(0xFFFFFFFF),
                          ),

                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF868E9C),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            errorStyle: TextStyle(color: Color(0xFFF93B46)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFFF93B46),
                                  style: BorderStyle.solid),
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

                          validator: (value) =>
                              value.isEmpty ? 'Password can\'t be empty' : null,
                          onSaved: (value) => _password = value.trim(),
                        ),
                      ),
                    ),
                 
                  ],
                ),
              ),
              showErrorMessage(),
              LoginRegisterButton(
                title: 'Log in',
                onPressed: validateAndSubmit,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SendVerificationEmail()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Reset password",
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                  ),
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
              //                 data: new IconThemeData(color: Color(0xFFFFFFFF)),
              //                 child: new Icon(FontAwesomeIcons.facebookSquare),
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
              //         width: 20,
              //       ),
              //       Expanded(
              //         child: MaterialButton(
              //           onPressed: () {
              //             signInWithGoogle().whenComplete(() {
              //               Navigator.of(context).push(
              //                 MaterialPageRoute(
              //                   builder: (context) {
              //                     return Home();
              //                   },
              //                 ),
              //               );
              //             });
              //           },
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             children: <Widget>[
              //               IconTheme(
              //                 data: new IconThemeData(color: Color(0xFFFFFFFF)),
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
                      ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Center(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Not a member? ",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      TextSpan(
                        text: "Create an account",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return NotSiRegister();
                              })),
                        style: Theme.of(context).textTheme.headline,
                      )
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
