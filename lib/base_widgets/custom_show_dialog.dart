import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, SAVE }

Future<ConfirmAction> CustomShowDialog(BuildContext context,
    {String title, String content}) async {
  // flutter defined function
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Cancel",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto Medium',
                color: Color(0xFFEE0000),
              ),
            ),
            onPressed: () {
              
              Navigator.of(context).pop(ConfirmAction);
            },
          ),
          new FlatButton(
            child: new Text(
              "Save",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto Medium',
                color: Color(0xFF0000EE),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.SAVE);
            },
          ),
        ],
      );
    },
  );
}
