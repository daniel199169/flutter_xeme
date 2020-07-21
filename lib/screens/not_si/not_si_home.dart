import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/firebase_services/build_manager.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/firebase_services/mylist_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/models/decorated_text.dart';
import 'package:xenome/models/buildder.dart';
import 'package:xenome/models/mylist.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/models/styled_text.dart';
import 'package:xenome/models/trending.dart';
import 'package:flutter/services.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/screens/view_info/view_info_creator.dart';
import 'package:xenome/screens/view_xmap/xmap_init.dart';
import 'package:xenome/screens/viewer/viewer_init.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/utils/string_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';

class NotSiHome extends StatefulWidget {
  NotSiHome({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _NotSiHomeState createState() => _NotSiHomeState();
}

bool is_signin = false;

class _NotSiHomeState extends State<NotSiHome> {
  int _currentIndex = 0;
  StyledText _styledText;
  File _image;

  String topImageUrl = '';
  String topXmapID = "";
  String imageUrl = '';
  String title = "Title";
  String subtitle = "Subtitle";
  String uid = "";
  String id = "";

  SetupInfo xmapTitle;
  var topXmapInfo = [];
  var titleList = [];
  var subtitleList = [];
  double yPosition = 0.01;

  List<Trending> itemsTrending = [];
  List<Mylist> itemsMylist = [];

  getXmapInfo() async {
    var _topXmapInfo = await TrendingManager.getTopXmapInfo();

    setState(() {
      topImageUrl = _topXmapInfo[0];
      topXmapID = _topXmapInfo[1];
    });
  }

  getTopXmapTitle() async {
    var _topXmapInfo = await TrendingManager.getTopXmapInfo();

    SetupInfo _xmapTitle =
        await ViewerManager.getSetupInfo(_topXmapInfo[1], "Trending");
    setState(() {
      xmapTitle = _xmapTitle;
    });
  }

  getPositionList() async {
    List<double> _positionList = await BuildManager.getPositionList(uid);
    setState(() {
      yPosition = _positionList[1];
    });
  }

  Future getImage() async {
    String filePath = await BuildManager.getImage(uid);
    List<String> realPath = filePath.split("File: '");
    File image =
        await getFile(realPath[1].substring(0, realPath[1].length - 1));
    setState(() {
      _image = image;
    });
  }

  Future<File> getFile(String path) async {
    return File(path);
  }

  @override
  void initState() {
    super.initState();

    yPosition = 0.0;
    uid = SessionManager.getUserId();
    xmapTitle = new SetupInfo(title: '', description: '');

    getXmapInfo();
    getTopXmapTitle();
    getPositionList();
    getImage();
    getTrendingList();
    getMylistList();
  }

  getTrendingList() async {
    var _itemsTrending = await TrendingManager.getList();
    setState(() {
      itemsTrending = _itemsTrending;
    });
  }

  getMylistList() async {
    var _itemsMylist = await MylistManager.getList(uid);
    setState(() {
      itemsMylist = _itemsMylist;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex != 0) {
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xFF2B8DD8), //top bar color
        statusBarIconBrightness: Brightness.light, //top bar icons
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, //top bar color
    //   statusBarIconBrightness: Brightness.light, //top bar icons
    //   systemNavigationBarColor: Colors.white, //bottom bar color
    //   systemNavigationBarIconBrightness: Brightness.light, //bottom bar icons
    // ));
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
                  itemsTrending.length != 0
                      ? Container(
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 20.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'TRENDING NOW',
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
                                  itemCount: itemsTrending.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: _buildTrendingChild,
                                ),
                              )
                            ],
                          ),
                        )
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
                ],
              ),
            ),
          ],
        ),

//        floatingActionButton: MyFloatingActionButton(),
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
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icos/triangle_outlined@3x.png',
                  width: 23,
                  height: 23,
                ),
                title: Container(),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icos/user_big_outlined@3x.png',
                  width: 23,
                  height: 23,
                  fit: BoxFit.cover,
                ),
                title: Container(),
              ),
            ],
          ),
        ));
  }

  Widget _simpleStack() => Stack(children: <Widget>[
        new ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          child: CachedNetworkImage(
            imageUrl: topImageUrl,
            placeholder: (BuildContext context, String url) => Image.asset(
              'assets/icos/loader.gif',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        TitleSentence(),
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
        ),
        Container(
          alignment: Alignment(-0.8, 0.92),
          padding: EdgeInsets.only(
              left: 40, top: 0, right: MediaQuery.of(context).size.width - 140),
          child: MaterialButton(
            onPressed: () => {
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
                  }),
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconTheme(
                  data: new IconThemeData(color: Color(0xFF868E9C)),
                  child: new Icon(Icons.add),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return ViewInfoCreator(id: topXmapID, type: "Trending");
              }));
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
        ),
      ]);

  // Widget description(BuildContext context) {
  //   return Transform.translate(
  //     offset: Offset(-130.0, -50.0),
  //     child: Transform.scale(
  //       scale: 0.3,
  //       child: Container(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Center(
  //           child: Column(
  //             children: <Widget>[
  //               Text(
  //                 _styledText.title,
  //                 style: TextStyle(
  //                     fontFamily: 'Roboto Black',
  //                     fontWeight: _styledText.isBold
  //                         ? FontWeight.bold
  //                         : FontWeight.normal,
  //                     fontSize: _styledText.size,
  //                     color: _styledText.color),
  //               ),
  //               Text(
  //                 _styledText.subTitle,
  //                 style: TextStyle(
  //                     fontFamily: 'Roboto Black',
  //                     fontWeight: _styledText.isSubBold
  //                         ? FontWeight.bold
  //                         : FontWeight.normal,
  //                     fontSize: _styledText.subSize,
  //                     color: _styledText.subColor),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTrendingChild(BuildContext context, int index) {
    final itemTrending = itemsTrending[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                ViewerInit(id: itemTrending.id, type: "Trending"),
          ),
        );
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
                child: itemTrending.image.imageURL != null
                    ? CachedNetworkImage(
                        imageUrl: itemTrending.image.imageURL,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              height: 200,
                              width: 115,
                              fit: BoxFit.cover,
                            ),
                        width: 115,
                        height: 200,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 200, width: 115, fit: BoxFit.cover),
              ),
              //TemplateThumbnail(description(context), position),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: 40),
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
              //           minFontSize: 12,
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
        ),
      ),
    );
  }

  Widget _buildMylistChild(BuildContext context, int index) {
    final itemMyslist = itemsMylist[index];
    return Padding(
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
                            height: 200,
                            width: 115,
                            fit: BoxFit.cover,
                          ),
                      width: 115,
                      height: 200,
                      fit: BoxFit.cover)
                  : Image.asset('assets/images/pic17.jpg',
                      height: 200, width: 115, fit: BoxFit.cover),
            ),
            //TemplateThumbnail(description(context), position),
            // Center(
            //   child: Container(
            //     padding: EdgeInsets.only(top: 40),
            //     width: 115,
            //     child: Column(
            //       children: <Widget>[
            //         AutoSizeText(
            //           itemMyslist.title.title,
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
      ),
    );
  }
}
