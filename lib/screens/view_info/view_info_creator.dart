import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:share/share.dart';
import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:xenome/firebase_services/authentication.dart';
// import 'package:xenome/firebase_services/build_manager.dart';
// import 'package:xenome/firebase_services/mylist_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/firebase_services/Viewer_manager.dart';
import 'package:xenome/firebase_services/follow_manager.dart';
// import 'package:xenome/models/xmap_info.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:xenome/models/mylist.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/screens/profile/others_profile.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/viewer/viewer_init.dart';
// import 'package:xenome/utils/string_helper.dart';
// import 'package:xenome/verification/login_check.dart';
// import 'latest_result_chart.dart';
// import 'package:xenome/screens/viewer/splashscreen.dart';
import 'package:xenome/screens/builder/builder_updater.dart';
import 'package:xenome/screens/view_xmap/xmap_init.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'instagram_info.dart';
import 'viewer_cover_image_info.dart';
import 'viewer_image_info.dart';
import 'vimeo_info.dart';
import 'youtube_info.dart';
import 'quad_start_info.dart';
import 'scale_start_info.dart';

class ViewInfoCreator extends StatefulWidget {
  ViewInfoCreator(
      {this.id, this.type, this.pageId, this.auth, this.loginCallback});

  final String id;
  final String type;
  final String pageId;
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _ViewInfoCreatorState createState() => _ViewInfoCreatorState();
}

class _ViewInfoCreatorState extends State<ViewInfoCreator> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Position position;
  List<double> positionList;

  String imageData = '';

  String title = "Title";
  String subtitle = "Subtitle";
  String uid = "";

  var itemsMostActiveViewer = [];
  var itemsTrending = [];
  var itemsAllViewers = [];
  var itemsScaleChart = [];
  var itemsQuadChart = [];
  SetupInfo xmapTitle;

  String imageUrl = '';
  String featuredUid = '';
  String userName = '';

  List<Trending> itemsViewerAlsoViewed = [];
  List<Mylist> itemsMylist = [];
  final scaleChartWidgets = List<Widget>();
  final quadChartWidgets = List<Widget>();

  String topImageUrl = '';
  int sectionsNumber = 3;
  String topXmapID = "";
  String topXmapUid = "";

  getXmapInfo() async {
    var _topXmapInfo = await ViewerManager.getXmapInfo(widget.id, widget.type);

    setState(() {
      topImageUrl = _topXmapInfo[0];
      topXmapID = _topXmapInfo[1];
      topXmapUid = _topXmapInfo[2];
    });

    String _userName = await FollowManager.getFollowingName(topXmapUid);
    setState(() {
      userName = _userName;
    });
  }

  getXmapTitle() async {
    var _topXmapInfo = await ViewerManager.getXmapInfo(widget.id, widget.type);

    SetupInfo _xmapTitle =
        await ViewerManager.getSetupInfo(_topXmapInfo[1], widget.type);

    setState(() {
      xmapTitle = _xmapTitle;
    });
  }

  @override
  void initState() {
    super.initState();

    uid = SessionManager.getUserId();
    xmapTitle = new SetupInfo(title: '', description: '');

    getXmapInfo();
    getXmapTitle();
    getAvatar();
    getSectionsNumber();
    // getPositionList();
    // getImage();
    getTrendingViewList();
    getAllViewers();
    getMostActiveViewers();
    getViewerAlsoViewed();
    getScaleChart();
    getQuadChart();
  }

  getMostActiveViewers() async {
    var _itemsMostActiveViewer =
        await ViewerManager.getMostActiveViewers(widget.id);
    setState(() {
      itemsMostActiveViewer = _itemsMostActiveViewer;
    });
  }

  getTrendingViewList() async {
    var _itemsTrending = await ViewerManager.getTrendingView(widget.id);
    setState(() {
      itemsTrending = _itemsTrending;
    });
  }

  getViewerAlsoViewed() async {
    var _itemsViewerAlsoViewed = await ViewerManager.getViewerAlsoViewed(
        widget.id, SessionManager.getUserId());
    setState(() {
      itemsViewerAlsoViewed = _itemsViewerAlsoViewed;
      // print("---------      -----------    ---------------");
      // print(itemsViewerAlsoViewed);
    });
  }

  getAllViewers() async {
    var _itemsAllViewers = await ViewerManager.getAllViewers(widget.id);
    setState(() {
      // print("--------- -----------    ---------------");
      // print(_itemsAllViewers);
      itemsAllViewers = _itemsAllViewers;
    });
  }

  getScaleChart() async {
    var _itemsScaleChart = await ViewerManager.getScaleChart(widget.id);
    if (_itemsScaleChart != []) {
      setState(() {
        itemsScaleChart = _itemsScaleChart;
      });

      for (int i = 0; i < itemsScaleChart.length; i++) {
        scaleChartWidgets.add(Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: ViewScaleStart(
                                      id: widget.id,
                                      type: "Trending",
                                      subOrder: itemsScaleChart[i][7],
                                      pageId: itemsScaleChart[i][8])));
                        },
                        child: Text(
                          itemsScaleChart[i][0],
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      itemsScaleChart[i][1],
                      style: TextStyle(fontSize: 14, color: Color(0xFF868E9C)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            itemsScaleChart[i][2],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      Expanded(
                        flex: 8,
                        child: LinearPercentIndicator(
                          lineHeight: 3.0,
                          percent: double.parse(itemsScaleChart[i][3]),
                          progressColor: Color(0xFF2B8DD8),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      itemsScaleChart[i][4],
                      style: TextStyle(fontSize: 14, color: Color(0xFF868E9C)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            itemsScaleChart[i][5],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      Expanded(
                        flex: 8,
                        child: LinearPercentIndicator(
                          lineHeight: 3.0,
                          percent: double.parse(itemsScaleChart[i][6]),
                          progressColor: Color(0xFF2B8DD8),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ));
      }
    }
  }

  getQuadChart() async {
    var _itemsQuadChart = await ViewerManager.getQuadChart(widget.id);
    if (_itemsQuadChart != []) {
      setState(() {
        itemsQuadChart = _itemsQuadChart;
      });

      for (int i = 0; i < itemsQuadChart.length; i++) {
        quadChartWidgets.add(Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: ViewQuadStart(
                                      id: widget.id,
                                      type: "Trending",
                                      subOrder: itemsQuadChart[i][13],
                                      pageId: itemsQuadChart[i][14])));
                        },
                        child: Text(
                          itemsQuadChart[i][0],
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      itemsQuadChart[i][1],
                      style: TextStyle(fontSize: 14, color: Color(0xFF868E9C)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            itemsQuadChart[i][2],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      Expanded(
                        flex: 8,
                        child: LinearPercentIndicator(
                          lineHeight: 3.0,
                          percent: double.parse(itemsQuadChart[i][3]),
                          progressColor: Color(0xFF2B8DD8),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      itemsQuadChart[i][4],
                      style: TextStyle(fontSize: 14, color: Color(0xFF868E9C)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            itemsQuadChart[i][5],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      Expanded(
                        flex: 8,
                        child: LinearPercentIndicator(
                          lineHeight: 3.0,
                          percent: double.parse(itemsQuadChart[i][6]),
                          progressColor: Color(0xFF2B8DD8),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      itemsQuadChart[i][7],
                      style: TextStyle(fontSize: 14, color: Color(0xFF868E9C)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            itemsQuadChart[i][8],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      Expanded(
                        flex: 8,
                        child: LinearPercentIndicator(
                          lineHeight: 3.0,
                          percent: double.parse(itemsQuadChart[i][9]),
                          progressColor: Color(0xFF2B8DD8),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      itemsQuadChart[i][10],
                      style: TextStyle(fontSize: 14, color: Color(0xFF868E9C)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            itemsQuadChart[i][11],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      Expanded(
                        flex: 8,
                        child: LinearPercentIndicator(
                          lineHeight: 3.0,
                          percent: double.parse(itemsQuadChart[i][12]),
                          progressColor: Color(0xFF2B8DD8),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ));
      }
    }
  }

  getSectionsNumber() async {
    var _getPageOrder =
        await ViewerManager.getPageOrder(widget.id, widget.type);

    setState(() {
      sectionsNumber = _getPageOrder.length;
    });
  }

  getAvatar() async {
    String _featuredUid =
        await TrendingManager.getFeaturedUserId(widget.id, widget.type);
    setState(() {
      featuredUid = _featuredUid;
    });
    String _imageUrl = await TrendingManager.getAvatarImage(featuredUid);
    setState(() {
      imageUrl = _imageUrl;
    });
  }

  // getMylistList() async {
  //   var _itemsMylist = await MylistManager.getList(uid);
  //   setState(() {
  //     itemsMylist = _itemsMylist;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, //top bar color
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return new Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldKey,
      body: CustomScrollView(slivers: <Widget>[
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
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 20,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SessionManager.getUserId() != '' &&
                              SessionManager.getUserId() == topXmapUid
                          ? Container(
                              child: MaterialButton(
                                onPressed: () {
                                  if (SessionManager.getUserId() ==
                                      topXmapUid) {
                                    Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: BuilderUpdater(
                                                id: widget.id,
                                                type: widget.type)));
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    IconTheme(
                                      data:
                                          new IconThemeData(color: Colors.grey),
                                      child: new Icon(Icons.edit),
                                    ),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                                color: Color(0xFF272D3A),
                                elevation: 0,
                                minWidth: 150,
                                height: 35,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: SessionManager.getUserId() != ''
                          ? Builder(builder: (BuildContext context) {
                              return Container(

                                  // child: MaterialButton(
                                  //   onPressed: () {
                                  //     // final RenderBox box = context.findRenderObject();
                                  //     // Share.share("sdfsd234",
                                  //     //     subject: "Xmap share",
                                  //     //     sharePositionOrigin:
                                  //     //         box.localToGlobal(Offset.zero) &
                                  //     //             box.size);
                                  //   },
                                  //   child: Row(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceAround,
                                  //     children: <Widget>[
                                  //       IconTheme(
                                  //         data: new IconThemeData(
                                  //             color: Colors.grey),
                                  //         child: new Icon(Icons.reply),
                                  //       ),
                                  //       Text(
                                  //         'Share',
                                  //         style: TextStyle(
                                  //             fontSize: 12,
                                  //             fontFamily: 'Roboto',
                                  //             color: Colors.grey),
                                  //       )
                                  //     ],
                                  //   ),
                                  //   color: Color(0xFF272D3A),
                                  //   elevation: 0,
                                  //   minWidth: 150,
                                  //   height: 35,
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(50)),
                                  // ),
                                  );
                            })
                          : Container(),
                    ),
                    SessionManager.getUserId() != ''
                        ? SizedBox(
                            width: 10,
                          )
                        : Container(),
                    Expanded(
                      flex: 3,
                      child: Container(

                          // child: MaterialButton(
                          //   onPressed: () {},
                          // child: Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // children: <Widget>[
                          //   IconTheme(
                          //     data: new IconThemeData(color: Colors.grey),
                          //     child: new Icon(Icons.add_box),
                          //   ),
                          //   Text(
                          //     'Request to contribute',
                          //     style: TextStyle(
                          //         fontSize: 12,
                          //         fontFamily: 'Roboto',
                          //         color: Colors.grey),
                          //   )
                          // ],
                          //   ),
                          //   color: Color(0xFF272D3A),
                          //   elevation: 0,
                          //   minWidth: 150,
                          //   height: 35,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(50)),
                          // ),
                          ),
                    ),
                  ],
                ),
              ),
              // SessionManager.getUserId() != ''
              //     ? Container(
              //         padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
              //         height: 0.5,
              //         color: Colors.grey,
              //       )
              //     : Container(),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           new GestureDetector(
//                             onTap: () {
// //                              Navigator.push(
// //                                context,
// //                                MaterialPageRoute(builder: (_) => CreateDistribution()),
// //                              );
//                             },
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
//                               child: Text('Contributors & references',
//                                   style: TextStyle(
//                                     fontFamily: 'Roboto',
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 17,
//                                   )),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
//                             child: Text('Amanda Daniels, James Smith ... +35',
//                                 style: TextStyle(
//                                   fontFamily: 'Roboto',
//                                   color: Colors.white,
//                                   fontSize: 13,
//                                 )),
//                           ),
//                         ],
//                       ),
//                       flex: 7,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
//                         child: IconTheme(
//                           data: new IconThemeData(color: Color(0xFF868E9C)),
//                           child: new IconButton(
//                               icon: Icon(Icons.arrow_forward_ios,
//                                   size: 18, color: Color(0xFF868E9C)),
//                               onPressed: () {
//                                 //                              Navigator.push(
//                                 //                                context,
//                                 //                                MaterialPageRoute(builder: (_) => Search()),
//                                 //                              );
//                               }),
//                         ), // myIcon is a 48px-wide widget.
//                       ),
//                       flex: 1,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
//                 height: 0.5,
//                 color: Colors.grey,
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           new GestureDetector(
//                             onTap: () {
// //                              Navigator.push(
// //                                context,
// //                                MaterialPageRoute(builder: (_) => CreateDistribution()),
// //                              );
//                             },
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(20, 0, 5.0, 0.0),
//                               child: Text('Location',
//                                   style: TextStyle(
//                                     fontFamily: 'Roboto',
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 17,
//                                   )),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
//                             child: Text('Gertrude & Alice Cafe Bookstore',
//                                 style: TextStyle(
//                                   fontFamily: 'Roboto',
//                                   color: Colors.white,
//                                   fontSize: 13,
//                                 )),
//                           ),
//                         ],
//                       ),
//                       flex: 7,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
//                         child: IconTheme(
//                           data: new IconThemeData(color: Color(0xFF868E9C)),
//                           child: new IconButton(
//                               icon: Icon(Icons.arrow_forward_ios,
//                                   size: 18, color: Color(0xFF868E9C)),
//                               onPressed: () {
//                                 //                              Navigator.push(
//                                 //                                context,
//                                 //                                MaterialPageRoute(builder: (_) => Search()),
//                                 //                              );
//                               }),
//                         ), // myIcon is a 48px-wide widget.
//                       ),
//                       flex: 1,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
//                 height: 0.5,
//                 color: Colors.grey,
//               ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 15.0),
              //   child: RichText(
              //     text: TextSpan(
              //       text: 'LATEST RESULTS',
              //       style: Theme.of(context).textTheme.subtitle,
              //     ),
              //   ),
              // ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(30.0, 20, 0.0, 0.0),
              //   height: 300,
              //   child: LatestResultChart(),
              // ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(30.0, 0, 0.0, 0.0),
              //   height: 20,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             CircleAvatar(
              //               backgroundColor: Color(0xFF2B8DD8),
              //               radius: 5.0,
              //             ),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             Text(
              //               'Views',
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   fontFamily: 'Roboto',
              //                   color: Color(0xFF2B8DD8)),
              //             )
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //           flex: 1,
              //           child: Text(
              //             '458',
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 fontFamily: 'Roboto',
              //                 color: Colors.white),
              //           )),
              //       Expanded(
              //         flex: 2,
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             CircleAvatar(
              //               backgroundColor: Colors.lightBlueAccent,
              //               radius: 5.0,
              //             ),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             Text(
              //               'Commented',
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   fontFamily: 'Roboto',
              //                   color: Colors.lightBlueAccent),
              //             )
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //           flex: 1,
              //           child: Text(
              //             '458',
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 fontFamily: 'Roboto',
              //                 color: Colors.white),
              //           )),
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(30.0, 0, 0.0, 0.0),
              //   height: 20,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             CircleAvatar(
              //               backgroundColor: Colors.purple,
              //               radius: 5.0,
              //             ),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             Text(
              //               'Added to their list',
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   fontFamily: 'Roboto',
              //                   color: Colors.purple),
              //             )
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //           flex: 1,
              //           child: Text(
              //             '67',
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 fontFamily: 'Roboto',
              //                 color: Colors.white),
              //           )),
              //       Expanded(
              //         flex: 2,
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             CircleAvatar(
              //               backgroundColor: Colors.green,
              //               radius: 5.0,
              //             ),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             Text(
              //               'Responses',
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   fontFamily: 'Roboto',
              //                   color: Colors.green),
              //             )
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //           flex: 1,
              //           child: Text(
              //             '458',
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 fontFamily: 'Roboto',
              //                 color: Colors.white),
              //           )),
              //     ],
              //   ),
              // ),
              SessionManager.getUserId() != '' &&
                      SessionManager.getUserId() == topXmapUid &&
                      itemsTrending.length > 0
                  ? Container(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 15.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'TRENDING SECTIONS',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 60),
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 15.0, 0.0, 15.0),
                            constraints: const BoxConstraints(maxHeight: 140.0),
                            child: new ListView.builder(
                              itemCount: itemsTrending.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: _buildTrendingSectionChild,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),

              SessionManager.getUserId() != '' &&
                      SessionManager.getUserId() == topXmapUid &&
                      itemsMostActiveViewer.length > 0
                  ? Container(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 15.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'MOST ACTIVE VIEWERS',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 60),
                            padding:
                                const EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 0.0),
                            constraints: const BoxConstraints(maxHeight: 120.0),
                            child: new ListView.builder(
                              itemCount: itemsMostActiveViewer.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: _buildMostActiveViewerChild,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SessionManager.getUserId() != '' &&
                      SessionManager.getUserId() == topXmapUid &&
                      itemsAllViewers.length > 0
                  ? Container(
                      child: Stack(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 15.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'ALL VIEWERS (' +
                                itemsAllViewers.length.toString() +
                                ")",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 40),
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 0.0),
                        constraints: const BoxConstraints(maxHeight: 130.0),
                        child: new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: _buildAllViewersChild,
                        ),
                      ),
                    ]))
                  : Container(),
              SessionManager.getUserId() != '' &&
                      itemsViewerAlsoViewed.length > 0
                  ? Container(
                      child: Stack(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 15.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'VIEWERS ALSO VIEWED',
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 40),
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                        constraints: const BoxConstraints(maxHeight: 200.0),
                        child: new ListView.builder(
                          itemCount: itemsViewerAlsoViewed.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: _buildViewerAlsoViewedChild,
                        ),
                      ),
                    ]))
                  : Container(),

              SessionManager.getUserId() != '' &&
                      SessionManager.getUserId() == topXmapUid
                  ? itemsScaleChart.length + itemsQuadChart.length > 0
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'RESULTS',
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
              SessionManager.getUserId() != '' &&
                      SessionManager.getUserId() == topXmapUid
                  ? Container(
                      child: Column(
                        children:
                            <Widget>[] + scaleChartWidgets + quadChartWidgets,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 50,
              )
              // SessionManager.getUserId() != ''
              //     ? new Container(
              //         padding: EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
              //         child: Row(
              //           children: <Widget>[
              //             RichText(
              //               text: TextSpan(
              //                 text: 'ALSO BY ',
              //                 style: Theme.of(context).textTheme.subtitle,
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.of(context).push(
              //                     MaterialPageRoute<Null>(
              //                         builder: (BuildContext context) {
              //                   return OthersProfile(
              //                     uid: topXmapUid,
              //                   );
              //                 }));
              //               },
              //               child: RichText(
              //                 text: TextSpan(
              //                   text: userName,
              //                   style: Theme.of(context).textTheme.subtitle,
              //                 ),
              //               ),
              //             ),
              //             RichText(
              //               text: TextSpan(
              //                 text: ' REWARDS',
              //                 style: Theme.of(context).textTheme.subtitle,
              //               ),
              //             ),
              //           ],
              //         ))
              //     : Container(),
              // SessionManager.getUserId() != ''
              //     ? new Container(
              //         padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
              //         constraints: const BoxConstraints(maxHeight: 200.0),
              //         child: new ListView.builder(
              //           itemCount: itemsMylist.length,
              //           scrollDirection: Axis.horizontal,
              //           itemBuilder: _buildMylistChild,
              //         ),
              //       )
              //     : Container(),
            ],
          ),
        ),
      ]),
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
          //     child: new Text(xmapTitle.title,
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
          //     child: new Text(xmapTitle.description,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             fontFamily: 'Roboto Black',
          //             fontWeight: FontWeight.w600,
          //             fontSize: 32,
          //             color: Colors.white)),
          //   ),
          // ),
          Container(
            alignment: Alignment(-0.8, -0.84),
            padding: EdgeInsets.only(top: 0, right: 0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: OthersProfile(
                        uid: topXmapUid,
                      )));
                },
                child: Container(
                  height: 38,
                  width: 38,
                  padding: EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                          'assets/icos/loader.gif',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.pink, Colors.blue]),
                      borderRadius: BorderRadius.circular(19)),
                )),
          ),
          Container(
            alignment: Alignment(0.8, -0.84),
            padding: EdgeInsets.only(top: 0, right: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 20.0,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment(0.8, 0.9),
            padding: EdgeInsets.only(top: 0, right: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    FadeRoute(
                        page: XmapInit(id: widget.id, type: widget.type)));
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
              alignment: Alignment(-0.7, 0.85),
              child: Text(
                'January 2020      ' + sectionsNumber.toString() + ' Sections',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: Color(0xFFFFFFFF)),
              )),
        ],
      );

  Widget _buildAllViewersChild(BuildContext context, int index) {
    index++;
    if (index > itemsAllViewers.length) return null;
    if (index < 4) {
      return new Padding(
        padding: index == 1
            ? EdgeInsets.only(left: 0, right: 10.0, top: 5.0, bottom: 5.0)
            : EdgeInsets.only(left: 10, right: 10.0, top: 5.0, bottom: 5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                FadeRoute(
                    page: OthersProfile(
                  uid: itemsAllViewers[index - 1][0],
                )));
          },
          child: Container(
            child: Column(
              children: <Widget>[
                itemsAllViewers[index - 1][1] !=
                        'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                    ? Container(
                        height: 72,
                        width: 72,
                        padding: EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.black,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: itemsAllViewers[index - 1][1],
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                'assets/icos/loader.gif',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                              width: 64,
                              height: 64,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.blue]),
                            borderRadius: BorderRadius.circular(36)),
                      )
                    : Container(
                        height: 72,
                        width: 72,
                        padding: EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Color(0xFF272D3A),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: CachedNetworkImage(
                              imageUrl: itemsAllViewers[index - 1][1],
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                'assets/icos/loader.gif',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                              width: 32,
                              height: 32,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.blue]),
                            borderRadius: BorderRadius.circular(36)),
                      ),
                SizedBox(
                  height: 7.0,
                ),
                Text(
                  itemsAllViewers[index - 1][2].length < 13
                      ? itemsAllViewers[index - 1][2]
                      : itemsAllViewers[index - 1][2].substring(0, 10) + "...",
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return new Padding(
          padding: index == 1
              ? EdgeInsets.only(left: 0, right: 10.0, top: 5.0, bottom: 5.0)
              : EdgeInsets.only(left: 10, right: 10.0, top: 5.0, bottom: 5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  FadeRoute(
                      page: OthersProfile(
                    uid: itemsAllViewers[index - 1][0],
                  )));
            },
            child: Column(
              children: <Widget>[
                itemsAllViewers[index - 1][1] !=
                        'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                    ? CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.black,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: CachedNetworkImage(
                            imageUrl: itemsAllViewers[index - 1][1],
                            placeholder: (BuildContext context, String url) =>
                                Image.asset(
                              'assets/icos/loader.gif',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                            width: 72,
                            height: 72,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Container(
                        height: 72,
                        width: 72,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Color(0xFF272D3A),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: CachedNetworkImage(
                              imageUrl: itemsAllViewers[index - 1][1],
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                'assets/icos/loader.gif',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                              width: 32,
                              height: 32,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 7.0,
                ),
                Text(
                  itemsAllViewers[index - 1][2].length < 13
                      ? itemsAllViewers[index - 1][2]
                      : itemsAllViewers[index - 1][2].substring(0, 10) + "...",
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
          ));
    }
  }

  Widget _buildTrendingSectionChild(BuildContext context, int index) {
    final itemTrending = itemsTrending[index];
    if (index < 5) {
      return Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 0)
            : const EdgeInsets.only(right: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    if (itemTrending[3] == 'Cover image') {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: ViewerCoverImage(
                            id: widget.id,
                            type: widget.type,
                            pageId: itemTrending[5],
                          )));
                    }
                    if (itemTrending[3] == 'Image') {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: ViewerImage(
                            id: widget.id,
                            type: widget.type,
                            subOrder: itemTrending[4],
                            pageId: itemTrending[5],
                          )));
                    }
                    if (itemTrending[3] == 'YouTube') {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: YouTube(
                            id: widget.id,
                            type: widget.type,
                            subOrder: itemTrending[4],
                            pageId: itemTrending[5],
                          )));
                    }
                    if (itemTrending[3] == 'Vimeo') {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: Vimeo(
                            id: widget.id,
                            type: widget.type,
                            subOrder: itemTrending[4],
                            pageId: itemTrending[5],
                          )));
                    }
                    if (itemTrending[3] == 'Instagram') {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: Instagram(
                            id: widget.id,
                            type: widget.type,
                            subOrder: itemTrending[4],
                            pageId: itemTrending[5],
                          )));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: itemTrending[0] != null
                            ? CachedNetworkImage(
                                imageUrl: itemTrending[0],
                                placeholder:
                                    (BuildContext context, String url) =>
                                        Image.asset(
                                          'assets/icos/loader.gif',
                                          height: 100,
                                          width: 72,
                                          fit: BoxFit.cover,
                                        ),
                                height: 100,
                                width: 72,
                                fit: BoxFit.cover)
                            : Image.asset('assets/images/pic17.jpg',
                                height: 100, width: 72, fit: BoxFit.cover),
                      ),

                      // SizedBox(
                      //   height: 4.0,
                      // ),
                      // Text(
                      //   '27yo',
                      //   style:
                      //       TextStyle(fontSize: 12, color: Color(0xFF868E9C)),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Views',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF868E9C)),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              itemTrending[1],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            )),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Comments',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF868E9C)),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              itemTrending[2],
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                              textAlign: TextAlign.right,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Container(
                      width: 1.0,
                      color: Color(0xFF272D3A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMostActiveViewerChild(BuildContext context, int index) {
    final itemMostActiveViewer = itemsMostActiveViewer[index];
    if (index < 10) {
      return Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 0)
            : const EdgeInsets.only(right: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        FadeRoute(
                            page: OthersProfile(
                          uid: itemMostActiveViewer[4],
                        )));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // new CircleAvatar(
                      //   child: CircleAvatar(
                      //     child: CircleAvatar(
                      //       radius: 32,
                      //       backgroundImage: NetworkImage(
                      //         itemMostActiveViewer[0],
                      //         //fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //     foregroundColor: Colors.white,
                      //     backgroundColor: Colors.black,
                      //     radius: 34.0,
                      //   ),
                      //   radius: 36,
                      //   backgroundImage: AssetImage(
                      //     'assets/images/circle.png',
                      //     //fit: BoxFit.cover,
                      //   ),
                      // ),
                      itemMostActiveViewer[0] !=
                              'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                          ? Container(
                              height: 72,
                              width: 72,
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.black,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: CachedNetworkImage(
                                    imageUrl: itemMostActiveViewer[0],
                                    placeholder:
                                        (BuildContext context, String url) =>
                                            Image.asset(
                                      'assets/icos/loader.gif',
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.pink, Colors.blue]),
                                  borderRadius: BorderRadius.circular(36)),
                            )
                          : Container(
                              height: 72,
                              width: 72,
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                radius: 34,
                                backgroundColor: Color(0xFF272D3A),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: CachedNetworkImage(
                                    imageUrl: itemMostActiveViewer[0],
                                    placeholder:
                                        (BuildContext context, String url) =>
                                            Image.asset(
                                      'assets/icos/loader.gif',
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.pink, Colors.blue]),
                                  borderRadius: BorderRadius.circular(36)),
                            ),

                      SizedBox(
                        height: 7.0,
                      ),
                      Text(
                        itemMostActiveViewer[1].length < 13
                            ? itemMostActiveViewer[1]
                            : itemMostActiveViewer[1].substring(0, 10) + "...",
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Sections Viewed',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF868E9C)),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              itemMostActiveViewer[2],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Comments',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF868E9C)),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              itemMostActiveViewer[3],
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                              textAlign: TextAlign.right,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Container(
                      width: 1.0,
                      color: Color(0xFF272D3A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildViewerAlsoViewedChild(BuildContext context, int index) {
    final itemViewerAlsoViewed = itemsViewerAlsoViewed[index];
    return Padding(
      padding: index == 0
          ? const EdgeInsets.only(right: 10.0, left: 30)
          : const EdgeInsets.only(right: 10.0),
      child: Center(
        child: Stack(
          //fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    FadeRoute(
                        page: ViewerInit(
                            id: itemViewerAlsoViewed.id, type: "Trending")));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: itemViewerAlsoViewed.image.imageURL != null
                    ? CachedNetworkImage(
                        imageUrl: itemViewerAlsoViewed.image.imageURL,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                              'assets/icos/loader.gif',
                              height: 200,
                              width: 115,
                              fit: BoxFit.cover,
                            ),
                        height: 200,
                        width: 115,
                        fit: BoxFit.cover)
                    : Image.asset('assets/images/pic17.jpg',
                        height: 200, width: 115, fit: BoxFit.cover),
              ),
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
    );
  }
}
