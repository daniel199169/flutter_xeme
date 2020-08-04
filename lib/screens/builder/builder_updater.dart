import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/page_order.dart';
import 'package:xenome/models/cover_image.dart';
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

class BuilderUpdater extends StatefulWidget {
  BuilderUpdater({this.id, this.type});
  final String id;
  final String type;
  @override
  _BuilderUpdaterState createState() => _BuilderUpdaterState();
}

class _BuilderUpdaterState extends State<BuilderUpdater> {
  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController emailController;
  ScrollController _scrollcontroller = ScrollController();

  String _title;
  String _description;
  String _email;
  String xmapType = '';
  String dynamiclink = '';
  bool isSwitched = true;

  SetupInfo setupInfo;
  List<PageOrder> pageOrder = [];
  List<Widget> myPageOrderWidgets = List<Widget>();
  List<Widget> _myPageOrderWidgets = List<Widget>();

  @override
  void initState() {
    super.initState();

    setupInfo = new SetupInfo(
        title: "", description: "", global: "", privateEmailList: "");
    titleController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
    addNewBuilder();

    if (widget.type == "SavedDraft") {
      getXmapType();
    }
  }

  _saveSetupInfo() async {
    if (_title != '' && _description != '') {
      SetupInfo _new = new SetupInfo(
          title: _title,
          description: _description,
          global: isSwitched == true ? 'public' : 'private',
          privateEmailList: _email);
      await BuildderManager.saveSetupInfo(widget.id, "Buildder", _new);
    }
  }

  goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  addImage(String pageName) async {
    await BuildderManager.addSectionPage(widget.id, "Buildder", pageName);

    String subOrder = await BuildderManager.getSubOrderFromCollection(
        widget.id, "Buildder", pageName);

    await BuildderManager.addPageOrderInBuildder(
        widget.id, "Buildder", pageName, subOrder);

    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, "Buildder");

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
    await BuildderManager.moveUpPages(widget.id, "Buildder", localPageOrder);
    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, "Buildder");
    print("++++++ 00000 ++++++");
    print(_pageOrderList[1].pageName);
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
    await BuildderManager.moveDownPages(widget.id, "Buildder", localPageOrder);
    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, "Buildder");

    print("++++++ 11111 ++++++");
    print(_pageOrderList[1].pageName);

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
    await BuildderManager.saveDraftForBuilderUpdater(
        SessionManager.getUserId(), widget.id, "Buildder");

    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Buildder");
  }

  publish() async {
    await BuildderManager.publishForEdit(SessionManager.getUserId(), widget.id);

    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Buildder");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  update() async {
    await BuildderManager.updateXmap(SessionManager.getUserId(), widget.id);

    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Buildder");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  close() async {
    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Buildder");
  }

  deleteSection(int localPageOrder) async {
    String localSubOrder = await BuildderManager.getSpecialPageOrder(
        widget.id, "Buildder", localPageOrder);

    await BuildderManager.deleteSection(
        SessionManager.getUserId(),
        widget.id,
        "Buildder",
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
        await BuildderManager.getPageOrder(widget.id, "Buildder");

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
    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "SavedDraft");
    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Trending");
    await BuildderManager.deleteEntireXmap(
        SessionManager.getUserId(), widget.id, "Mylist");
    await BuildderManager.deleteFromXmapInfo(
        SessionManager.getUserId(), widget.id, "XmapInfo");
    await BuildderManager.deleteFromComments(
        SessionManager.getUserId(), widget.id, "Comments");
  }

  getXmapType() async {
    String _xmapType = await BuildderManager.getXmapType(widget.id);
    setState(() {
      xmapType = _xmapType;
    });
  }

  addNewBuilder() async {
    await BuildderManager.addNewBuilder(widget.id, widget.type);
    getPageOrder();
    getSetupInfo();
    getDynamicLink();
  }

  getDynamicLink() async {
    String _dynamiclink = await BuildderManager.getDynammicLink(
        widget.type, SessionManager.getUserId(), widget.id);

    setState(() {
      dynamiclink = _dynamiclink;
    });
  }

  getSetupInfo() async {
    SetupInfo _getSetupInfo =
        await BuildderManager.getSetupInfo(widget.id, "Buildder");
    setState(() {
      setupInfo = _getSetupInfo;
      titleController = TextEditingController(text: setupInfo.title);
      descriptionController =
          TextEditingController(text: setupInfo.description);
      emailController = TextEditingController(text: setupInfo.privateEmailList);
      _title = setupInfo.title;
      _description = setupInfo.description;
      _email = setupInfo.privateEmailList;

      isSwitched = setupInfo.global == 'public' ? true : false;
    });
  }

  getPageOrder() async {
    List<PageOrder> _pageOrderList =
        await BuildderManager.getPageOrder(widget.id, "Buildder");

    setState(() {
      pageOrder = _pageOrderList;
    });

    for (int i = 1; i < pageOrder.length; i++) {
      myPageOrderWidgets.add(Padding(
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
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 500),
        () => _scrollcontroller
            .jumpTo(_scrollcontroller.position.maxScrollExtent));
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
                    xmapType == 'published'
                        ? PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: new BorderSide(color: Color(0xFF272D3A))),
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              new PopupMenuItem<String>(
                                child: Text('Update',
                                    style: TextStyle(color: Color(0xFF868E9C))),
                                value: 'Update',
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
                              // new PopupMenuItem<String>(
                              //   child: Text('Add HTML',
                              //       style: TextStyle(color: Color(0xFF868E9C))),
                              //   value: 'AddHTML',
                              //   height: 40,
                              // ),
                            ],
                            icon: Icon(Icons.more_horiz,
                                size: 25, color: Color(0xFF868E9C)),
                            onSelected: (value) async {
                              if (value == "Update") {
                                if (_title != '' && _description != '') {
                                  update();
                                  goBack();
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
                              }
                              // else if (value == "AddHTML") {}
                            },
                            color: Colors.black,
                          )
                        : PopupMenuButton(
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
                              // new PopupMenuItem<String>(
                              //   child: Text('Add HTML',
                              //       style: TextStyle(color: Color(0xFF868E9C))),
                              //   value: 'AddHTML',
                              //   height: 40,
                              // ),
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
                                          content:
                                              "Please enter cover image !");
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
          controller: _scrollcontroller,
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
                                                type: "Buildder")),
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
                                                      type: "Buildder")),
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
                                onChanged: (value) async {
                                  setState(() {
                                    isSwitched = value;
                                  });
                                  if (isSwitched == false) {
                                    await BuildderManager.setGlobal(
                                        "private", widget.id, "Trending");
                                  } else {
                                    await BuildderManager.setGlobal(
                                        "public", widget.id, "Trending");
                                  }
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
                          Text(dynamiclink,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xFF868E9C),
                                fontSize: 16,
                              )),
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
                                    ClipboardData(text: dynamiclink));
                                Scaffold.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied Link!')),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
            ),
            // Container(
            //   padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            //   constraints: const BoxConstraints(maxHeight: 460.0),
            //   child: pageOrder.length == 1 && pageOrder[0].pageName == ''
            //       ? Container()
            //       : new ListView.builder(
            //           itemCount: pageOrder.length,
            //           scrollDirection: Axis.vertical,
          ],
        ),
      ),
    );
  }

  // Widget _buildPageList(BuildContext context, int index) {
  //   return index != 0
  //       ? new Padding(
  //           padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: <Widget>[
  //                   Expanded(
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         if (pageOrder[index].pageName == 'Image') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => MyImage(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }
  //                         if (pageOrder[index].pageName == 'Text') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => TextPart(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }
  //                         if (pageOrder[index].pageName == 'YouTube') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => Youtube(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }
  //                         if (pageOrder[index].pageName == 'Vimeo') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => Vimeo(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }

  //                         if (pageOrder[index].pageName == 'Instagram') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => Instagram(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }

  //                         if (pageOrder[index].pageName == 'Quad chart') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => QuadChart(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }

  //                         if (pageOrder[index].pageName == 'Scale chart') {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (_) => ScaleChart(
  //                                     id: widget.id,
  //                                     type: "Buildder",
  //                                     subOrder: pageOrder[index].subOrder)),
  //                           );
  //                         }
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.fromLTRB(40, 0, 5.0, 0.0),
  //                         child: Text(pageOrder[index].pageName,
  //                             style: TextStyle(
  //                               fontFamily: 'Roboto',
  //                               color: Color(0xFF868E9C),
  //                               fontSize: 16,
  //                             )),
  //                       ),
  //                     ),
  //                     flex: 10,
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
  //                       child: IconTheme(
  //                         data: new IconThemeData(color: Color(0xFF868E9C)),
  //                         child: new IconButton(
  //                             icon: Icon(Icons.arrow_forward_ios,
  //                                 size: 16, color: Color(0xFF868E9C)),
  //                             onPressed: () {
  //                               if (pageOrder[index].pageName == 'Image') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => MyImage(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }
  //                               if (pageOrder[index].pageName == 'Text') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => TextPart(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }
  //                               if (pageOrder[index].pageName == 'YouTube') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => Youtube(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }
  //                               if (pageOrder[index].pageName == 'Vimeo') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => Vimeo(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }
  //                               if (pageOrder[index].pageName == 'Quad chart') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => QuadChart(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }

  //                               if (pageOrder[index].pageName ==
  //                                   'Scale chart') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => ScaleChart(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }
  //                               if (pageOrder[index].pageName == 'Instagram') {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (_) => Instagram(
  //                                           id: widget.id,
  //                                           type: "Buildder",
  //                                           subOrder:
  //                                               pageOrder[index].subOrder)),
  //                                 );
  //                               }
  //                             }),
  //                       ),
  //                     ),
  //                     flex: 2,
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
  //                     child: IconTheme(
  //                       data: new IconThemeData(color: Color(0xFF868E9C)),
  //                       child: PopupMenuButton(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(15.0),
  //                             side: new BorderSide(color: Color(0xFF272D3A))),
  //                         itemBuilder: (_) => index != 0
  //                             ? <PopupMenuItem<String>>[
  //                                 new PopupMenuItem<String>(
  //                                   child: Text('Delete',
  //                                       style: TextStyle(
  //                                           color: Color(0xFF868E9C))),
  //                                   value: 'DeleteSection',
  //                                   height: 40,
  //                                 ),
  //                                 new PopupMenuItem<String>(
  //                                   child: Text('Move Up',
  //                                       style: TextStyle(
  //                                           color: Color(0xFF868E9C))),
  //                                   value: 'MoveUp',
  //                                   height: 40,
  //                                 ),
  //                                 new PopupMenuItem<String>(
  //                                   child: Text('Move Down',
  //                                       style: TextStyle(
  //                                           color: Color(0xFF868E9C))),
  //                                   value: 'MoveDown',
  //                                   height: 40,
  //                                 ),
  //                               ]
  //                             : <PopupMenuItem<String>>[
  //                                 new PopupMenuItem<String>(
  //                                   child: Text('Delete',
  //                                       style: TextStyle(
  //                                           color: Color(0xFF868E9C))),
  //                                   value: 'DeleteSection',
  //                                   height: 40,
  //                                 ),
  //                                 new PopupMenuItem<String>(
  //                                   child: Text('Move Down',
  //                                       style: TextStyle(
  //                                           color: Color(0xFF868E9C))),
  //                                   value: 'MoveDown',
  //                                   height: 40,
  //                                 ),
  //                               ],
  //                         icon: Icon(Icons.more_vert,
  //                             size: 18, color: Color(0xFF868E9C)),
  //                         onSelected: (value) {
  //                           if (value == "DeleteSection") {
  //                             deleteSection(index);
  //                           } else if (value == "MoveUp") {
  //                             moveUp(index);
  //                           } else if (value == "MoveDown") {
  //                             moveDown(index);
  //                           }
  //                         },
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(top: 5, left: 5, right: 5),
  //                 padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
  //                 height: 1,
  //                 color: Color(0xFF272D3A),
  //               ),
  //             ],
  //           ))
  //       : Container();
  // }

}
