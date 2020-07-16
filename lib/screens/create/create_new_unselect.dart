import 'package:flutter/material.dart';

class CreateNewUnselect extends StatefulWidget {
  @override
  _CreateNewUnselectState createState() => _CreateNewUnselectState();
}

class _CreateNewUnselectState extends State<CreateNewUnselect> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ]),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Container(
                color: Colors.black,
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            color: Colors.grey),
                      ),
                      Text(
                        "Done",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: new Column(
            children: <Widget>[
              _simpleStack(),
              Padding(
                padding: EdgeInsets.only(top: 70, left: 70, right: 70),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset('assets/images/pic21.jpg'),
                      ),
                    )),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset('assets/images/pic20.jpg'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          splashColor: Color(0xFF2B8DD8),
                          highlightColor: Color(0xFF2B8DD8),
                          child: Container(
                            height: 80,
                            width: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 25,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleStack() => Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 380.0,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.asset(
                'assets/images/pic20.jpg',
                scale: 0.6,
              ),
            ),
          ],
        ),
      );
}
