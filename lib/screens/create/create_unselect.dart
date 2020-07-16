import 'package:flutter/material.dart';

class CreateUnselect extends StatefulWidget {
  @override
  _CreateUnselectState createState() => _CreateUnselectState();
}

class _CreateUnselectState extends State<CreateUnselect> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
            ]),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Container(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigate_before,
                        size: 25,
                        color: Color(0xFF868E9C),
                      ),
                      Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto Medium',
                          color: Color(0xFF868E9C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          child: new Column(
            children: <Widget>[
              _simpleStack(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleStack() => Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height - 150.0,
        ),
        child: Stack(
          //fit: StackFit.expand,
          children: <Widget>[
            new ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.asset(
                'assets/images/pic17.jpg',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 65,
              margin: EdgeInsets.symmetric(vertical: 150),
              child: Center(
                child: new Text('One for you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto Black',
                        fontWeight: FontWeight.w900,
                        fontSize: 50.0,
                        color: Colors.white)),
              ),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 210),
              child: Center(
                child: new Text('... one for me',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto Black',
                        fontWeight: FontWeight.w900,
                        fontSize: 30.0,
                        color: Colors.white)),
              ),
            ),
            Container(
              height: 80,
              margin: EdgeInsets.fromLTRB(80, 240, 80, 0),
              child: Center(
                child: new Text(
                    'Here, we look at which people foods are also dog foods',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto Medium',
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      );
}
