import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/collection_manager.dart';
import 'package:xenome/firebase_services/follow_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/screens/collection/collection_init.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'package:flag/flag.dart';
import 'package:xenome/firebase_services/activity_manager.dart';
import 'package:xenome/screens/profile/following_status.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:xenome/screens/viewer/viewer_init.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:link/link.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

class OthersProfile extends StatefulWidget {
  final String uid;

  OthersProfile({this.uid});
  @override
  _OthersProfileState createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  int _currentIndex = 4;
  List<Trending> itemsTrending = [];
  String avatar = '';
  String name = '';
  String description = '';
  String website = '';
  String otherlink = '';
  String followingCount = '';
  String followerCount = '';
  String followStatus = '';
  List collections = [];

  @override
  void initState() {
    super.initState();

    getTrendingList();
    getFollowingListCount();
    getFollowersListCount();
    getCollections();
    getUserInfo();
    getFollowStatus();
  }

  getFollowStatus() async {
    String _followStatus = await FollowManager.getFollowStatus(widget.uid);
    setState(() {
      followStatus = _followStatus;
    });
  }

  getUserInfo() async {
    var _userAvatar = await ActivityManager.getUserImage(widget.uid);
    var _userWebsites = await ActivityManager.getUserWebsite(widget.uid);
    var _description = await ActivityManager.getUserDescription(widget.uid);
    var _otherlink = await ActivityManager.getUserOtherlink(widget.uid);
    var _name = await ActivityManager.getPostUserName(widget.uid);
    if (_userWebsites == null) {
      _userWebsites = "";
    }
    setState(() {
      avatar = _userAvatar;
      name = _name;
      website = _userWebsites;
      otherlink = _otherlink;
      description = _description;
    });
  }

  getTrendingList() async {
    var _itemsTrending = await TrendingManager.getList();
    setState(() {
      itemsTrending = _itemsTrending;
    });
  }

  getFollowersListCount() async {
    String _followerCount =
        await FollowManager.getFollowersListCountForOtherProfile(widget.uid);
    setState(() {
      followerCount = _followerCount;
    });
  }

  getFollowingListCount() async {
    String _followingCount =
        await FollowManager.getFollowingListCountForOtherProfile(widget.uid);
    setState(() {
      followingCount = _followingCount;
    });
  }

  getCollections() async {
    List _collections = await CollectionManager.getCollections(widget.uid);

    setState(() {
      collections = _collections;
    });
  }

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  // Perform login or signup
  void validateAndSubmit() async {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      color: Colors.black,
      child: new ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPrimaryChild(),
              _buildTwoButtonChild(),
              _buildCommentChild(),
              website != '' ? _buildLinkUrl1Child() : Container(),
              otherlink != '' ? _buildLinkUrl2Child() : Container(),
            ],
          ),
          collections.length != 0
              ? Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Stack(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 25.0, 0.0, 20.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'COLLECTIONS',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 15.0),
                      constraints: const BoxConstraints(maxHeight: 300.0),
                      child: ListView.builder(
                        itemCount: collections.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: _buildCollectionChild,
                      ),
                    ),
                  ]))
              : Container(),
        ],
      ),
    ));
  }

  Widget _buildPrimaryChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 0.0, 5.0),
        child: SizedBox(
          height: 105,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              avatar !=
                      'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                  ? Container(
                      height: 94,
                      width: 94,
                      padding: EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.black,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(86),
                          child: CachedNetworkImage(
                            imageUrl: avatar,
                            placeholder: (BuildContext context, String url) =>
                                Image.asset(
                              'assets/icos/loader.gif',
                              width: 86,
                              height: 86,
                              fit: BoxFit.cover,
                            ),
                            width: 86,
                            height: 86,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffC26FED), Color(0xff5086DE)]),
                          borderRadius: BorderRadius.circular(94)),
                    )
                  : new CircleAvatar(
                      radius: 43,
                      child: CachedNetworkImage(
                        imageUrl: avatar,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                          'assets/icos/loader.gif',
                          height: 43,
                          width: 43,
                          fit: BoxFit.cover,
                        ),
                        width: 43,
                        height: 43,
                        fit: BoxFit.fill,
                      ),
                      backgroundColor: Color(0xFF272D3A),
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 35.0, 0.0, 0.0),
                  child: Text(name,
                      style: TextStyle(
                        fontFamily: 'Roboto Medium',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(55.0, 20.0, 0.0, 0.0),
                  child: IconTheme(
                    data: new IconThemeData(color: Color(0xFF868E9C)),
                    child: new IconButton(
                        icon: Icon(Icons.close,
                            size: 25, color: Color(0xFF868E9C)),
                        onPressed: () {
                          if (SessionManager.getUserId() != '') {
                            Navigator.push(context, FadeRoute(page: Home()));
                          } else {
                            Navigator.push(
                                context, FadeRoute(page: NotSiHome()));
                          }
                        }),
                  ), // myIcon is a 48px-wide widget.
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTwoButtonChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        FadeRoute(
                            page: FollowingStatus(
                          uid: widget.uid,
                          wheretype: 'OtherProfile',
                        )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        followerCount + ' followers',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto Medium',
                            color: Colors.grey),
                      )
                    ],
                  ),
                  color: Color(0xFF272D3A),
                  elevation: 0,
                  minWidth: 50,
                  padding: EdgeInsets.all(0),
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        FadeRoute(
                            page: FollowingStatus(
                          uid: widget.uid,
                          wheretype: 'OtherProfile',
                        )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        followingCount + ' following',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto Medium',
                            color: Colors.grey),
                      )
                    ],
                  ),
                  color: Color(0xFF272D3A),
                  elevation: 0,
                  minWidth: 50,
                  height: 40,
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: widget.uid != SessionManager.getUserId()
                  ? Container(
                      padding: EdgeInsets.all(0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (SessionManager.getUserId() != '') {
                            if (followStatus == "Follow") {
                              await FollowManager.setFollowingOther(widget.uid);

                              setState(() {
                                followStatus = "Unfollow";
                                followerCount =
                                    (int.parse(followerCount) + 1).toString();
                              });
                            } else {
                              await FollowManager.delFollowingOther(widget.uid);
                              setState(() {
                                followStatus = "Follow";
                                followerCount =
                                    (int.parse(followerCount) - 1).toString();
                              });
                            }
                          } else {
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
                                        child: BottomSheetWidget(),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              followStatus,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Roboto Medium',
                                  color: Colors.white),
                            )
                          ],
                        ),
                        color: Color(0xFF272D3A),
                        elevation: 0,
                        minWidth: 60,
                        padding: EdgeInsets.all(0),
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      );

  Widget _buildCommentChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 5.0),
        child: Text(
          description,
          style: TextStyle(
              fontSize: 13, fontFamily: 'Roboto Medium', color: Colors.white),
        ),
      );
  Widget _buildLinkUrl1Child() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0.0),
                  child: Link(
                    child: Text(website,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xFF868E9C),
                          fontSize: 15,
                        )),
                    url: website,
                    onError: _showErrorSnackBar,
                  )),
              flex: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: IconTheme(
                  data: new IconThemeData(color: Color(0xFF868E9C)),
                  child: new IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          size: 15, color: Color(0xFF868E9C)),
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
      );

  Widget _buildGridChild(BuildContext context, int index) {
    final itemTrending = itemsTrending[index];
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
      child: Stack(
        //fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                FadeRoute(
                  page: ViewerInit(id: itemTrending.id, type: "Trending"),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: itemTrending.image.imageURL != null
                  ? CachedNetworkImage(
                      imageUrl: itemTrending.image.imageURL,
                      placeholder: (BuildContext context, String url) =>
                          Image.asset(
                            'assets/icos/loader.gif',
                            height: 170,
                            width: 115,
                            fit: BoxFit.cover,
                          ),
                      height: 170,
                      width: 115,
                      fit: BoxFit.cover)
                  : Image.asset('assets/images/pic17.jpg',
                      height: 170, width: 115, fit: BoxFit.cover),
            ),
          ),
          // Center(
          //   child: Container(
          //     padding: EdgeInsets.only(top: 70),
          //     width: 115,
          //     child: Column(
          //       children: <Widget>[
          //         AutoSizeText(
          //           itemTrending.title.title,
          //           style: TextStyle(
          //               fontFamily: 'Roboto Black',
          //               fontWeight: FontWeight.w900,
          //               fontSize: 14,
          //               color: Colors.white),
          //           minFontSize: 13,
          //           maxLines: 4,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //         Text(
          //           itemTrending.description.description,
          //           style: TextStyle(
          //               fontFamily: 'Roboto Black',
          //               fontWeight: FontWeight.w600,
          //               fontSize: 12,
          //               color: Colors.white),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLinkUrl2Child() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (_) => CreateDistribution()),
//                              );
                },
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0.0),
                    child: Link(
                      child: Text(otherlink,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xFF868E9C),
                            fontSize: 15,
                          )),
                      url: otherlink,
                      onError: _showErrorSnackBar,
                    )),
              ),
              flex: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: IconTheme(
                  data: new IconThemeData(color: Color(0xFF868E9C)),
                  child: new IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          size: 15, color: Color(0xFF868E9C)),
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
      );

  Widget _buildCollectionChild(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        String collectionTitle = collections[index]['collection_title'];
        Navigator.push(
          context,
          FadeRoute(
            page: CollectionInit(
                uid: widget.uid, collectionTitle: collectionTitle),
          ),
        );
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
                    child: collections[index]['collection_image'] != null
                        ? CachedNetworkImage(
                            imageUrl: collections[index]['collection_image'],
                            placeholder: (BuildContext context, String url) =>
                                Image.asset(
                                  'assets/icos/loader.gif',
                                  height: 170,
                                  width: 115,
                                  fit: BoxFit.cover,
                                ),
                            width: 115,
                            height: 170,
                            fit: BoxFit.cover)
                        : Image.asset('assets/images/pic17.jpg',
                            height: 170, width: 115, fit: BoxFit.cover),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 180),
                      width: 115,
                      child: Column(
                        children: <Widget>[
                          AutoSizeText(
                            collections[index]['collection_title'].length < 13
                                ? collections[index]['collection_title']
                                : collections[index]['collection_title']
                                        .substring(0, 10) +
                                    " ...",
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
