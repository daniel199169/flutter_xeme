import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/page_order.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/screens/builder/cover_image.dart';
import 'package:xenome/screens/builder/image.dart';
import 'package:xenome/screens/builder/textpart.dart';
import 'package:xenome/screens/builder/youtube.dart';
import 'package:xenome/screens/builder/vimeo.dart';
import 'package:xenome/screens/builder/instagram.dart';
import 'package:xenome/screens/builder/quad_chart.dart';
import 'package:xenome/screens/builder/scale_chart.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mailer2/mailer.dart';

class BuilderStarter extends StatefulWidget {
  BuilderStarter({this.id, this.type});
  final String id;
  final String type;
  @override
  _BuilderStarterState createState() => _BuilderStarterState();
}

class _BuilderStarterState extends State<BuilderStarter> {
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController emailController;

  String _title;
  String _description;
  String _email;

  SetupInfo setupInfo;
  List<PageOrder> pageOrder = [];
  List<Widget> myPageOrderWidgets = List<Widget>();
  List<Widget> _myPageOrderWidgets = List<Widget>();

  bool isSwitched = true;

  String _linkMessage;
  bool _isCreatingLink = false;

  @override
  void initState() {
    super.initState();

    setupInfo = new SetupInfo(title: "", description: "");
    titleController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");

    getSetupInfo();
    _createDynamicLink();
  }

  Future<void> _createDynamicLink() async {
    setState(() {
      _isCreatingLink = true;
    });
    var parseUrl = "https://xenome.page.link/" + widget.id;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://xenome.page.link',
      link: Uri.parse(parseUrl),
      androidParameters: AndroidParameters(
        packageName: 'io.flutter.plugins.firebasedynamiclinksexample',
        minimumVersion: 1,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.scott.xenome',
        appStoreId: '1514995283',
        minimumVersion: '1.0.0',
      ),
    );

    Uri url;
    // if (short) {
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;
    // } else {
    //   url = await parameters.buildUrl();
    // }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });

  }

  getSetupInfo() async {
    SetupInfo _getSetupInfo =
        await BuildderManager.getSetupInfo(widget.id, widget.type);
    setState(() {
      setupInfo = _getSetupInfo;
      titleController = TextEditingController(text: setupInfo.title);
      descriptionController =
          TextEditingController(text: setupInfo.description);

      _title = setupInfo.title;
      _description = setupInfo.description;
    });

    getPageOrder();
  }

  getPageOrder() async {
    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, widget.type);

    setState(() {
      pageOrder = _pageOrderList;
    });

    _myPageOrderWidgets = [];

    for (int i = 1; i < pageOrder.length; i++) {
      _myPageOrderWidgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pageOrder[i].pageName == 'Image') {
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: MyImage(
                                      id: widget.id,
                                      type: "Buildder",
                                      subOrder: pageOrder[i].subOrder)));
                        }
                        if (pageOrder[i].pageName == 'Text') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TextPart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'YouTube') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Youtube(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Vimeo') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Vimeo(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Instagram') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Instagram(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Quad chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QuadChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Scale chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ScaleChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 5.0, 0.0),
                        child: Text(pageOrder[i].pageName,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFF868E9C),
                              fontSize: 16,
                            )),
                      ),
                    ),
                    flex: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: IconTheme(
                        data: new IconThemeData(color: Color(0xFF868E9C)),
                        child: new IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Color(0xFF868E9C)),
                            onPressed: () {
                              if (pageOrder[i].pageName == 'Image') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MyImage(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Text') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TextPart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'YouTube') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Youtube(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Vimeo') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Vimeo(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Quad chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuadChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }

                              if (pageOrder[i].pageName == 'Scale chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ScaleChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Instagram') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Instagram(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                            }),
                      ),
                    ),
                    flex: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                    child: IconTheme(
                      data: new IconThemeData(color: Color(0xFF868E9C)),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: new BorderSide(color: Color(0xFF272D3A))),
                        itemBuilder: (_) => i != 0
                            ? <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Up',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveUp',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ]
                            : <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ],
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Color(0xFF868E9C)),
                        onSelected: (value) {
                          if (value == "DeleteSection") {
                            deleteSection(i);
                          } else if (value == "MoveUp") {
                            moveUp(i);
                          } else if (value == "MoveDown") {
                            moveDown(i);
                          }
                        },
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),
            ],
          )));
    }

    setState(() {
      myPageOrderWidgets = [];
      myPageOrderWidgets = _myPageOrderWidgets;
    });
  }

  _saveSetupInfo() async {
    if (_title != '' && _description != '') {
      SetupInfo _new = new SetupInfo(
        title: _title,
        description: _description,
        global: isSwitched == true ? 'public' : 'private',
        privateEmailList: _email,
      );
      await BuildderManager.saveSetupInfo(widget.id, widget.type, _new);
    }
  }

  close() async {
    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Buildder");
  }

  goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  addImage(String pageName) async {
    await BuildderManager.addSectionPage(widget.id, widget.type, pageName);

    String subOrder = await BuildderManager.getSubOrderFromCollection(
        widget.id, widget.type, pageName);

    await BuildderManager.addPageOrderInBuildder(
        widget.id, widget.type, pageName, subOrder);

    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, widget.type);

    setState(() {
      pageOrder = [];
      pageOrder = _pageOrderList;
    });

    _myPageOrderWidgets = [];

    for (int i = 1; i < pageOrder.length; i++) {
      _myPageOrderWidgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pageOrder[i].pageName == 'Image') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MyImage(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Text') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TextPart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'YouTube') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Youtube(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Vimeo') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Vimeo(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Instagram') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Instagram(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Quad chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QuadChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Scale chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ScaleChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 5.0, 0.0),
                        child: Text(pageOrder[i].pageName,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFF868E9C),
                              fontSize: 16,
                            )),
                      ),
                    ),
                    flex: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: IconTheme(
                        data: new IconThemeData(color: Color(0xFF868E9C)),
                        child: new IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Color(0xFF868E9C)),
                            onPressed: () {
                              if (pageOrder[i].pageName == 'Image') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MyImage(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Text') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TextPart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'YouTube') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Youtube(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Vimeo') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Vimeo(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Quad chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuadChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }

                              if (pageOrder[i].pageName == 'Scale chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ScaleChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Instagram') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Instagram(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                            }),
                      ),
                    ),
                    flex: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                    child: IconTheme(
                      data: new IconThemeData(color: Color(0xFF868E9C)),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: new BorderSide(color: Color(0xFF272D3A))),
                        itemBuilder: (_) => i != 0
                            ? <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Up',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveUp',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ]
                            : <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ],
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Color(0xFF868E9C)),
                        onSelected: (value) {
                          if (value == "DeleteSection") {
                            deleteSection(i);
                          } else if (value == "MoveUp") {
                            moveUp(i);
                          } else if (value == "MoveDown") {
                            moveDown(i);
                          }
                        },
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),
            ],
          )));
    }

    setState(() {
      myPageOrderWidgets = [];
      myPageOrderWidgets = _myPageOrderWidgets;
    });
  }

  moveUp(int localPageOrder) async {
    await BuildderManager.moveUpPages(widget.id, widget.type, localPageOrder);
    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, widget.type);

    setState(() {
      pageOrder = [];
      pageOrder = _pageOrderList;
    });

    _myPageOrderWidgets = [];

    for (int i = 1; i < pageOrder.length; i++) {
      _myPageOrderWidgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pageOrder[i].pageName == 'Image') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MyImage(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Text') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TextPart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'YouTube') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Youtube(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Vimeo') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Vimeo(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Instagram') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Instagram(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Quad chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QuadChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Scale chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ScaleChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 5.0, 0.0),
                        child: Text(pageOrder[i].pageName,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFF868E9C),
                              fontSize: 16,
                            )),
                      ),
                    ),
                    flex: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: IconTheme(
                        data: new IconThemeData(color: Color(0xFF868E9C)),
                        child: new IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Color(0xFF868E9C)),
                            onPressed: () {
                              if (pageOrder[i].pageName == 'Image') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MyImage(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Text') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TextPart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'YouTube') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Youtube(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Vimeo') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Vimeo(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Quad chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuadChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }

                              if (pageOrder[i].pageName == 'Scale chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ScaleChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Instagram') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Instagram(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                            }),
                      ),
                    ),
                    flex: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                    child: IconTheme(
                      data: new IconThemeData(color: Color(0xFF868E9C)),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: new BorderSide(color: Color(0xFF272D3A))),
                        itemBuilder: (_) => i != 0
                            ? <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Up',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveUp',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ]
                            : <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ],
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Color(0xFF868E9C)),
                        onSelected: (value) {
                          if (value == "DeleteSection") {
                            deleteSection(i);
                          } else if (value == "MoveUp") {
                            moveUp(i);
                          } else if (value == "MoveDown") {
                            moveDown(i);
                          }
                        },
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),
            ],
          )));
    }

    setState(() {
      myPageOrderWidgets = [];
      myPageOrderWidgets = _myPageOrderWidgets;
    });
  }

  moveDown(int localPageOrder) async {
    await BuildderManager.moveDownPages(widget.id, widget.type, localPageOrder);
    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, widget.type);

    setState(() {
      pageOrder = [];
      pageOrder = _pageOrderList;
    });

    _myPageOrderWidgets = [];

    for (int i = 1; i < pageOrder.length; i++) {
      _myPageOrderWidgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pageOrder[i].pageName == 'Image') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MyImage(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Text') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TextPart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'YouTube') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Youtube(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Vimeo') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Vimeo(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Instagram') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Instagram(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Quad chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QuadChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Scale chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ScaleChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 5.0, 0.0),
                        child: Text(pageOrder[i].pageName,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFF868E9C),
                              fontSize: 16,
                            )),
                      ),
                    ),
                    flex: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: IconTheme(
                        data: new IconThemeData(color: Color(0xFF868E9C)),
                        child: new IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Color(0xFF868E9C)),
                            onPressed: () {
                              if (pageOrder[i].pageName == 'Image') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MyImage(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Text') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TextPart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'YouTube') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Youtube(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Vimeo') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Vimeo(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Quad chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuadChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }

                              if (pageOrder[i].pageName == 'Scale chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ScaleChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Instagram') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Instagram(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                            }),
                      ),
                    ),
                    flex: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                    child: IconTheme(
                      data: new IconThemeData(color: Color(0xFF868E9C)),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: new BorderSide(color: Color(0xFF272D3A))),
                        itemBuilder: (_) => i != 0
                            ? <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Up',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveUp',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ]
                            : <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ],
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Color(0xFF868E9C)),
                        onSelected: (value) {
                          if (value == "DeleteSection") {
                            deleteSection(i);
                          } else if (value == "MoveUp") {
                            moveUp(i);
                          } else if (value == "MoveDown") {
                            moveDown(i);
                          }
                        },
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),
            ],
          )));
    }

    setState(() {
      myPageOrderWidgets = [];
      myPageOrderWidgets = _myPageOrderWidgets;
    });
  }

  saveDraft() async {
    await BuildderManager.saveDraft(
        SessionManager.getUserId(), widget.id, widget.type);

    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, widget.type);
  }

  publish() async {
    await BuildderManager.publish(
        SessionManager.getUserId(), widget.id, widget.type, _linkMessage);

    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, widget.type);

    if (isSwitched == false) {
      if (_email != '') {
        var _temparry = _email.split(",");
        for (int j = 0; j < _temparry.length; j++) {
          send_email(_temparry[j].trim());
        }
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  deleteSection(int localPageOrder) async {
    String localSubOrder = await BuildderManager.getSpecialPageOrder(
        widget.id, widget.type, localPageOrder);

    await BuildderManager.deleteSection(
        SessionManager.getUserId(),
        widget.id,
        widget.type,
        pageOrder[localPageOrder].pageName,
        localPageOrder,
        int.parse(localSubOrder));

    await BuildderManager.deleteFromSection(
        SessionManager.getUserId(),
        widget.id,
        "Buildder",
        pageOrder[localPageOrder].pageName,
        localPageOrder,
        int.parse(localSubOrder));

    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, widget.type);

    setState(() {
      pageOrder = [];
      pageOrder = _pageOrderList;
    });

    _myPageOrderWidgets = [];

    for (int i = 1; i < pageOrder.length; i++) {
      _myPageOrderWidgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pageOrder[i].pageName == 'Image') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MyImage(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Text') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TextPart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'YouTube') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Youtube(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                        if (pageOrder[i].pageName == 'Vimeo') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Vimeo(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Instagram') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Instagram(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Quad chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QuadChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }

                        if (pageOrder[i].pageName == 'Scale chart') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ScaleChart(
                                    id: widget.id,
                                    type: "Buildder",
                                    subOrder: pageOrder[i].subOrder)),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 5.0, 0.0),
                        child: Text(pageOrder[i].pageName,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFF868E9C),
                              fontSize: 16,
                            )),
                      ),
                    ),
                    flex: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: IconTheme(
                        data: new IconThemeData(color: Color(0xFF868E9C)),
                        child: new IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Color(0xFF868E9C)),
                            onPressed: () {
                              if (pageOrder[i].pageName == 'Image') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MyImage(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Text') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TextPart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'YouTube') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Youtube(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Vimeo') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Vimeo(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Quad chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuadChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }

                              if (pageOrder[i].pageName == 'Scale chart') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ScaleChart(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                              if (pageOrder[i].pageName == 'Instagram') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Instagram(
                                          id: widget.id,
                                          type: "Buildder",
                                          subOrder: pageOrder[i].subOrder)),
                                );
                              }
                            }),
                      ),
                    ),
                    flex: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                    child: IconTheme(
                      data: new IconThemeData(color: Color(0xFF868E9C)),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: new BorderSide(color: Color(0xFF272D3A))),
                        itemBuilder: (_) => i != 0
                            ? <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Up',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveUp',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ]
                            : <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  child: Text('Delete',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'DeleteSection',
                                  height: 40,
                                ),
                                new PopupMenuItem<String>(
                                  child: Text('Move Down',
                                      style:
                                          TextStyle(color: Color(0xFF868E9C))),
                                  value: 'MoveDown',
                                  height: 40,
                                ),
                              ],
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Color(0xFF868E9C)),
                        onSelected: (value) {
                          if (value == "DeleteSection") {
                            deleteSection(i);
                          } else if (value == "MoveUp") {
                            moveUp(i);
                          } else if (value == "MoveDown") {
                            moveDown(i);
                          }
                        },
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),
            ],
          )));
    }

    setState(() {
      myPageOrderWidgets = [];
      myPageOrderWidgets = _myPageOrderWidgets;
    });
  }

  deleteEntireXmap() async {
    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, widget.type);
  }

  send_email(String emailReciever) async {
    // String username = "wanghuajinksh@gmail.com"; //Your Email;
    // String password = "gtpzwarwxndzgzyl"; //Your Email's password;

    var options = new GmailSmtpOptions()
      ..username = 'wanghuajinksh@gmail.com'
      ..password =
          'gtpzwarwxndzgzyl'; // Note: if you have Google's "app specific passwords" enabled,
    // you need to use one of those here.

    // How you use and store passwords is up to you. Beware of storing passwords in plain.

    // Create our email transport.
    var emailTransport = new SmtpTransport(options);

    // Create our mail/envelope.
    var envelope = new Envelope()
      ..from = 'foo@bar.com'
      ..recipients.add(emailReciever)
      ..bccRecipients.add('hidden@recipient.com')
      ..subject = 'You have been invited by Tourism Australia'
      // ..attachments.add(new Attachment(file: new File('path/to/file')))
      ..text = 'This is a cool email message. Whats up?'
      ..html = '''<!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Document</title>
                </head>
                <body style="padding-bottom: 30px; padding-top: 30px; padding-left: 30px; padding-right: 30px; background-color: grey;">
                    <center>
                        <div class = "main" style = "max-width: 600px; background-color: white; padding-bottom: 30px; padding-top: 30px; padding-left: 30px; padding-right: 30px;">
                    <div class="top_image"><img src = "http://xenome.app/title.jpg" style="width: 300px; height: 100px;"/></div>
                    <div><h2 style = "color: #014367;margin-bottom: 5px;
                        margin-top: 5px;">
                         Hi Pavlo,  you have been invited by 
                    </h2>
                <h2 style = "color: #014367;margin-bottom: 5px;
                margin-top: 5px;">Tourism Australia to participate in an </h2>
                    <h2 style = "color: #014367;margin-bottom: 5px;
                    margin-top: 5px;">experience map</h2>
                </div>
                <button style="background: white; padding-left: 30px; padding-right: 30px; padding-top: 20px; padding-bottom: 20px; border: 1px solid#014367; border-radius: 20px; width: 50%; height: 55px; font-size: 16px; margin-top: 20px; margin-bottom: 20px;">View experience map</button>
                <p style = "color: #014367;">Download in <a style = "color: #014367;" href="https://appstore.com">App store</a> or <a style = "color: #014367;" href="https://appstore.com">Google Play</a></p>
                </div>

                <div class="footer">
                    <p style="margin-top: 30px; margin-bottom: 30px; font-size: 14px;"><span style="padding-left: 3px; padding-right: 3px; padding-top: 5px; padding-bottom: 5px; border: 1px solid #014367;font-size: 14px;color:black; border-radius: 2px;">X</span> &nbsp;E &nbsp;N &nbsp;O &nbsp;M &nbsp;E</p>
                    <P style="font-size: 12px;">@ 2020 Freelancer Technology PTY Limited . All RIghts Reserved.</P>
                    <p style="font-size: 12px;">Level 20, 680 George Street, Sydney, NSW 2000, Australia</p>
                    <p style="font-size: 12px;margin: 20px;"><a style="color:black" href="#">Privacy Policy</a> | <a style="color:black"href="#">Terms and Conditions</a> | <a style="color:black" href="#">Unsubscribe</a> | <a href="#" style="color:black">Get Support</a> | <a style="color:black" href="#">Get Free Credit</a></p>
                    
                    
                      <a href=""> <img style= "width: 20px; height: 20px; " src="https://img.icons8.com/ios-glyphs/30/000000/facebook-f.png" /></a>&nbsp; &nbsp; 
                      <a href=""><img style= "width: 20px; height: 20px; color: grey;"  src="https://img.icons8.com/android/24/000000/twitter.png" /></a> &nbsp; &nbsp; 
                        <a href=""><img src="https://img.icons8.com/metro/24/000000/instagram-new.png" style= "width: 20px; height: 20px; color: grey;" /></a>
                    
                        &nbsp; &nbsp; <span style="font-size: 14px;
                                margin-right: 5px;"> our mobile app </span>
                  
                        <a href=""><img src="https://img.icons8.com/metro/26/000000/android-os.png" style= "width: 20px; height: 20px; color: grey;" /></a>
                        <a href=""><img style= "width: 20px; height: 20px; color: grey;"  src="https://img.icons8.com/ios-glyphs/30/000000/mac-os--v1.png"/></a>&nbsp;
                    

                </div>

                </center>
                </body>
                </html>''';

    // Email it.
    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
    // final smtpServer = gmail(username, password);
    // // Creating the Gmail server

    // // Create our email message.
    // final message = Message()
    //   ..from = Address(username)
    //   ..recipients.add('dest@example.com') //recipent email
    //   ..ccRecipients.addAll(
    //       ['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
    //   ..bccRecipients
    //       .add(Address('bccAddress@example.com')) //bcc Recipents emails
    //   ..subject =
    //       'Test Dart Mailer library :: 😀 :: ${DateTime.now()}' ;//subject of the email
    // ..text =
    //     'This is the plain text.\nThis is line 2 of the text part.' //body of the email
    // ..isHTML = true;

    // message.html = '''kghjkhklj''';
    // try {
    //   final sendReport = await send(message, smtpServer);
    //   print('Message sent: ' +
    //       sendReport.toString()); //print if the email is sent
    // } on MailerException catch (e) {
    //   print('Message not sent. \n' +
    //       e.toString()); //print if the email is not sent
    //   // e.toString() will show why the email is not sending
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: PreferredSize(
        preferredSize: Size(null, 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1.0),
            child: Container(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.fromLTRB(25, 50, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: new BorderSide(color: Color(0xFF272D3A))),
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                          child: Text('Close',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'Close',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Save and close',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'SaveAndClose',
                          height: 40,
                        ),
                      ],
                      icon:
                          Icon(Icons.close, size: 22, color: Color(0xFF868E9C)),
                      onSelected: (value) async {
                        if (value == "Close") {
                          close();
                          goBack();
                        } else if (value == "SaveAndClose") {
                          CoverImageModel _checkCoverImage =
                              await BuildderManager.checkCoverImage(
                                  SessionManager.getUserId(),
                                  widget.id,
                                  widget.type);

                          if (_title != '' && _description != '') {
                            if (_checkCoverImage != null) {
                              if (_checkCoverImage.imageURL != '') {
                                saveDraft();
                                goBack();
                              } else {
                                await AlertShowDialog(context,
                                    title: "Build Alert",
                                    content: "Please enter cover image !");
                              }
                            } else {
                              await AlertShowDialog(context,
                                  title: "Build Alert",
                                  content: "Please enter cover image !");
                            }
                          } else {
                            await AlertShowDialog(context,
                                title: "Build Alert",
                                content:
                                    "Please enter Title and Description !");
                          }
                        }
                      },
                      color: Colors.black,
                    ),
                    PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: new BorderSide(color: Color(0xFF272D3A))),
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                          child: Text('Publish',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'Publish',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Delete',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'DelEntireXmap',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add image',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddImage',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add text',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddText',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add quad chart',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddQuadChart',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add scale',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddScale',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add YouTube',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddYouTube',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add Vimeo',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddVimeo',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add Instagram',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddInstagram',
                          height: 40,
                        ),
                        new PopupMenuItem<String>(
                          child: Text('Add HTML',
                              style: TextStyle(color: Color(0xFF868E9C))),
                          value: 'AddHTML',
                          height: 40,
                        ),
                      ],
                      icon: Icon(Icons.more_horiz,
                          size: 25, color: Color(0xFF868E9C)),
                      onSelected: (value) async {
                        if (value == "Publish") {
                          CoverImageModel _checkCoverImage =
                              await BuildderManager.checkCoverImage(
                                  SessionManager.getUserId(),
                                  widget.id,
                                  widget.type);

                          if (_title != '' && _description != '') {
                            if (_checkCoverImage != null) {
                              if (_checkCoverImage.imageURL != '') {
                                publish();
                                goBack();
                              } else {
                                await AlertShowDialog(context,
                                    title: "Build Alert",
                                    content: "Please enter cover image !");
                              }
                            } else {
                              await AlertShowDialog(context,
                                  title: "Build Alert",
                                  content: "Please enter cover image !");
                            }
                          } else {
                            await AlertShowDialog(context,
                                title: "Build Alert",
                                content:
                                    "Please enter Title and Description !");
                          }
                        } else if (value == "DelEntireXmap") {
                          deleteEntireXmap();
                          goBack();
                        } else if (value == "AddImage") {
                          addImage('Image');
                        } else if (value == "AddText") {
                          addImage("Text");
                        } else if (value == "AddQuadChart") {
                          addImage("Quad chart");
                        } else if (value == "AddScale") {
                          addImage("Scale chart");
                        } else if (value == "AddYouTube") {
                          addImage("YouTube");
                        } else if (value == "AddVimeo") {
                          addImage("Vimeo");
                        } else if (value == "AddInstagram") {
                          addImage("Instagram");
                        } else if (value == "AddHTML") {}
                      },
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.only(bottom: 60),
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                    Container(
                      // margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: 30, left: 40, right: 40, bottom: 30),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: titleController,
                                    autovalidate: true,
                                    maxLines: 1,
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: false,
                                    style: TextStyle(
                                      fontFamily: 'Roboto Reqular',
                                      color: Color(0xFFFFFFFF),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF868E9C),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFFFFFFFF),
                                            style: BorderStyle.solid),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFF868E9C),
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    onSaved: (String value) {},
                                    onChanged: (value) {
                                      _title = value.trim();
                                    },
                                    onFieldSubmitted: (titleController) {
                                      _saveSetupInfo();
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: descriptionController,
                                    maxLines: 3,
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: false,
                                    style: TextStyle(
                                      fontFamily: 'Roboto Reqular',
                                      color: Color(0xFFFFFFFF),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF868E9C),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFFFFFFFF),
                                            style: BorderStyle.solid),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFF868E9C),
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      _description = value.trim();
                                    },
                                    onFieldSubmitted: (descriptionController) {
                                      _saveSetupInfo();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0, left: 5, right: 5),
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                            height: 1,
                            color: Color(0xFF272D3A),
                          ),
                          Container(
                              child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => CoverImage(
                                                id: widget.id,
                                                type: widget.type)),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 5.0, 0.0),
                                      child: Text("Cover image",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Color(0xFF868E9C),
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                  flex: 12,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: IconTheme(
                                      data: new IconThemeData(
                                          color: Color(0xFF868E9C)),
                                      child: new IconButton(
                                          icon: Icon(Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Color(0xFF868E9C)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => CoverImage(
                                                      id: widget.id,
                                                      type: widget.type)),
                                            );
                                          }),
                                    ), // myIcon is a 48px-wide widget.
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          )),
                          Container(
                            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                            height: 1,
                            color: Color(0xFF272D3A),
                          ),
                        ],
                      ),
                    ),
                  ] +
                  myPageOrderWidgets +
                  <Widget>[
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 30.0, 30.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CoverImage(
                                          id: widget.id, type: widget.type)),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0.0, 0.0),
                                child: Text("Public",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color(0xFF868E9C),
                                      fontSize: 16,
                                    )),
                              ),
                            ),
                            flex: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 0, 0.0, 0.0),
                              child: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                  });
                                },
                                activeTrackColor: Colors.lightBlue,
                                activeColor: Colors.white,
                              ),
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.only(
                          left: 40, top: 10, right: 40, bottom: 10),
                      child: isSwitched == false
                          ? TextFormField(
                              controller: emailController,
                              autovalidate: true,
                              maxLines: 4,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: false,
                              style: TextStyle(
                                fontFamily: 'Roboto Reqular',
                                color: Color(0xFFFFFFFF),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email List',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF868E9C),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFFFFFFFF),
                                      style: BorderStyle.solid),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF868E9C),
                                      style: BorderStyle.solid),
                                ),
                              ),
                              onSaved: (String value) {},
                              onChanged: (value) {
                                _email = value.trim();
                              },
                              onFieldSubmitted: (emailController) {
                                _saveSetupInfo();
                              },
                            )
                          : Container(),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 40, top: 20, right: 40, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _linkMessage ?? '',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFF868E9C),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 40, top: 10, right: 40, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                              child: Text("Copy link",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                              onTap: () async {
                                Clipboard.setData(
                                    ClipboardData(text: _linkMessage));
                                Scaffold.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied Link!')),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
