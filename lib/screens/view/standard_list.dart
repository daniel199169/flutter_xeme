import 'package:flutter/material.dart';

class StandardList extends StatefulWidget {
  @override
  _StandardListState createState() => _StandardListState();
}

class _StandardListState extends State<StandardList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

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
                  margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigate_before,
                        size: 30,
                        color: Colors.white,
                      ),
                      Text(
                        "#thefutureofsocial",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.navigate_before,
                        color: Colors.transparent,
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
          child: GridView.count(
              padding: const EdgeInsets.all(15),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              children: _buildGridTileList(30)),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Image.asset(
                    'assets/icos/carousel_horizontal_outlined@3x.png',
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icos/search@3x.png',
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icos/add_circle_outlined@3x.png',
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icos/triangle_outlined@3x.png',
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                  },
                ),
                IconButton(
                  icon: ClipOval(
                      child: Container(
                    child: Image.asset(
                      'assets/images/pic6.jpg',
                      //width: 50,
                      //height: 50,
                      fit: BoxFit.cover,
                    ),
                  )),
                  onPressed: () {
                  },
                ),
              ]),
          color: Colors.black87,
        )),
      ),
    );
  }

  // The images are saved with names pic0.jpg, pic1.jpg...pic29.jpg.
  // The List.generate() constructor allows an easy way to screens.create
  // a list when objects have a predictable naming pattern.
  List<Container> _buildGridTileList(int count) => List.generate(
        count,
        (i) => Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/pic$i.jpg',
            ),
          ),
        ),
      ); // #enddocregion grid

// #enddocregion list
}
