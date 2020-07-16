import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/firebase_services/follow_status.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:xenome/screens/profile/others_profile.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/view/home.dart';

class FollowingStatus extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final String uid;
  final String wheretype;
  FollowingStatus({this.auth, this.loginCallback, this.uid, this.wheretype});

  @override
  _FollowingStatusState createState() => _FollowingStatusState();
}

class _FollowingStatusState extends State<FollowingStatus> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var followingList = [];
  var followerList = [];

  @override
  void initState() {
    super.initState();
    getFollowingList();
    getFollowerList();
  }

  getFollowingList() async {
    var _followingUserList =
        await FollowStatusManager.getFollowingList(widget.uid);

    var tempFollowingList = [];
    for (var i = _followingUserList.length - 1; i >= 0; i--) {
      var _tempDataList = [];
      String _userName =
          await FollowStatusManager.getUserName(_followingUserList[i]);
      String _userImage =
          await FollowStatusManager.getUserImage(_followingUserList[i]);
      _tempDataList.add(_userImage);
      _tempDataList.add(_userName);
      tempFollowingList.add(_tempDataList);
    }
    setState(() {
      followingList = tempFollowingList;
    });
  }

  getFollowerList() async {
    var _followerUserList =
        await FollowStatusManager.getFollowerList(widget.uid);

    var tempFollowerList = [];
    for (var i = _followerUserList.length - 1; i >= 0; i--) {
      var _tempDataList = [];

      String _userName =
          await FollowStatusManager.getUserName(_followerUserList[i]);

      String _userImage =
          await FollowStatusManager.getUserImage(_followerUserList[i]);

      _tempDataList.add(_userImage);
      _tempDataList.add(_userName);
      tempFollowerList.add(_tempDataList);
    }

    setState(() {
      followerList = tempFollowerList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Container(
              margin: EdgeInsets.only(left: 20),
              child: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (widget.wheretype == 'MyProfile') {
                      Navigator.push(context, FadeRoute(page: MyProfile()));
                    } else {
                      Navigator.push(context,
                          FadeRoute(page: OthersProfile(uid: widget.uid)));
                    }
                  }),
            ),
//            title: const Text('Follow'),
//            actions: <Widget>[
//              Container(
//                margin: EdgeInsets.only(right: 20),
//              child: GestureDetector(
//                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (_) => MyProfile()),
//                    );
//                  },
//                  child: Icon(
//                    Icons.close,
//                    color: Colors.white,
//                    size: 20.0,
//                  ),
//              ),
//              )
//            ],
            bottom: TabBar(
              tabs: <Widget>[
                Text(
                  'Follower',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto Medium',
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                Text(
                  'Following',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto Medium',
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black,
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 25.0, 0.0, 55.0),
                child: ListView.builder(
                  itemCount: followerList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: _buildFollowerListChild,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 25.0, 0.0, 55.0),
                child: ListView.builder(
                  itemCount: followingList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: _buildFollowingListChild,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFollowingListChild(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(children: <Widget>[
            ClipOval(
                child: Container(
              child: CachedNetworkImage(
                imageUrl: followingList[index][0],
                placeholder: (BuildContext context, String url) => Image.asset(
                  'assets/icos/loader.gif',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )),
          ]),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
////                          builder: (_) => CreateLocation()),
//                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                    child: Text(followingList[index][1],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                  child: Text(followingList[index][1] + ' - following',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey,
                        fontSize: 13,
                      )),
                ),
              ],
            ),
            flex: 7,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerListChild(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(children: <Widget>[
            ClipOval(
              child: Container(
                child: CachedNetworkImage(
                  imageUrl: followerList[index][0],
                  placeholder: (BuildContext context, String url) =>
                      Image.asset(
                    'assets/icos/loader.gif',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ]),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new GestureDetector(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
////                          builder: (_) => CreateLocation()),
//                        ));
//                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
                    child: Text(followerList[index][1],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                  child: Text(followerList[index][1] + ' - follower',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey,
                        fontSize: 13,
                      )),
                ),
              ],
            ),
            flex: 7,
          ),
        ],
      ),
    );
  }
}
