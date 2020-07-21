import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/collection_manager.dart';
import 'package:xenome/screens/base_widgets/login_register_button.dart';
import 'package:xenome/firebase_services/draft_manager.dart';
import 'package:xenome/models/drafting.dart';
import 'package:xenome/screens/builder/builder_updater.dart';
import 'package:xenome/screens/builder/builder_starter.dart';
import 'package:xenome/screens/collection/collection_init.dart';
import 'package:xenome/screens/profile/edit_profile.dart';
import 'package:xenome/screens/profile/following_status.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/screens/view/search.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/verification/login_check.dart';
import 'package:xenome/screens/viewer/myactivityfeed.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/firebase_services/follow_manager.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/screens/profile/professional_sheet.dart';
import '../viewer/myactivityfeed.dart';
import 'package:link/link.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int _currentIndex = 3;
  String userId = '';
  String followerNumber = '';
  String followingNumber = '';
  String description = '';
  String website = '';
  String otherlink = '';

  List<Drafting> itemsMyXmap = [];
  final myXmapWidgets = List<Widget>();

  String imageUrl = '';
  String tellusname = '';
  List collections = [];
  String id = "";

  @override
  void initState() {
    userId = SessionManager.getUserId();
    imageUrl = SessionManager.getImage();
    tellusname = SessionManager.getTellUsName();
    website = SessionManager.getWebsite();
    otherlink = SessionManager.getOtherlink();
    description = SessionManager.getDescription();

    super.initState();
    getUserInfo();
    getMyXmapList();
    getCollections();
  }

  getBuilderId() async {
    String _id = await ViewerManager.getBuilderId();
    setState(() {
      id = _id;
    });

    Navigator.push(
        context, FadeRoute(page: BuilderStarter(id: id, type: "Buildder")));
  }

  getUserInfo() async {
    String _followerNumber =
        await FollowManager.getFollowersListCountForOtherProfile(userId);
    String _followingNumber =
        await FollowManager.getFollowingListCountForOtherProfile(userId);

    setState(() {
      followerNumber = _followerNumber;
      followingNumber = _followingNumber;
    });
  }

  getMyXmapList() async {
    List<Drafting> _itemsMyXmap = await DraftingManager.getList();
    setState(() {
      itemsMyXmap = _itemsMyXmap;
    });

    for (int i = 0; i < itemsMyXmap.length; i++) {
      myXmapWidgets.add(Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10.0,
          bottom: 15.0,
        ),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        FadeRoute(
                            page: BuilderUpdater(
                                id: itemsMyXmap[i].id, type: "SavedDraft")));
                  },
                  child: Stack(
                    //fit: StackFit.expand,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: itemsMyXmap[i].image != null
                            ? CachedNetworkImage(
                                imageUrl: itemsMyXmap[i].image.imageURL,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        Image.asset(
                                          'assets/icos/loader.gif',
                                          height: 140,
                                          width: 105,
                                          fit: BoxFit.cover,
                                        ),
                                width: 105,
                                height: 140,
                                fit: BoxFit.cover)
                            : Image.asset('assets/images/pic17.jpg',
                                height: 140, width: 100, fit: BoxFit.cover),
                      ),
                      // Center(
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 40),
                      //     width: 100,
                      //     child: Column(
                      //       children: <Widget>[
                      //         AutoSizeText(
                      //           itemMyXmap.title.title,
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
                      //           itemMyXmap.description.description,
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
                )),
              ),
              Expanded(
                  flex: 3,
                  child: itemsMyXmap[i].xmaptype == "published"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              itemsMyXmap[i].title.title,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //         flex: 6,
                            //         child: Text(
                            //           'Views',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //     Expanded(
                            //         flex: 1,
                            //         child: Text(
                            //           '458',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 5.0,
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //         flex: 6,
                            //         child: Text(
                            //           'Added to their list',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //     Expanded(
                            //         flex: 1,
                            //         child: Text(
                            //           '67',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 5.0,
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //         flex: 6,
                            //         child: Text(
                            //           'Commented',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //     Expanded(
                            //         flex: 1,
                            //         child: Text(
                            //           '46',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 5.0,
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //         flex: 6,
                            //         child: Text(
                            //           'Questions answered',
                            //           style: TextStyle(
                            //               fontSize: 12, color: Color(0xFF868E9C)),
                            //         )),
                            //     Expanded(
                            //       flex: 1,
                            //       child: Text('476',
                            //           style: TextStyle(
                            //             fontSize: 12,
                            //             color: Color(0xFF868E9C),
                            //           )),
                            //     ),
                            //   ],
                            // ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              itemsMyXmap[i].title.title,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  onPressed: () {},
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        'DRAFT',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Roboto Medium',
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                  color: Color(0xFF868E9C),
                                  elevation: 0,
                                  minWidth: 50,
                                  height: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                              ],
                            ),
                          ],
                        )),
            ],
          ),
        ),
      ));
    }
  }

  getCollections() async {
    String uid = SessionManager.getUserId();
    List _collections = await CollectionManager.getCollections(uid);

    setState(() {
      collections = _collections;
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
        {}
        break;

      default:
        {
          Navigator.push(context, FadeRoute(page: MyProfile()));
        }
    }
  }

  // Perform login or signup
  void GoEditProfile() {
    Navigator.push(context, FadeRoute(page: EditProfile()));
  }

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

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
                      _buildEditButtonChild(),
                    ] +
                    myXmapWidgets,
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
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 15.0),
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

  Widget _buildPrimaryChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 0.0, 5.0),
        child: SizedBox(
          height: 105,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              imageUrl !=
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
                            imageUrl: imageUrl,
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
                              colors: [Colors.pink, Colors.blue]),
                          borderRadius: BorderRadius.circular(94)),
                    )
                  : new CircleAvatar(
                      radius: 43,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
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
                  child: Text(tellusname,
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
                  child: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: new BorderSide(color: Color(0xFF272D3A))),
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                        child: Text('Log Out',
                            style: TextStyle(color: Color(0xFF868E9C))),
                        value: 'Log Out',
                        height: 30,
                      ),

                      // new PopupMenuItem<String>(
                      //     child: const Text(''), value: ''),
                    ],
                    icon: Icon(Icons.menu, size: 25, color: Color(0xFF868E9C)),
                    onSelected: (value) {
                      signOut();
                    },
                    color: Colors.black,
                  ),
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
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: FollowingStatus(
                        uid: userId,
                        wheretype: 'MyProfile',
                      )));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(followerNumber + ' followers',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto Medium',
                            color: Color(0xFF868E9C)))
                  ],
                ),
                color: Color(0xFF272D3A),
                elevation: 0,
                minWidth: 150,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 4,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: FollowingStatus(
                        uid: userId,
                        wheretype: 'MyProfile',
                      )));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      followingNumber + ' following',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto Medium',
                          color: Color(0xFF868E9C)),
                    )
                  ],
                ),
                color: Color(0xFF272D3A),
                elevation: 0,
                minWidth: 150,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(flex: 2, child: Text('')),
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
                        Navigator.push(context, FadeRoute(page: Search()));
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

  Widget _buildEditButtonChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
        child: LoginRegisterButton(
          title: 'Edit profile',
          onPressed: GoEditProfile,
        ),
      );

  Widget getTextWidgets(List<String> strings) {
    return new Row(children: strings.map((item) => new Text(item)).toList());
  }

  Widget _buildCollectionChild(BuildContext context, int index) {
    // final List collection = collections[index];
    return GestureDetector(
      onTap: () async {
        String collectionTitle = collections[index]['collection_title'];
        Navigator.push(
            context,
            FadeRoute(
                page: CollectionInit(
                    uid: SessionManager.getUserId(),
                    collectionTitle: collectionTitle)));
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 15.0, left: 30)
            : const EdgeInsets.only(right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
