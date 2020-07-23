import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/firebase_services/activity_manager.dart';
import 'package:xenome/models/activityfeedmodel.dart';
import 'package:xenome/screens/view/search.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:xenome/screens/builder/builder_starter.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/screens/profile/others_profile.dart';
import 'package:xenome/screens/viewer/viewer_init.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/screens/profile/professional_sheet.dart';
import '../profile/my_profile.dart';
import '../view/home.dart';

class MyActivityFeed extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  MyActivityFeed({this.auth, this.loginCallback});

  @override
  _MyActivityFeedState createState() => _MyActivityFeedState();
}

class _MyActivityFeedState extends State<MyActivityFeed> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  String imageUrl = '';
  var activityList = [];
  var chkIFollowingUser = '';
  var differenceTime = '';
  List<ActivityFeedModel> _activityList = [];
  String id = "";

  @override
  void initState() {
    super.initState();
    imageUrl = SessionManager.getImage();

    getMeFollowingImages();
    getBuilderId();
  }

  getBuilderId() async {
    String _id = await ViewerManager.getBuilderId();
    setState(() {
      id = _id;
    });
  }

  String differentActivityTime(var dbtime) {
    DateTime lasttime = DateTime.parse(dbtime);
    DateTime now = DateTime.now();

    var difference = now.difference(lasttime).inSeconds;
    if (difference > 60 && difference < 3600) {
      difference = now.difference(lasttime).inMinutes;
      differenceTime = difference.toString() + "m";
    } else if (difference >= 3600 && difference < 86400) {
      difference = now.difference(lasttime).inHours;
      differenceTime = difference.toString() + "h";
    } else if (difference >= 86400) {
      difference = now.difference(lasttime).inDays;
      differenceTime = difference.toString() + "d";
    } else {
      differenceTime = difference.toString() + "s";
    }

    return differenceTime;
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

  getMeFollowingImages() async {
    _activityList = await ActivityManager.getActivityList();

    var tempActivityList = [];
    for (var i = _activityList.length - 1; i >= 0; i--) {
      var message = '';
      var messagePart = '';
      var checkFollowingUser =
          await ActivityManager.getFollowingList(_activityList[i].uid);

      if (checkFollowingUser != null) {
        if (_activityList[i].uid != SessionManager.getUserId()) {
          switch (_activityList[i].type) {
            case "newPageCreat":
              {
                message = "has added a new page to ";
                messagePart = "";
              }
              break;
            case "aPageCollect":
              {
                message = "has collected a page within ";
                messagePart = "";
              }
              break;
            case "aPageComment":
              {
                message = "has commented on a page within ";
                messagePart = "";
              }
              break;
            case "shareaPage":
              {
                message = "has shared a page within ";
                messagePart = "";
              }
              break;
            case "reply":
              {
                message = "replied to you on ";
                messagePart = "";
              }
              break;
            case "addMyList":
              {
                message = "has added ";
                messagePart = "to their list.";
              }
              break;
            default:
              {}
              break;
          }
          var _userName =
              await ActivityManager.getPostUserName(_activityList[i].uid);

          var _tempactivityList = [];

          _tempactivityList.add(_userName);
          _tempactivityList.add(_activityList[i].thumbnail);
          _tempactivityList.add(_activityList[i].content);
          _tempactivityList.add(_activityList[i].xmapName);
          _tempactivityList
              .add(differentActivityTime(_activityList[i].createdAt));
          _tempactivityList.add(message);
          _tempactivityList.add(messagePart);
          _tempactivityList.add(_activityList[i].uid);
          _tempactivityList.add(_activityList[i].xmapId);
          _tempactivityList.add(_activityList[i].xmapType);
          tempActivityList.add(_tempactivityList);
        }
      }
    }
    setState(() {
      activityList = tempActivityList;
      print("--------    you   ---------");
      print(activityList);
    });
  }

  void onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });

    switch (_currentIndex) {
      case 0:
        {
          Navigator.push(context, FadeRoute(page: Home()));
        }
        break;

      // case 1:
      //   {
      //     // Navigator.pushReplacement(
      //     //     context, MaterialPageRoute(builder: (context) => Search()));
      //   }
      //   break;

      case 1:
        {
          if (SessionManager.getPermission() == "premium" ||
              SessionManager.getPermission() == "trial") {
            Navigator.push(context,
                FadeRoute(page: BuilderStarter(id: id, type: "Buildder")));
          }

          if (SessionManager.getPermission() == "free" ||
              SessionManager.getPermission() == "Request") {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.6,
                    child: Container(
                      color: Color(0xFF737373),
                      height: 500,
                      child: Container(
                        child: ProfessionalSheet(),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                  );
                });
          }
        }
        break;

      case 2:
        {
          Navigator.push(context, FadeRoute(page: MyActivityFeed()));
        }
        break;

      case 3:
        {
          Navigator.push(context, FadeRoute(page: MyProfile()));
        }
        break;

      default:
        {
          Navigator.push(context, FadeRoute(page: Home()));
        }
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black87,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new GestureDetector(
                    child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: RichText(
                    text: TextSpan(
                      text: "Activity",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 55.0),
          child: ListView.builder(
            itemCount: activityList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: _buildActivityChild,
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Color(0xFF181C26),
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
                  width: 23,
                  height: 23,
                ),
                title: Container(),
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.search, size: 26),
              //   title: Container(),
              // ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icos/add_circle_outlined@3x.png',
                  width: 23,
                  height: 23,
                ),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icos/triangle@3x.png',
                  width: 23,
                  height: 23,
                ),
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
                    : CircleAvatar(
                        radius: 13,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (BuildContext context, String url) =>
                              Image.asset(
                            'assets/icos/loader.gif',
                            height: 13,
                            width: 13,
                            fit: BoxFit.cover,
                          ),
                          width: 13,
                          height: 13,
                          fit: BoxFit.fill,
                        ),
                        backgroundColor: Color(0xFF272D3A),
                      ),
                title: Container(),
              ),
            ],
          ),
        ));
  }

  Widget _buildActivityChild(BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                        child: Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 68,
                                width: 68,
                                padding: EdgeInsets.all(2),
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.black,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CachedNetworkImage(
                                      imageUrl: activityList[index][1],
                                      placeholder:
                                          (BuildContext context, String url) =>
                                              Image.asset(
                                        'assets/icos/loader.gif',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xffC26FED),
                                      Color(0xff5086DE)
                                    ]),
                                    borderRadius: BorderRadius.circular(34)))
                          ],
                        ),
                      ),
                    ))
                    // child: Padding(
                    //     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    //     child: ClipRRect(
                    //         child: CachedNetworkImage(
                    //  imageUrl:activityList[index][1],
                    //  placeholder: (BuildContext context, String url) =>
                    //     Image.asset(
                    //       'assets/icos/loader.gif',
                    //       height: 64,
                    //       width: 64,
                    //       fit: BoxFit.cover,
                    //     ),
                    //             height: 64, width: 64, fit: BoxFit.cover))),
                    ),
                Expanded(
                  flex: 6,
                  child: activityList[index][6] == ''
                      ? RichText(
                          text: new TextSpan(
                            text: activityList[index][0],
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                    return OthersProfile(
                                      uid: activityList[index][7],
                                    );
                                  })),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' ' + activityList[index][5],
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF868E9C))),
                              TextSpan(
                                  text: ' ' + activityList[index][3],
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).push(
                                            MaterialPageRoute<Null>(builder:
                                                (BuildContext context) {
                                          return ViewerInit(
                                              id: activityList[index][8],
                                              type: activityList[index][9]);
                                        })),
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF868E9C))),
                              TextSpan(
                                  text: ' ' + activityList[index][4],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF868E9C))),
                            ],
                          ),
                        )
                      : RichText(
                          text: new TextSpan(
                            text: activityList[index][0],
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                    return OthersProfile(
                                      uid: activityList[index][7],
                                    );
                                  })),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' ' + activityList[index][5],
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF868E9C))),
                              TextSpan(
                                  text: ' ' + activityList[index][3],
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).push(
                                            MaterialPageRoute<Null>(builder:
                                                (BuildContext context) {
                                          return ViewerInit(
                                              id: activityList[index][8],
                                              type: activityList[index][9]);
                                        })),
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF868E9C))),
                              TextSpan(
                                  text: ' ' + activityList[index][6],
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF868E9C))),
                              TextSpan(
                                  text: ' ' + activityList[index][4],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF868E9C))),
                            ],
                          ),
                        ),
                ),
              ]),
        ));
  }
}
