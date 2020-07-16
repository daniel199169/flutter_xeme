import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:link/link.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/models/User.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'package:xenome/screens/not_si/not_si_create_profile.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalSheet extends StatefulWidget {
  ProfessionalSheet({this.auth, this.logoutCallback});

  BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => _ProfessionalSheetState();
}

class _ProfessionalSheetState extends State<ProfessionalSheet> {
  String userId = '';
  String imageUrl = '';
  String tellusname = '';
  String fullname = '';
  String email = '';
  String birthday = '';
  String description = '';
  Gender gender = Gender.MALE;
  String website = '';
  String otherlink = '';
  String professional = '';
  String permission = '';
  String showMessage = '';
  Color monthlyColor = Colors.black;
  Color yearlyColor = Color(0xFF2B8DD8);

  @override
  void initState() {
    super.initState();
    userId = SessionManager.getUserId();
    imageUrl = SessionManager.getImage();
    tellusname = SessionManager.getTellUsName();
    fullname = SessionManager.getFullname();
    email = SessionManager.getEmail();
    gender = SessionManager.getGender();
    birthday = SessionManager.getDate();
    description = SessionManager.getDescription();
    website = SessionManager.getWebsite();
    otherlink = SessionManager.getOtherlink();
    professional = SessionManager.getProfessional();
    permission = SessionManager.getPermission();

    if (permission == "Request") {
      showMessage = "Waiting permission";
    } else if (permission == "premium") {
      showMessage = "You are already premium user";
    } else if (permission == "free") {
      showMessage = "Request permission";
    } else if (permission == "trial") {
      showMessage = "You are already trial user";
    }

    if (professional == "1") {
      monthlyColor = Colors.green;
    }
    if (professional == "2") {
      yearlyColor = Colors.green;
    }
  }

  _launchURL() async {
    const url = 'https://xenome.app/terms-policy/';

    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  Future<void> saveUserInfo() async {
    User newUser = new User(
        userId,
        tellusname,
        email,
        imageUrl,
        gender,
        birthday,
        description,
        fullname,
        website,
        otherlink,
        professional,
        permission);

    try {
      bool _res = await Auth().setUserInfo(newUser);

      if (_res) {
        SessionManager.saveUserInfoToLocal(newUser);
      } else {
        //  Global.showToastMessage(context: context, msg:'Something went wrong');
      }
    } catch (e) {
      print(e);
    }
  }

  saveDraft() async {
    await saveUserInfo();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyProfile()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: CustomPaint(painter: Drawhorizontalline()),
                    ),
                  ),
                  TitleSentence(),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Center(
                      child: new Text(
                        'Create a professional account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Center(
                      child: new Text(
                        'Let customer voice guide your business - personalise relationships, predict trends and activate staff',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Link(
                        child: new Text(
                          'Learn more',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline,
                        ),
                        url: 'https://xenome.app/',
                        onError: _showErrorSnackBar,
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 5.0),
                    child: MaterialButton(
                      child: new Text(showMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto Medium',
                            color: Color(0xFFFFFFFF),
                          )),
                      color: monthlyColor,
                      height: 60.0,
                      minWidth: 350,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                            color: Color(0xFF74D874),
                            width: 2.0,
                          )),
                      onPressed: () async {
                        if (monthlyColor == Colors.black) {
                          setState(() {
                            professional = "1";
                            monthlyColor = Color(0xFF74D874);
                            yearlyColor = Color(0xFF2B8DD8);
                          });
                        } else {
                          setState(() {
                            professional = "1";
                          });
                        }
                        if (permission == "free") {
                          SessionManager.setPermission("Request");
                          setState(() {
                            permission = "Request";
                          });
                          saveDraft();
                        }
                      },
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 5.0),
                  //   child: MaterialButton(
                  //     child: new Text('14.99 / month',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontFamily: 'Roboto Medium',
                  //           color: Color(0xFFFFFFFF),
                  //         )),
                  //     color: monthlyColor,
                  //     height: 60.0,
                  //     minWidth: 350,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(50),
                  //         side: BorderSide(
                  //           color: Color(0xFF2B8DD8),
                  //           width: 2.0,
                  //         )),
                  //     onPressed: () {
                  //       if (monthlyColor == Colors.black) {
                  //         setState(() {
                  //           professional = "1";
                  //           monthlyColor = Colors.green;
                  //           yearlyColor = Color(0xFF2B8DD8);
                  //         });
                  //       } else {
                  //         setState(() {
                  //           professional = "1";
                  //         });
                  //       }
                  //       saveDraft();
                  //     },
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  //   child: new MaterialButton(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(50.0))),
                  //     elevation: 0.0,
                  //     minWidth: 350.0,
                  //     height: 60,
                  //     color: yearlyColor,
                  //     child: new Text('\$88.99 / year*',
                  //         style: new TextStyle(
                  //             fontSize: 16.0, color: Colors.white)),
                  //     onPressed: () {
                  //       setState(() {
                  //         if (yearlyColor == Color(0xFF2B8DD8)) {
                  //           setState(() {
                  //             professional = "2";
                  //             monthlyColor = Colors.black;
                  //             yearlyColor = Colors.green;
                  //           });
                  //         } else {
                  //           setState(() {
                  //             professional = "2";
                  //           });
                  //         }
                  //       });
                  //       saveDraft();
                  //     },
                  //   ),
                  // ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Center(
                      child: new Text(
                        // '* That\'s \$7.50 / month anda 50% saving',
                        '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7),
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
                ]),
          ),
        ],
      ),
    );
  }
}
