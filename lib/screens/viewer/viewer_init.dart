import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/build_manager.dart';
import 'package:xenome/models/image.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:flutter/services.dart';
import 'package:xenome/screens/viewer/quadchart/quad_start.dart';
import 'package:xenome/screens/viewer/scalechart/scale_start.dart';
import 'package:xenome/firebase_services/follow_manager.dart';
import 'package:xenome/screens/viewer/textpart.dart';
import 'package:xenome/screens/viewer/instagram.dart';
import 'package:xenome/screens/viewer/viewer_cover_image.dart';
import 'package:xenome/screens/viewer/viewer_image.dart';
import 'package:xenome/screens/viewer/vimeo.dart';
import 'package:xenome/screens/viewer/youtube.dart';
import 'package:xenome/screens/viewer/filter.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/not_si/not_si_home.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/screens/profile/others_profile.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';

class ViewerInit extends StatefulWidget {
  ViewerInit({this.id, this.type});
  final String id;
  final String type;

  @override
  _ViewerInitState createState() => _ViewerInitState();
}

class _ViewerInitState extends State<ViewerInit> {
  TextEditingController editingController = TextEditingController();

  PageController _pageController;

  List<int> pages;

  CoverImageModel sendCoverImage;
  int _currentIndex;

  var pageList = [];
  int sectionNumber = 2;
  var duplicateItems = [];
  var items = [];
  var getPageOrders = [];
  var imageList = [];
  var textpartList = [];
  var youtubeList = [];
  var vimeoList = [];
  var instagramList = [];
  final sectionWidgets = List<Widget>();
  double _progress = 0;
  int _total = 0, _received = 0;


  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    // followStatus = 'Follow';
    _pageController = new PageController(initialPage: _currentIndex);
    startTimer();
    getXmapAllData();
    
  }
  
  
  void startTimer() {
    new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_progress == 1) {
            timer.cancel();
          } else {
            _progress += 0.2;
          }
        },
      ),
    );
  }

  getXmapAllData() async {
    CoverImageModel _sendCoverImage =
        await ViewerManager.getCoverImage(widget.id, widget.type);
    var _imageList = await ViewerManager.getImageAll(widget.id, widget.type);
    var _textpartList =
        await ViewerManager.getTextPartAll(widget.id, widget.type);
    var _youtubeList =
        await ViewerManager.getYoutubeAll(widget.id, widget.type);
    var _vimeoList = await ViewerManager.getVimeoAll(widget.id, widget.type);
    var _instagramList =
        await ViewerManager.getInstagramAll(widget.id, widget.type);

    setState(() {
      sendCoverImage = _sendCoverImage;
      imageList = _imageList;
      textpartList = _textpartList;
      youtubeList = _youtubeList;
      vimeoList = _vimeoList;
      instagramList = _instagramList;
    });

    getPageOrder();
  }

  getPageOrder() async {
    var _getPageOrder =
        await ViewerManager.getPageOrder(widget.id, widget.type);

    setState(() {
      getPageOrders = _getPageOrder;
    });

    var _tempPageList = [];
    _tempPageList.add({'page_name': 'FilterPage', 'sub_order': 0});
    _tempPageList.addAll(getPageOrders);
    setState(() {
      pageList = _tempPageList;
      sectionNumber = pageList.length;
    });

    for (int i = 0; i < pageList.length; i++) {
      if (pageList.length == 3) {
        if (i == 2) {
          if (pageList[2]['page_name'] == '') {
            setState(() {
              sectionNumber = pageList.length - 1;
            });
            break;
          }
        }
      }
      if (pageList[i]['page_name'] == "FilterPage") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 70,
          margin: const EdgeInsets.all(10.0),
          child: FilterPage(id: widget.id, type: widget.type),
        ));
      }
      if (pageList[i]['page_name'] == "Cover image") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewerCoverImage(
              id: widget.id,
              type: widget.type,
              pageId: i.toString(),
              data: sendCoverImage),
        ));
      }
      if (pageList[i]['page_name'] == "Image") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewerImage(
              id: widget.id,
              type: widget.type,
              subOrder: pageList[i]['sub_order'],
              pageId: i.toString(),
              data: imageList),
        ));
      }
      if (pageList[i]['page_name'] == "Text") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: TextPart(
              id: widget.id,
              type: widget.type,
              subOrder: pageList[i]['sub_order'],
              pageId: i.toString(),
              data: textpartList),
        ));
      }
      if (pageList[i]['page_name'] == "YouTube") {
        sectionWidgets.add(Container(
            width: MediaQuery.of(context).size.width - 10,
            margin: const EdgeInsets.all(10.0),
            child: YouTube(
                id: widget.id,
                type: widget.type,
                subOrder: pageList[i]['sub_order'],
                pageId: i.toString(),
                data: youtubeList)));
      }

      if (pageList[i]['page_name'] == "Vimeo") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: Vimeo(
              id: widget.id,
              type: widget.type,
              subOrder: pageList[i]['sub_order'],
              pageId: i.toString(),
              data: vimeoList),
        ));
      }

      if (pageList[i]['page_name'] == "Instagram") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: Instagram(
              id: widget.id,
              type: widget.type,
              subOrder: pageList[i]['sub_order'],
              pageId: i.toString(),
              data: instagramList),
        ));
      }
      if (pageList[i]['page_name'] == "Quad chart") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewQuadStart(
              id: widget.id,
              type: widget.type,
              subOrder: pageList[i]['sub_order'],
              pageId: i.toString()),
        ));
      }
      if (pageList[i]['page_name'] == "Scale chart") {
        sectionWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewScaleStart(
              id: widget.id,
              type: widget.type,
              subOrder: pageList[i]['sub_order'],
              pageId: i.toString()),
        ));
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  goBack() {
    Navigator.push(context, FadeRoute(page: Home()));
  }

  saveDraft() {
    BuildManager.addBuildList(SessionManager.getUserId());
    goBack();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return 
        // sendCoverImage != null
        // ? 
        Scaffold(
            backgroundColor: Colors.black87,
            appBar: PreferredSize(
              preferredSize: Size(null, 50),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
                ]),
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new GestureDetector(
                            child: Text(
                              (_currentIndex + 1).toString() +
                                  ' / ' +
                                  sectionNumber.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto Medium',
                                color: Color(0xFF868E9C),
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              if (SessionManager.getUserId() == '') {
                                Navigator.push(
                                    context, FadeRoute(page: NotSiHome()));
                              } else {
                                Navigator.push(
                                    context, FadeRoute(page: Home()));
                              }
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: new PageView(
                controller: _pageController,
                onPageChanged: _onPageViewChange,
                children: <Widget>[] + sectionWidgets));
        // : Scaffold(
        //     backgroundColor: Colors.black,
        //     body: Container(
        //       child: Padding(
        //           padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
        //           child: Column(
        //             children: <Widget>[
        //               Container(
        //                 margin: EdgeInsets.fromLTRB(20,
        //                     MediaQuery.of(context).size.height * 0.2, 20, 0),
        //                 child: Image.asset('assets/icos/wait.gif',
        //                     width: 250, height: 250),
        //               ),
        //               Container(
        //                 margin: EdgeInsets.fromLTRB(20, 10, 20, 140),
        //                 child: Text(
        //                   'Explore each page by scrolling left and right, create collections for future reference and have your say while providing valuable feedback',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Color(0xFF868E9C),
        //                     fontSize: 13,
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                   padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
        //                   child: SizedBox(
        //                       height: 3.0,
        //                       width: 300.0,
        //                       child: LinearProgressIndicator(
        //                         valueColor:
        //                             AlwaysStoppedAnimation(Colors.white),
        //                         backgroundColor: Color(0xFF13161D),
        //                         value: _progress,
        //                       ))),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
        //                 child: Text(
        //                   'LOADING',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Color(0xFF868E9C),
        //                     fontSize: 12,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           )),
        //     ));
  }

  _onPageViewChange(int page) {
    setState(() {
      _currentIndex = page;
    });
  }
}
