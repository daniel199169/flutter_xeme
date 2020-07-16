import 'package:flutter/material.dart';
import 'package:xenome/screens/view/home.dart';

class CreateLocation extends StatefulWidget {
  @override
  _CreateLocationState createState() => _CreateLocationState();
}

class _CreateLocationState extends State<CreateLocation> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                  margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new IconButton(
                          icon: Icon(Icons.navigate_before,
                              size: 25, color: Color(0xFF868E9C)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Home()),
                            );
                          }),
                      Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto Medium',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      new IconButton(
                          icon: Icon(Icons.gps_not_fixed,
                              size: 25, color: Color(0xFF868E9C)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Home()),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 0, left: 0, right: 0),
            child: ListView(
              children: <Widget>[
                Form(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Color(0xFF272D3A),
                              borderRadius: new BorderRadius.circular(15.0)),
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
                                labelText: 'Search for a person',
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: IconTheme(
                                    data: new IconThemeData(
                                        color: Color(0xFF868E9C)),
                                    child: new Icon(Icons.search),
                                  ), // myIcon is a 48px-wide widget.
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'Roboto Reqular',
                                  fontSize: 16,
                                  color: Color(0xFF868E9C),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bills Bondi',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text(
                            '79 Hall Street Bondi Beach NSW 2026, Sydney, Australia ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Gertrude & Alice Cafe Bookstore',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child:
                            Text('46 Hall St, Bondi Beach, Sydney, Australia',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  fontSize: 13,
                                )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bills Bondi',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text(
                            '79 Hall Street Bondi Beach NSW 2026, Sydney, Australia ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Gertrude & Alice Cafe Bookstore',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child:
                            Text('46 Hall St, Bondi Beach, Sydney, Australia',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  fontSize: 13,
                                )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bills Bondi',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text(
                            '79 Hall Street Bondi Beach NSW 2026, Sydney, Australia ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Gertrude & Alice Cafe Bookstore',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child:
                            Text('46 Hall St, Bondi Beach, Sydney, Australia',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  fontSize: 13,
                                )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text('Bondi Beach',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Bills Bondi',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child: Text(
                            '79 Hall Street Bondi Beach NSW 2026, Sydney, Australia ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Gertrude & Alice Cafe Bookstore',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                        child:
                            Text('46 Hall St, Bondi Beach, Sydney, Australia',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  fontSize: 13,
                                )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
