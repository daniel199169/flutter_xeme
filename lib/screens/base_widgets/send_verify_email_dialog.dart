import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, SAVE }

Future SendVerifyEmailShowDialog(BuildContext context) async {
  // flutter defined function
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('Instructions sent')),
        content: const Text(
            'Please check your email and follow the steps to reset password'),
        backgroundColor: Colors.black,
        contentTextStyle: TextStyle(
            fontSize: 16, fontFamily: 'Roboto Medium', color: Colors.grey[300]),
        titleTextStyle: TextStyle(
            fontSize: 20, fontFamily: 'Roboto Medium', color: Colors.grey[50]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: new BorderSide(color: Color(0xFF272D3A)),
        ),
        actions: <Widget>[
          FlatButton(
            child: Center(
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Medium',
                  color: Colors.tealAccent,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
