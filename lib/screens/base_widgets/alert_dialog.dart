import 'package:flutter/material.dart';



Future AlertShowDialog(BuildContext context, {String title, String content}) async {
  // flutter defined function
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(title)),
        content: Text(content),
        backgroundColor: Colors.black,
        contentTextStyle: TextStyle(
            fontSize: 16, fontFamily: 'Roboto Medium', color: Color(0xFF868E9C)),
        titleTextStyle: TextStyle(
            fontSize: 20, fontFamily: 'Roboto Medium', color: Color(0xFF868E9C)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: new BorderSide(color: Color(0xFF272D3A)),
        ),
        actions: <Widget>[
          FlatButton(
            child: Center(
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Medium',
                  color: Colors.white,
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
