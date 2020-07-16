import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  LoginRegisterButton({this.title, this.onPressed});

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 60.0,
      onPressed: this.onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto Medium',
              color: Color(0xFFFFFFFF),
            ),
          )
        ],
      ),
      elevation: 0,
      minWidth: 350,
      textColor: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Color(0xFF2B8DD8),
            width: 2.0,
          )),
    );
  }
}
