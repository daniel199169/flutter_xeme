import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/models/text_part.dart';
import 'comments.dart';

class TextPart extends StatefulWidget {
  TextPart({this.id, this.type, this.subOrder, this.pageId, this.data});
  final String id;
  final String type;
  final String subOrder;
  final String pageId;
  var data;
  @override
  _TextPartState createState() => _TextPartState();
}

class _TextPartState extends State<TextPart> {
  TextPartModel textPart;
  var lastComment = [];
  String commentId = '';
  double dWidth = 0.0;
  double dHeight = 0.0;

  @override
  void initState() {
    textPart = new TextPartModel(
        title: "", text: "", description: "", tag: "", reference: "");

    dWidth = SessionManager.getMediaWidth() - 20;
    dHeight = (SessionManager.getMediaHeight() - 20) * 0.8;

    getLastComment();

    super.initState();
  }

  getLastComment() async {
    var _lastCommentArray = await ViewerManager.getLastComment(
        widget.id, widget.type, widget.pageId);
    setState(() {
      lastComment = _lastCommentArray;
    });

    String _commentId =
        await ViewerManager.getCommentID(widget.id, widget.type, widget.pageId);
    setState(() {
      commentId = _commentId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.fromLTRB(35, 35, 35, 10),
              child: ListView(
                children: <Widget>[
                  Text(
                    widget.data[int.parse(widget.subOrder)].title != null
                        ? widget.data[int.parse(widget.subOrder)].title
                        : "...",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 22.0,
                        height: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.data[int.parse(widget.subOrder)].text,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20.0, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          getOverlayWidget(),
          Padding(
            padding: EdgeInsets.only(bottom: dHeight / 0.8 * 0.044),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  if (SessionManager.getUserId() != '') {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 1,
                            child: Container(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height,
                              child: Container(
                                child: Comments(
                                  id: widget.id,
                                  type: widget.type,
                                  commentId: commentId,
                                  callback: getLastComment,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        });
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
                child: lastComment.length != 0
                    ? RichText(
                        text: new TextSpan(
                          text: lastComment[0],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xFF868E9C),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: " " + lastComment[1] + " " + "..." + " ",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Color(0xFF868E9C),
                                  fontSize: 14,
                                )),
                            TextSpan(
                                text: "+" + lastComment[2],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      )
                    : Text(
                        "Have your say...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF868E9C),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getOverlayWidget() {
    return new Container(
      alignment: Alignment.bottomCenter,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1 - 8),
      child: new Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width - 80,
        decoration: new BoxDecoration(
          color: Colors.purple,
          gradient: new LinearGradient(
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
            colors: [Colors.white, Colors.white12],
          ),
        ),
      ),
    );
  }
}
