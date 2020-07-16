import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/builder/builder_starter.dart';
import 'package:xenome/screens/create/create_start_drawer.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatefulWidget {
  Search({this.auth, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _currentIndex = 1;
  String imageUrl = '';
  String id = "";

  @override
  void initState() {
    imageUrl = SessionManager.getImage();
    super.initState();
    getBuilderId();
  }

  getBuilderId() async {
    String _id = await ViewerManager.getBuilderId();
    setState(() {
      id = _id;
    });
  }

  signOut() async {
    try {
      SessionManager.handleClearAllSettging();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginCheck()),
      );
    } catch (e) {
      print(e);
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (_currentIndex) {
      case 0:
        {
          Navigator.push(context, FadeRoute(page: Home()));
        }
        break;

      case 1:
        {
          Navigator.push(context, FadeRoute(page: Search()));
        }
        break;

      case 2:
        {
          Navigator.push(context,
              FadeRoute(page: BuilderStarter(id: id, type: "Buildder")));
        }
        break;

      case 3:
        {
          signOut();
        }
        break;

      case 4:
        {
          Navigator.push(context, FadeRoute(page: MyProfile()));
        }
        break;

      default:
        {
          Navigator.push(context, FadeRoute(page: Search()));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          color: Colors.black,
          child: new Column(
            children: <Widget>[
              _simpleStack(),
            ],
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Color(0xFF272D3A),
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Color(0xFF868E9C)))),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 26),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, size: 26),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.change_history, size: 26),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: imageUrl !=
                        'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                    ? ClipOval(
                        child: Container(
                            child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        Image.asset(
                                          'assets/icos/loader.gif',
                                          height: 23,
                                          width: 23,
                                          fit: BoxFit.cover,
                                        ),
                                width: 23,
                                height: 23,
                                fit: BoxFit.cover)))
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              height: 23,
                              width: 23,
                              fit: BoxFit.cover,
                            ),
                        width: 23,
                        height: 23,
                        fit: BoxFit.cover),
                title: Container(),
              ),
            ],
          ),
        ));
  }

  Widget _simpleStack() => Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 180.0,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 40, 30, 10),
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
                            labelText: 'Search Xmaps and people',
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 12.0),
                              child: IconTheme(
                                data:
                                    new IconThemeData(color: Color(0xFF868E9C)),
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
          ],
        ),
      );
}
