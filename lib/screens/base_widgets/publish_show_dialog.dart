import 'package:flutter/material.dart';

enum PublishConfirmAction { CANCEL, PUBLISH }

Future<PublishConfirmAction> PublishCustomShowDialog(BuildContext context,
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
        backgroundColor: Colors.black,
        contentTextStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto Medium',
            color: Color(0xFF868E9C)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto Medium',
            color: Color(0xFF868E9C)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: new BorderSide(color: Color(0xFF272D3A)),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Cancel",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto Medium',
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(PublishConfirmAction.CANCEL);
            },
          ),
          new FlatButton(
            child: new Text(
              "Publish",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto Medium',
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(PublishConfirmAction.PUBLISH);
            },
          ),
        ],
      );
    },
  );
}
