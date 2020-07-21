import 'dart:io';
import "dart:ui" as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xenome/firebase_services/feature_manager.dart';
import 'package:xenome/firebase_services/follow_manager.dart';
import 'package:xenome/firebase_services/mylist_manager.dart';
import 'package:xenome/firebase_services/again_manager.dart';
import 'package:xenome/firebase_services/build_manager.dart';
import 'package:xenome/firebase_services/recommended_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/firebase_services/viewing_manager.dart';
import 'package:xenome/models/again.dart';
import 'package:xenome/models/mylist.dart';
import 'package:xenome/models/recommended.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/models/styled_text.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/viewing.dart';
import 'package:xenome/models/xmap_all.dart';
import 'package:xenome/screens/builder/builder_starter.dart';
import 'package:xenome/screens/profile/others_profile.dart';
import 'package:xenome/screens/view/search.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:xenome/screens/view_info/view_info_creator.dart';
import 'package:xenome/screens/view_xmap/xmap_init.dart';
import 'package:xenome/screens/viewer/viewer_init.dart';
import 'package:xenome/screens/viewer/SplashScreen.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/utils/string_helper.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/screens/viewer/myactivityfeed.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';
import 'package:xenome/screens/base_widgets/custom_show_dialog.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/screens/profile/professional_sheet.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String _flagAddMyList = '';

  String topImageUrl = '';
  String topXmapID = "";

  String imageUrl = '';
  String title = "Title";
  String subtitle = "Subtitle";
  String uid = "";
  String id = "";
  SetupInfo xmapTitle;
  CoverImageModel sendCoverImage;
  var topXmapInfo = [];
  var titleList = [];
  var subTitleList = [];
  var followingUsers = [];
  var followingImages = [];
  var followingNames = [];
  var followingCounts = [];
  var followingWebsites = [];
  var updateStatus = [];
  double yPosition = 0.01;

  List<Viewing> itemsViewing = [];
  List<Trending> itemsTrending = [];
  List<Trending> itemsInviting = [];
  List<Mylist> itemsMylist = [];
  List<Recommended> items = [];
  List<Again> itemsAgain = [];

  getXmapInfo() async {
    var _topXmapInfo = await TrendingManager.getTopXmapInfo();

    setState(() {
      topImageUrl = _topXmapInfo[0];
      topXmapID = _topXmapInfo[1];
    });
    getAddMyListStatus();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    SessionManager.setMediaWidth(screenWidth);
    SessionManager.setMediaHeight(screenHeight);
  }

  getTopXmapTitle() async {
    var _topXmapInfo = await TrendingManager.getTopXmapInfo();

    SetupInfo _xmapTitle =
        await ViewerManager.getSetupInfo(_topXmapInfo[1], "Trending");
    setState(() {
      xmapTitle = _xmapTitle;
    });
  }

  getFollowingUsers() async {
    var _followingUsers = await FollowManager.getFollowingList();

    setState(() {
      followingUsers = _followingUsers;
    });
    var _updateStatus = [];

    for (int i = 0; i < followingUsers.length; i++) {
      String temp = await FollowManager.getUpdateState(followingUsers[i]);

      _updateStatus.add(temp);
    }

    setState(() {
      updateStatus = _updateStatus;
    });
  }

  getFollowingImages() async {
    var _followingUsers = await FollowManager.getFollowingList();

    var _followingImages = [];

    for (var i = 0; i < _followingUsers.length; i++) {
      _followingImages
          .add(await FollowManager.getFollowingImage(_followingUsers[i]));
    }
    setState(() {
      followingImages = _followingImages;
    });
  }

  getFollowingNames() async {
    var _followingUsers = await FollowManager.getFollowingList();
    var _followingNames = [];

    for (var i = 0; i < _followingUsers.length; i++) {
      _followingNames
          .add(await FollowManager.getFollowingName(_followingUsers[i]));
    }
    setState(() {
      followingNames = _followingNames;
    });
  }

  getWebsites() async {
    var _followingUsers = await FollowManager.getFollowingList();
    var _followingWebsites = [];

    for (var i = 0; i < _followingUsers.length; i++) {
      _followingWebsites
          .add(await FollowManager.getFollowingWebsite(_followingUsers[i]));
    }
    setState(() {
      followingWebsites = _followingWebsites;
    });
  }

  // getPositionList() async {
  //   List<double> _positionList = await BuildManager.getPositionList(uid);
  //   setState(() {
  //     yPosition = _positionList[1];
  //   });
  // }

  // Future getImage() async {
  //   String filePath = await BuildManager.getImage(uid);
  //   List<String> realPath = filePath.split("File: '");
  //   File image =
  //       await getFile(realPath[1].substring(0, realPath[1].length - 1));
  //   setState(() {
  //     _image = image;
  //   });
  // }

  // Future<File> getFile(String path) async {
  //   return File(path);
  // }

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

  @override
  void initState() {
    super.initState();

    imageUrl = SessionManager.getImage();
    uid = SessionManager.getUserId();
    yPosition = 0.0;

    xmapTitle = new SetupInfo(title: '', description: '');

    getXmapInfo();
    getTopXmapTitle();
    // getPositionList();
    // getImage();
    getFollowingUsers();
    getFollowingImages();
    getFollowingNames();
    getWebsites();

    getViewingList();
    getRecommendedList();
    getRecentInvitedList();
    getTrendingList();
    getMylistList();
    getAgainList();
  }

  getBuilderId() async {
    String _id = await ViewerManager.getBuilderId();

    setState(() {
      id = _id;
    });
    Navigator.push(
        context, FadeRoute(page: BuilderStarter(id: id, type: "Buildder")));
  }

  getAddMyListStatus() async {
    String _flagStatus = await MylistManager.getAddMyListStatus(topXmapID);
    setState(() {
      _flagAddMyList = _flagStatus;
    });
  }

  getViewingList() async {
    var _itemsViewing = await ViewingManager.getList();
    setState(() {
      itemsViewing = _itemsViewing;
    });
  }

  getRecommendedList() async {
    var _items = await RecommendedManager.getList();
    setState(() {
      items = _items;
    });
  }

  getTrendingList() async {
    var _itemsTrending = await TrendingManager.getList();
    setState(() {
      itemsTrending = _itemsTrending;
    });
  }

  getRecentInvitedList() async {
    var _itemsInviting = await TrendingManager.getInvitedList();
    setState(() {
      itemsInviting = _itemsInviting;
    });
  }

  getMylistList() async {
    var _itemsMylist = await MylistManager.getList(uid);
    setState(() {
      itemsMylist = _itemsMylist;
    });
  }

  getAgainList() async {
    var _itemsAgain = await AgainManager.getList();
    setState(() {
      itemsAgain = _itemsAgain;
    });
  }

  addMyList() async {
    await MylistManager.add(topXmapID, "Trending");
    var _itemsMylist = await MylistManager.getList(uid);
    setState(() {
      itemsMylist = _itemsMylist;
      _flagAddMyList = "Exist";
    });
  }

  removeMyList() async {
    await MylistManager.remove(topXmapID, "Mylist");
    var _itemsMylist = await MylistManager.getList(uid);
    setState(() {
      itemsMylist = _itemsMylist;
      _flagAddMyList = "Not exist";
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
      //      Navigator.pushReplacement(
      //          context, MaterialPageRoute(builder: (context) => Search()));
      //   }
      //   break;

      case 1:
        {
          if (SessionManager.getPermission() == "premium" ||
              SessionManager.getPermission() == "trial") {
            getBuilderId();
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, //top bar color
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return new Scaffold(
      // extendBodyBehindAppBar: true,

      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: MediaQuery.of(context).size.height * 0.7,
            leading: Text(''),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _simpleStack(),
            ),
            floating: false,
            pinned: true,
            snap: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                itemsViewing.length != 0
                    ? Container(
                        child: Stack(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 15.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'CONTINUE VIEWING',
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                        ),
                        new Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 15.0),
                          constraints: const BoxConstraints(maxHeight: 255.0),
                          child: new ListView.builder(
                            itemCount: itemsViewing.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: _buildViewingChild,
                          ),
                        ),
                      ]))
                    : Container(),
                itemsInviting.length != 0
                    ? Container(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 25.0, 0.0, 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'RECENTLY INVITED',
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 60.0, 0.0, 15.0),
                              constraints:
                                  const BoxConstraints(maxHeight: 235.0),
                              child: new ListView.builder(
                                itemCount: itemsInviting.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: _buildInvitingChild,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),

                itemsTrending.length != 0
                    ? Container(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 35.0, 0.0, 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'TRENDING NOW',
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 70.0, 0.0, 15.0),
                              constraints:
                                  const BoxConstraints(maxHeight: 235.0),
                              child: new ListView.builder(
                                itemCount: itemsTrending.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: _buildTrendingChild,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),

                followingUsers.length != 0
                    ? Container(
                        child: Stack(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 0.0),
                          child: RichText(
                            text: TextSpan(
                              text: "FOLLOWING (" +
                                  followingUsers.length.toString() +
                                  ")",
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                          constraints: const BoxConstraints(maxHeight: 160.0),
                          child: new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: _buildFollowingChild,
                          ),
                        ),
                      ]))
                    : Container(),

                itemsMylist.length != 0
                    ? Container(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'MY LIST',
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 50.0, 0.0, 15.0),
                              constraints:
                                  const BoxConstraints(maxHeight: 235.0),
                              child: new ListView.builder(
                                itemCount: itemsMylist.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: _buildMylistChild,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                // items.length != 0
                //     ? Container(
                //         child: Stack(
                //           children: <Widget>[
                //             Padding(
                //               padding:
                //                   EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
                //               child: RichText(
                //                 text: TextSpan(
                //                   text: 'RECOMMENDED',
                //                   style: Theme.of(context).textTheme.subtitle,
                //                 ),
                //               ),
                //             ),
                //             Container(
                //               padding: const EdgeInsets.fromLTRB(
                //                   0.0, 50.0, 0.0, 15.0),
                //               constraints:
                //                   const BoxConstraints(maxHeight: 235.0),
                //               child: new ListView.builder(
                //                 itemCount: items.length,
                //                 itemBuilder: _buildRecommendedChild,
                //                 scrollDirection: Axis.horizontal,
                //               ),
                //             )
                //           ],
                //         ),
                //       )
                //     : Container(),
                // itemsAgain.length != 0
                //     ? Container(
                //         child: Stack(
                //           children: <Widget>[
                //             Padding(
                //               padding:
                //                   EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
                //               child: RichText(
                //                 text: TextSpan(
                //                   text: 'VIEW AGAIN',
                //                   style: Theme.of(context).textTheme.subtitle,
                //                 ),
                //               ),
                //             ),
                //             Container(
                //               padding: const EdgeInsets.fromLTRB(
                //                   0.0, 50.0, 0.0, 35.0),
                //               constraints:
                //                   const BoxConstraints(maxHeight: 255.0),
                //               child: new ListView.builder(
                //                 itemCount: itemsAgain.length,
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder: _buildAgainChild,
                //               ),
                //             )
                //           ],
                //         ),
                //       )
                //     : Container(),
                Container(
                  alignment: Alignment(-0.8, 0.92),
                  padding: EdgeInsets.only(
                    left: 30,
                    top: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
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
                'assets/icos/carousel_horizontal@3x.png',
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
                'assets/icos/triangle_outlined@3x.png',
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
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                    'assets/icos/loader.gif',
                                    width: 23,
                                    height: 23,
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
      ),
    );
  }

  Widget _simpleStack() => Stack(
        children: <Widget>[
          new ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            child: CachedNetworkImage(
              imageUrl: topImageUrl,
              placeholder: (BuildContext context, String url) => Image.asset(
                'assets/icos/loader.gif',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),

          // Container(
          //   height: 100,
          //   margin:
          //       EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          //   child: Center(
          //     child: new Text(xmapTitle.title != null ? xmapTitle.title : "...",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             fontFamily: 'Roboto Black',
          //             fontWeight: FontWeight.w900,
          //             fontSize: 46,
          //             color: Colors.white)),
          //   ),
          // ),
          // Container(
          //   height: 40,
          //   margin:
          //       EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.23),
          //   child: Center(
          //     child: new Text(
          //         xmapTitle.description != null ? xmapTitle.description : "...",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             fontFamily: 'Roboto Black',
          //             fontWeight: FontWeight.w600,
          //             fontSize: 32,
          //             color: Colors.white)),
          //   ),
          // ),
          Container(
            alignment: Alignment(0.8, 0.9),
            padding: EdgeInsets.only(top: 0, right: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    FadeRoute(page: XmapInit(id: topXmapID, type: "Trending")));
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                radius: 28.0,
                child: Icon(Icons.arrow_forward),
              ),
            ),
            // FloatingActionButton(
            //   backgroundColor: Colors.white,
            //   foregroundColor: Colors.black,
            //   child: Icon(Icons.arrow_forward),
            //   onPressed: () {
            //     Navigator.push(context,
            //         FadeRoute(page: XmapInit(id: topXmapID, type: "Trending")));

            //   },
            // ),
          ),
          Container(
            alignment: Alignment(-0.8, 0.92),
            padding: EdgeInsets.only(
                left: 40,
                top: 0,
                right: MediaQuery.of(context).size.width - 140),
            child: MaterialButton(
              onPressed: () async {
                if (_flagAddMyList == "Not exist") {
                  addMyList();
                } else {
                  removeMyList();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconTheme(
                    data: new IconThemeData(color: Color(0xFF868E9C)),
                    child: _flagAddMyList == "Not exist"
                        ? new Icon(Icons.add)
                        : new Icon(Icons.remove),
                  ),
                  Text(
                    'My list',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: Color(0xFF868E9C)),
                  )
                ],
              ),
              color: Colors.black87,
              padding: EdgeInsets.all(0),
              elevation: 0,
              minWidth: 60,
              height: 45,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            ),
          ),
          Container(
            alignment: Alignment(-0.8, 0.92),
            padding: EdgeInsets.only(
                left: 150,
                top: 0,
                right: MediaQuery.of(context).size.width - 230),
            child: MaterialButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    FadeRoute(
                        page:
                            ViewInfoCreator(id: topXmapID, type: "Trending")));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconTheme(
                    data: new IconThemeData(color: Color(0xFF868E9C)),
                    child: new Icon(Icons.info_outline),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(
                      'Info',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: Color(0xFF868E9C),
                      ),
                    ),
                  )
                ],
              ),
              color: Colors.black87,
              padding: EdgeInsets.all(0),
              elevation: 0,
              minWidth: 45,
              height: 45,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            ),
          ),
        ],
      );

  Widget _buildFollowingChild(BuildContext context, int index) {
    index++;
    if (index > followingUsers.length) return null;
    if (followingImages.length == 0 || followingNames.length == 0) return null;

    return new Padding(
      padding: index == 1
          ? const EdgeInsets.only(right: 10.0, left: 30)
          : const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              FadeRoute(
                  page: OthersProfile(
                uid: followingUsers[index - 1],
              )));
        },
        child: Column(
          children: <Widget>[
            followingImages[index - 1] !=
                    'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                ? Container(
                    height: 68,
                    width: 68,
                    padding: EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: followingImages[index - 1],
                          placeholder: (BuildContext context, String url) =>
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
                    decoration: updateStatus.length > 0
                        ? updateStatus[index - 1] == "updated"
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Color(0xffC26FED), Color(0xff5086DE)]),
                                borderRadius: BorderRadius.circular(34))
                            : BoxDecoration()
                        : BoxDecoration(),
                  )
                : new CircleAvatar(
                    radius: 34,
                    child: CachedNetworkImage(
                      imageUrl: followingImages[index - 1],
                      placeholder: (BuildContext context, String url) =>
                          Image.asset(
                        'assets/icos/loader.gif',
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                      ),
                      width: 34,
                      height: 34,
                      fit: BoxFit.fill,
                    ),
                    backgroundColor: Color(0xFF272D3A),
                  ),
            SizedBox(
              height: 7.0,
            ),
            Text(
              followingNames[index - 1],
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewingChild(BuildContext context, int index) {
    final itemViewing = itemsViewing[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            FadeRoute(page: ViewerInit(id: itemViewing.id, type: "Viewing")));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: itemViewing.image != null
                        ? CachedNetworkImage(
                            imageUrl: itemViewing.image.imageURL,
                            placeholder: (BuildContext context, String url) =>
                                Image.asset(
                                  'assets/icos/loader.gif',
                                  width: 115,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                            width: 115,
                            height: 170,
                            fit: BoxFit.cover)
                        : Image.asset('assets/images/pic17.jpg',
                            height: 170, width: 115, fit: BoxFit.cover),
                  ),
                  // Center(
                  //   child: Container(
                  //     padding: EdgeInsets.only(top: 40),
                  //     width: 115,
                  //     child: Column(
                  //       children: <Widget>[
                  //         AutoSizeText(
                  //           itemViewing.title.title != null
                  //               ? itemViewing.title.title
                  //               : "...",
                  //           style: TextStyle(
                  //               fontFamily: 'Roboto Black',
                  //               fontWeight: FontWeight.w900,
                  //               fontSize: 14,
                  //               color: Colors.white),
                  //           minFontSize: 12,
                  //           maxLines: 4,
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         Text(
                  //           itemViewing.title.description != null
                  //               ? itemViewing.title.description
                  //               : "...",
                  //           style: TextStyle(
                  //               fontFamily: 'Roboto Black',
                  //               fontWeight: FontWeight.w900,
                  //               fontSize: 14,
                  //               color: Colors.white),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
              // child: LinearPercentIndicator(
              //   width: 100.0,
              //   lineHeight: 4.0,
              //   percent: 0.9,
              //   progressColor: Color(0xFF2B8DD8),
              // ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingChild(BuildContext context, int index) {
    final itemTrending = itemsTrending[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            FadeRoute(page: ViewerInit(id: itemTrending.id, type: "Trending")));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Center(
          child: Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: itemTrending.image != null
                    ? CachedNetworkImage(
                        imageUrl: itemTrending.image.imageURL,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              width: 115,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                        width: 115,
                        height: 170,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 170, width: 115, fit: BoxFit.cover),
              ),
              //TemplateThumbnail(description(context), position),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: 40),
              //     width: 115,
              //     child: Column(
              //       children: <Widget>[
              //         AutoSizeText(
              //           itemTrending.title.title != null
              //               ? itemTrending.title.title
              //               : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 14,
              //               color: Colors.white),
              //           minFontSize: 12,
              //           maxLines: 4,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         Text(
              //           itemTrending.description.description,
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 12,
              //               color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvitingChild(BuildContext context, int index) {
    final itemInviting = itemsInviting[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            FadeRoute(page: ViewerInit(id: itemInviting.id, type: "Trending")));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Center(
          child: Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: itemInviting.image != null
                    ? CachedNetworkImage(
                        imageUrl: itemInviting.image.imageURL,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              width: 115,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                        width: 115,
                        height: 170,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 170, width: 115, fit: BoxFit.cover),
              ),
              //TemplateThumbnail(description(context), position),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: 40),
              //     width: 115,
              //     child: Column(
              //       children: <Widget>[
              //         AutoSizeText(
              //           itemTrending.title.title != null
              //               ? itemTrending.title.title
              //               : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 14,
              //               color: Colors.white),
              //           minFontSize: 12,
              //           maxLines: 4,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         Text(
              //           itemTrending.description.description,
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 12,
              //               color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMylistChild(BuildContext context, int index) {
    final itemMyslist = itemsMylist[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            FadeRoute(page: ViewerInit(id: itemMyslist.id, type: "Mylist")));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Center(
          child: Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: itemMyslist.image != null
                    ? CachedNetworkImage(
                        imageUrl: itemMyslist.image.imageURL,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              width: 115,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                        width: 115,
                        height: 170,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 170, width: 115, fit: BoxFit.cover),
              ),
              //TemplateThumbnail(description(context), position),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: 40),
              //     width: 115,
              //     child: Column(
              //       children: <Widget>[
              //         AutoSizeText(
              //           itemMyslist.title.title != null
              //               ? itemMyslist.title.title
              //               : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 14,
              //               color: Colors.white),
              //           minFontSize: 12,
              //           maxLines: 4,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         Text(
              //           itemMyslist.description.description,
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 12,
              //               color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedChild(BuildContext context, int index) {
    final item = items[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            FadeRoute(page: ViewerInit(id: item.id, type: "Recommended")));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Center(
          child: Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: item.image != null
                    ? CachedNetworkImage(
                        imageUrl: item.image,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              width: 115,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                        width: 115,
                        height: 170,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 170, width: 115, fit: BoxFit.cover),
              ),
              //TemplateThumbnail(description(context), position),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: item.position.y / 4),
              //     width: 115,
              //     child: Column(
              //       children: <Widget>[
              //         AutoSizeText(
              //           item.title.title != null ? item.title.title : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: item.title.isBold
              //                   ? FontWeight.bold
              //                   : FontWeight.normal,
              //               fontSize: item.title.size / 4,
              //               color: item.title.color),
              //           minFontSize: 12,
              //           maxLines: 4,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         Text(
              //           item.subtitle.title,
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: item.subtitle.isBold
              //                   ? FontWeight.bold
              //                   : FontWeight.normal,
              //               fontSize: item.subtitle.size / 4,
              //               color: item.subtitle.color),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgainChild(BuildContext context, int index) {
    final itemAgain = itemsAgain[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            FadeRoute(page: ViewerInit(id: itemAgain.id, type: "Again")));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Center(
          child: Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: itemAgain.image != null
                    ? CachedNetworkImage(
                        imageUrl: itemAgain.image,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              width: 115,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                        width: 115,
                        height: 170,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 170, width: 115, fit: BoxFit.cover),
              ),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: itemAgain.position.y / 4),
              //     width: 115,
              //     child: Column(
              //       children: <Widget>[
              //         AutoSizeText(
              //           itemAgain.title.title != null
              //               ? itemAgain.title.title
              //               : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: itemAgain.title.isBold
              //                   ? FontWeight.bold
              //                   : FontWeight.normal,
              //               fontSize: itemAgain.title.size / 4,
              //               color: itemAgain.title.color),
              //           minFontSize: 12,
              //           maxLines: 4,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         Text(
              //           itemAgain.subtitle.title,
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: itemAgain.subtitle.isBold
              //                   ? FontWeight.bold
              //                   : FontWeight.normal,
              //               fontSize: itemAgain.subtitle.size / 4,
              //               color: itemAgain.subtitle.color),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
