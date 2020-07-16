import 'package:flutter/material.dart';
import 'package:xenome/screens/create/create_location.dart';
import 'package:xenome/screens/view/home.dart';

class CreateDistribution extends StatefulWidget {
  @override
  _CreateDistributionState createState() => _CreateDistributionState();
}

class _CreateDistributionState extends State<CreateDistribution> {
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
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                        '32 selected',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto Medium',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateDistribution()),
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto Medium',
                            color: Color(0xFF868E9C),
                          ),
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
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 0, right: 0),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  height: 0.5,
                  color: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                              child: Text('Invite by email',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                            ),
                          ],
                        ),
                        flex: 7,
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: IconTheme(
                            data: new IconThemeData(color: Color(0xFF868E9C)),
                            child: new IconButton(
                                icon: Icon(Icons.arrow_forward_ios,
                                    size: 18, color: Color(0xFF868E9C)),
                                onPressed: () {
                                  //                              Navigator.push(
                                  //                                context,
                                  //                                MaterialPageRoute(builder: (_) => Search()),
                                  //                              );
                                }),
                          ), // myIcon is a 48px-wide widget.
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
                  height: 0.5,
                  color: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                        child: Text('Previous lists',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                //onPressed: validateAndSubmit,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'Support the farmers',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Roboto Medium',
                                        color: Color(0xFF868E9C),
                                      ),
                                    )
                                  ],
                                ),
                                elevation: 0,
                                minWidth: 70,
                                height: 40,
                                textColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Color(0xFF181C26))),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: MaterialButton(
                                //onPressed: validateAndSubmit,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'The health benefits of a ketoge...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Roboto Medium',
                                        color: Color(0xFF868E9C),
                                      ),
                                    )
                                  ],
                                ),
                                elevation: 0,
                                minWidth: 80,
                                height: 40,
                                textColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Color(0xFF181C26))),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
                  height: 0.5,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
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
                            padding:
                                const EdgeInsetsDirectional.only(start: 12.0),
                            child: IconTheme(
                              data: new IconThemeData(color: Color(0xFF868E9C)),
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
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic2.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('amanda_daniels',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Amanda Daniels - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic3.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('amy_lee',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Ammy Lee - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic4.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('pablo Ortega',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Pablo Ortega - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic5.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('alicia_gingleton',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Alicia Gingleton - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic6.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('jane_green',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Jane Greeen - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic2.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('amanda_daniels',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Amanda Daniels - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic3.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('amy_lee',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Ammy Lee - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic4.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('pablo Ortega',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Pablo Ortega - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic5.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('alicia_gingleton',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Alicia Gingleton - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ClipOval(
                            child: Container(
                          child: Image.asset(
                            'assets/images/pic6.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )),
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLocation()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                                child: Text('jane_green',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text('Jane Greeen - following',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.grey,
                                    fontSize: 13,
                                  )),
                            ),
                          ],
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0.0),
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlue,
                            activeColor: Colors.white,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
