import 'package:flutter/material.dart';

class ViewStart extends StatefulWidget {
  @override
  _ViewStartState createState() => _ViewStartState();
}

class _ViewStartState extends State<ViewStart> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 5,
                    blurRadius: 2
                )]
            ),
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
                      Text("",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto Medium',
                          color: Color(0xFF868E9C),
                        ),
                      ),
                      Icon(Icons.close, size: 25, color: Color(0xFF868E9C),),
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

    constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height - 150.0,),
    child: Stack(
      //fit: StackFit.expand,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: 40,
              left: MediaQuery.of(context).size.width-22,
              right: 0,
              bottom: 0
          ),
          child: new ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                topLeft: Radius.circular(40)
            ),
            child: Image.asset(
              'assets/images/pic17.jpg',
              height: MediaQuery.of(context).size.height - 50,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 65,
          margin: EdgeInsets.only(
              top: 140,
              left: 30,
              right: 52,
              bottom: 0
          ),
          child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  'assets/images/pic6.jpg',
                  //fit: BoxFit.cover,
                ),
              ),
              title: new Text(
                  'One for you ... one for me',
                  style: TextStyle(
                    fontFamily: 'Roboto Medium',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: Color(0xFFFFFFFF),
                  )
              ),
              subtitle: new Text(
                  'rob_scott',
                  style: TextStyle(
                    fontFamily: 'Roboto Medium',
                    fontSize: 14.0,
                    color: Color(0xFF868E9C),
                  )
              ),

              onTap: () { /* react to the tile being tapped */ }
          )
        ),
        Container(
          height: 60,
          margin: EdgeInsets.only(
              top: 240,
              left: 30,
              right: 52,
              bottom: 0
          ),
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color(0xFF272D3A),
                        borderRadius: new BorderRadius.circular(15.0)
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        fontSize: 16,
                        color: Color(0xFF868E9C),
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'Filter by keyword',
                          prefixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 12.0),
                            child: IconTheme(
                              data: new IconThemeData(
                                  color: Color(0xFF868E9C)
                              ),
                              child: new Icon(Icons.search),
                            ), // myIcon is a 48px-wide widget.
                          ),
                          labelStyle: TextStyle(
                            fontFamily: 'Roboto Reqular',
                            fontSize: 17,
                            color: Color(0xFF868E9C),
                          )
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        Container(
          height: 20,
          margin: EdgeInsets.only(
              top: 320,
              left: 50,
              right: 22,
              bottom: 0
          ),
          child: new Text(
              '#allergy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto Medium',
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: Color(0xFF868E9C),
              )
          ),
        ),
        Container(
          height: 20,
          margin: EdgeInsets.only(
              top: 350,
              left: 50,
              right: 22,
              bottom: 0
          ),
          child: new Text(
              '#vegatables',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto Medium',
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: Color(0xFF868E9C),
              )
          ),
        ),
        Container(
          height: 20,
          margin: EdgeInsets.only(
              top: 380,
              left: 50,
              right: 22,
              bottom: 0
          ),
          child: new Text(
              '#meat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto Medium',
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                color: Color(0xFF868E9C),
              )
          ),
        ),
        Container(
          height: 20,
          margin: EdgeInsets.only(
              top: 410,
              left: 50,
              right: 22,
              bottom: 0
          ),
          child: new Text(
                '#herbs',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto Medium',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: Color(0xFF868E9C),
                )
            ),
        ),
      ],
    ),
  );
}