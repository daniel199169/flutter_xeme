import 'package:flutter/material.dart';

class TitleSentence extends StatelessWidget {
  final leftSection = new Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(color: Color(0xFF2B8DD8)),
    ),
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Text(
        ' X ',
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto'),
      ),
    ),
  );

  final rightSection = new Container(
    child: Text(
      '  E   N   O   M   E ',
      style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Roboto'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(40, 16, 40, 6),
      margin: EdgeInsets.only(top: 40),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[leftSection, rightSection],
      ),
    );
  }
}
