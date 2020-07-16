import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/auth_manager.dart';
import 'package:xenome/screens/create/create_start_drawer.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/screens/view/search.dart';
import 'package:xenome/verification/login_check.dart';


class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class CustomListItemTwo extends StatelessWidget {

  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/pic6.jpg',
                  //fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 35.0, 0.0, 0.0),
                child: Text(
                    'rob_scott',
                    style: TextStyle(
                      fontFamily: 'Roboto Medium',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(55.0, 20.0, 0.0, 0.0),
                child: IconTheme(
                  data: new IconThemeData(
                      color: Color(0xFF868E9C)
                  ),
                  child: new IconButton(
                      icon: Icon(Icons.menu, size: 25, color: Color(0xFF868E9C)),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Search()),
                        );
                      }
                  ),
                ), // myIcon is a 48px-wide widget.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyProfileState extends State<MyProfile> {
  int _currentIndex = 3;

  void onTabTapped(int index) {
    setState(() {
     
      _currentIndex = index;
    });

    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      switch (_currentIndex) {
        case 0:
          {
            return Home();
          }
          break;

        // case 1:
        //   {
        //     return Search();
        //   }
        //   break;

        case 1:
          {
            return CreateStartLayout();
          }
          break;

        case 2:
          {
            AuthManager.logOut().then((res) {
              //SessionManager.hasLoggedOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginCheck()));
            }).catchError((error) {
              print(error);
            });
          }
          break;

        case 3:
          {
            return MyProfile();
          }
          break;

        default:
          {
            return Home();
          }
      }

    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Colors.black87,
        child: new Column(
          children: <Widget>[
            CustomListItemTwo(
              thumbnail: Container(
                decoration: const BoxDecoration(color: Colors.pink),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
        canvasColor: Color(0xFF272D3A),
        primaryColor: Colors.white,
        textTheme: Theme.of(context).textTheme.copyWith(
        caption: TextStyle(color:Color(0xFF868E9C))
        )
        ),
        child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFFFFFFF),
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
                'assets/icos/carousel_horizontal_outlined@3x.png',
              ),
            title: Container(),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search, size: 26),
          //   title: Container(),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 26),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_history, size: 26),
            title: Container(child: Text('Logout'),),
          ),
          BottomNavigationBarItem(
            icon: ClipOval(
              child: Container(
                child: Image.asset(
                  'assets/images/pic6.jpg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              )
            ),
            title: Container(),
          ),
        ],
      ),
    )
    );
  }


}
