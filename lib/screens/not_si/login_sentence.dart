import 'package:flutter/material.dart';
import 'not_si_log_in.dart';

class LoginSentence extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginSentenceState();
}

class _LoginSentenceState extends State<LoginSentence> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return NotSiLogIn();
          }));
        },
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Already a member? ",
              style: Theme.of(context).textTheme.subtitle,
            ),
            TextSpan(
              text: "Log in",
              style: Theme.of(context).textTheme.headline,
            )
          ]),
        ),
        height: 11,
      ),
    );
  }
}
