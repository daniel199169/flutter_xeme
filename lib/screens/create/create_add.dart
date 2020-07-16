import 'package:flutter/material.dart';

class CreateAdd extends StatefulWidget {
  @override
  _CreateAddState createState() => _CreateAddState();
}

class _CreateAddState extends State<CreateAdd> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Colors.black87,
        child: new Column(
          children: <Widget>[
            _simpleStack(),
          ],
        ),
      ),
    );
  }

  Widget _simpleStack() => Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 480.0,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 280, 50, 10),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          IconTheme(
                            data: new IconThemeData(color: Color(0xFF868E9C)),
                            child: new Icon(Icons.description),
                          ),
                          Text(
                            '  Standard',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto Medium',
                              color: Color(0xFF868E9C),
                            ),
                          )
                        ],
                      ),
                      elevation: 0,
                      minWidth: 350,
                      height: 60,
                      textColor: Color(0xFF868E9C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Color(0xFF181C26))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
