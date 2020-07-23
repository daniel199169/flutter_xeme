import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/comments_manager.dart';
import 'package:xenome/firebase_services/mylist_manager.dart';
import 'package:xenome/models/comment.dart';
import 'package:xenome/screens/create/create_location.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/firebase_services/activity_manager.dart';
import 'package:xenome/screens/view_info/view_info_creator.dart';
import 'package:xenome/screens/base_widgets/custom_show_dialog.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Comments extends StatefulWidget {
  Comments({this.id, this.type, this.commentId, this.callback});
  final String id;
  final String type;
  final String commentId;

  final Function callback;

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool isSwitched = true;
  String _flagAddMyList = '';
  String userImage = SessionManager.getImage();
  List<String> commentUserInfo = [];
  final commentController = TextEditingController();
  ScrollController _scrollcontroller = ScrollController();
  List<Comment> commentList = [];
  List<String> userNameList;
  List<String> userImageList;
  List<String> showDifferenceTime = [];
  List<String> calcDifferenceTime = [];
  double sliderValue;
  FocusNode textNode = new FocusNode();
  String parentId = '';
  int flagReply = 0;

  var differenceTime = '';
  var _lastComment = [];

  @override
  void initState() {
    super.initState();
    parentId = '';
    getComments();
    sliderValue = 0;
    getAddMyListStatus();
  }

  getAddMyListStatus() async {
    String _flagStatus = await MylistManager.getAddMyListStatus(widget.id);
    setState(() {
      _flagAddMyList = _flagStatus;
    });
  }

  differentCommentTime(var dbtime) async {
    DateTime lasttime = DateTime.parse(dbtime);
    DateTime now = DateTime.now();

    var difference = now.difference(lasttime).inSeconds;
    if (difference > 60 && difference < 3600) {
      difference = now.difference(lasttime).inMinutes;
      differenceTime = difference.toString() + "m";
    } else if (difference >= 3600 && difference < 86400) {
      difference = now.difference(lasttime).inHours;
      differenceTime = difference.toString() + "h";
    } else if (difference >= 86400) {
      difference = now.difference(lasttime).inDays;
      differenceTime = difference.toString() + "d";
    } else {
      differenceTime = difference.toString() + "s";
    }

    return differenceTime;
  }

  getComments() async {
    List<Comment> _commentList = await CommentsManager.getComments(
        widget.id, widget.type, widget.commentId);

    List<Comment> _tempCommentList = [];
    List<String> _userNameList = [];
    List<String> _userImageList = [];
    List<String> _differencetime = [];
    for (int i = 0; i < _commentList.length; i++) {
      if (_commentList[i].parentId != "") continue;
      _tempCommentList.add(_commentList[i]);
      for (int j = i + 1; j < _commentList.length; j++) {
        if (_commentList[j].parentId == _commentList[i].id) {
          _tempCommentList.add(_commentList[j]);
          continue;
        }
      }
    }
    setState(() {
      commentList = _tempCommentList;
    });

    for (int i = 0; i < commentList.length; i++) {
      String userName = await CommentsManager.getUserName(commentList[i].uid);
      String userAvatar =
          await CommentsManager.getUserImage(commentList[i].uid);

      _userNameList.add(userName);
      _userImageList.add(userAvatar);
      _differencetime.add(commentList[i].createdAt);
    }
    setState(() {
      userNameList = _userNameList;
      userImageList = _userImageList;
      calcDifferenceTime = _differencetime;
    });

    List<String> _showDifferenceTime = [];

    for (int i = 0; i < calcDifferenceTime.length; i++) {
      if (calcDifferenceTime[i] != null) {
        String temp = await differentCommentTime(calcDifferenceTime[i]);
        _showDifferenceTime.add(temp);
      } else {
        _showDifferenceTime.add('');
      }
    }
    setState(() {
      showDifferenceTime = [];
      showDifferenceTime = _showDifferenceTime;
    });
  }

  addMylist() async {
    await MylistManager.add(widget.id, widget.type);

    setState(() {
      _flagAddMyList = "Exist";
    });
  }

  removeMylist() async {
    await MylistManager.remove(widget.id, "Mylist");

    setState(() {
      _flagAddMyList = "Not exist";
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 500),
        () => _scrollcontroller
            .jumpTo(_scrollcontroller.position.maxScrollExtent));

    return Container(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
            ]),
            width: MediaQuery.of(context).size.width,
            height: 90,
            padding: EdgeInsets.only(top: 20),
            child: IconButton(
              icon: Image.asset("assets/icos/chevron-down@3x.png",
                  width: 50, height: 25, fit: BoxFit.cover),
              onPressed: () {
                widget.callback();
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 3),
                              margin: EdgeInsets.only(left: 10),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (_flagAddMyList == 'Not exist') {
                                    addMylist();
                                    ActivityManager.addMyList(
                                      widget.id,
                                      widget.type,
                                      SessionManager.getUserId(),
                                    );
                                  } else {
                                    removeMylist();
                                  }

                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) => Home()));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconTheme(
                                      data: new IconThemeData(
                                          color: Color(0xFF868E9C)),
                                      child: _flagAddMyList == 'Not exist'
                                          ? new Icon(
                                              Icons.add,
                                              size: 20,
                                            )
                                          : new Icon(
                                              Icons.remove,
                                              size: 20,
                                            ),
                                    ),
                                    Text(
                                      'My list',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Roboto Medium',
                                        color: Color(0xFF868E9C),
                                      ),
                                    )
                                  ],
                                ),
                                color: Color(0xFF272D3A),
                                elevation: 0,
                                padding: EdgeInsets.all(0),
//                                    minWidth: 30,
                                height: 40,
                                textColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Color(0xFF181C26))),
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 3),
                              child: MaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ViewInfoCreator(
                                            id: widget.id, type: widget.type)),
                                  ),
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconTheme(
                                      data: new IconThemeData(
                                          color: Color(0xFF868E9C)),
                                      child: new Icon(
                                        Icons.info_outline,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Text(
                                        'Info',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Roboto Medium',
                                          color: Color(0xFF868E9C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                color: Color(0xFF272D3A),
                                padding: EdgeInsets.all(0),
                                elevation: 0,
//                                                      minWidth: 30,
                                height: 40,
                                textColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(color: Color(0xFF181C26))),
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 3),
//                               child: MaterialButton(
//                                 onPressed: () => {},
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     IconTheme(
//                                       data: new IconThemeData(
//                                           color: Color(0xFF868E9C)),
//                                       child: new Icon(
//                                         Icons.share,
//                                         size: 20,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Share',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontFamily: 'Roboto Medium',
//                                         color: Color(0xFF868E9C),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 color: Color(0xFF272D3A),
//                                 padding: EdgeInsets.all(0),
//                                 elevation: 0,
// //                                                      minWidth: 30,
//                                 height: 40,
//                                 textColor: Colors.grey,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                     side: BorderSide(color: Color(0xFF181C26))),
//                               ),
                            ),
                            flex: 2,
                          ),
//                           Expanded(
//                             child: Container(
//                               margin: EdgeInsets.only(right: 10),
//                               child: MaterialButton(
//                                 onPressed: () => {},
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     IconTheme(
//                                       data: new IconThemeData(
//                                           color: Color(0xFF868E9C)),
//                                       child: new Icon(Icons.add_circle_outline,
//                                           size: 20),
//                                     ),
//                                     Text(
//                                       'Request to',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontFamily: 'Roboto Medium',
//                                         color: Color(0xFF868E9C),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 color: Color(0xFF272D3A),
//                                 padding: EdgeInsets.all(0),
//                                 elevation: 0,
// //                                                      minWidth: 40,
//                                 height: 40,
//                                 textColor: Colors.grey,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                     side: BorderSide(color: Color(0xFF181C26))),
//                               ),
//                             ),
//                             flex: 3,
//                           ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),

              Container(
                  constraints: BoxConstraints(maxHeight: 430.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: commentList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: _commentChild,
                          controller: _scrollcontroller,
                        ),
                      ),
                    ],
                  )),

              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 20, 0.0, 20.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0),
                    child: userImage !=
                            'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                        ? ClipOval(
                            child: Container(
                            child: CachedNetworkImage(
                              imageUrl: userImage,
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                'assets/icos/loader.gif',
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ))
                        : Container(
                            child: CircleAvatar(
                            radius: 15,
                            child: CachedNetworkImage(
                              imageUrl: userImage,
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                'assets/icos/loader.gif',
                                height: 15,
                                width: 15,
                                fit: BoxFit.cover,
                              ),
                              width: 15,
                              height: 15,
                              fit: BoxFit.fill,
                            ),
                            backgroundColor: Color(0xFF272D3A),
                          )),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 30.0, 10.0),
                      child: TextFormField(
                        focusNode: textNode,
                        onFieldSubmitted: (details) {
                          ActivityManager.addAPageComment(
                              widget.id,
                              widget.type,
                              SessionManager.getUserId(),
                              commentController.text);
                          if (flagReply == 1) {
                            ActivityManager.addReplyComment(
                                widget.id,
                                widget.type,
                                SessionManager.getUserId(),
                                commentController.text);
                            setState(() {
                              flagReply = 0;
                            });
                          } else {
                            setState(() {
                              parentId = "";
                            });
                          }

                          CommentsManager.addComment(
                              widget.id,
                              widget.type,
                              widget.commentId,
                              SessionManager.getUserId(),
                              commentController.text,
                              parentId);

                          CommentsManager.addCommentNumber(
                              widget.id, widget.type, widget.commentId);

                          if (parentId == "") {
                            setState(() {
                              commentList.add(Comment.fromJson({
                                'uid': SessionManager.getUserId(),
                                'content': commentController.text,
                                'parent_id': parentId,
                                'id': commentList.length.toString()
                              }));

                              showDifferenceTime.add("1s");
                              userNameList.add(SessionManager.getFullname());
                              userImageList.add(SessionManager.getImage());

                              commentController.clear();

                              // var _lastCommentArray =
                              //     ViewerManager.getLastComment(
                              //         widget.id, widget.type, widget.pagetype);
                              // _lastComment = [];
                              // widget.lastComment = _lastCommentArray;
                            });
                          } else {
                            List<Comment> _tempCommentList = [];

                            if (parentId ==
                                (commentList.length - 1).toString()) {
                              _tempCommentList = commentList;
                              _tempCommentList.add(Comment.fromJson({
                                'uid': SessionManager.getUserId(),
                                'content': commentController.text,
                                'parent_id': parentId,
                                'id': commentList.length.toString()
                              }));
                            } else {
                              for (int i = 0; i < commentList.length; i++) {
                                _tempCommentList.add(commentList[i]);

                                if (commentList[i].id == parentId) {
                                  int k = i;
                                  do {
                                    k++;
                                    if (commentList[k].parentId != parentId) {
                                      _tempCommentList.add(Comment.fromJson({
                                        'uid': SessionManager.getUserId(),
                                        'content': commentController.text,
                                        'parent_id': parentId,
                                        'id': commentList.length.toString()
                                      }));
                                      break;
                                    }
                                    i++;
                                    _tempCommentList.add(commentList[i]);
                                  } while (k < commentList.length);
                                }
                              }
                            }

                            setState(() {
                              commentList = _tempCommentList;

                              showDifferenceTime.add("1s");
                              userNameList.add(SessionManager.getFullname());
                              userImageList.add(SessionManager.getImage());

                              commentController.clear();
                            });
                          }
                        },
                        controller: commentController,
                        style: TextStyle(
                          fontFamily: 'Roboto Reqular',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Have your say...',
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto Reqular',
                              fontSize: 14,
                              color: Color(0xFF868E9C),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                height: 1,
                color: Color(0xFF272D3A),
              ),

              Row(
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 10.0),
                  //   child: Text("How insightful is this section?",
                  //       style: TextStyle(
                  //         fontFamily: 'Roboto',
                  //         color: Color(0xFF868E9C),
                  //         fontSize: 12,
                  //       )),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(150.0, 20.0, 0.0, 10.0),
                  //   child: Text(sliderValue.toInt().toString(),
                  //       style: TextStyle(
                  //         fontFamily: 'Roboto',
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 12,
                  //       )),
                  // ),
                ],
              ),
              // Slider(
              //   activeColor: Colors.white,
              //   min: 0.0,
              //   max: 100.0,
              //   onChanged: (newRating) {
              //     setState(() => sliderValue = newRating);
              //   },
              //   value: sliderValue,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentChild(BuildContext context, int index) {
    return Container(
      padding: commentList[index].parentId == ""
          ? const EdgeInsets.fromLTRB(50.0, 15.0, 30.0, 0.0)
          : const EdgeInsets.fromLTRB(90.0, 15.0, 30.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: userImageList != null
                ? userImageList[index] !=
                        'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                    ? ClipOval(
                        child: Container(
                        child: userImageList != null
                            ? CachedNetworkImage(
                                imageUrl: userImageList[index],
                                placeholder:
                                    (BuildContext context, String url) =>
                                        Image.asset(
                                  'assets/icos/loader.gif',
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/noavatar.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                      ))
                    : Container(
                        child: userImageList != null
                            ? CircleAvatar(
                                radius: 15,
                                child: CachedNetworkImage(
                                  imageUrl: userImageList[index],
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Image.asset(
                                    'assets/icos/loader.gif',
                                    height: 15,
                                    width: 15,
                                    fit: BoxFit.cover,
                                  ),
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.fill,
                                ),
                                backgroundColor: Color(0xFF272D3A),
                              )
                            : Image.asset(
                                'assets/images/noavatar.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                      )
                : Image.asset(
                    'assets/images/noavatar.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: new TextSpan(
                    text: userNameList != null
                        ? userNameList[index] + ' '
                        : '... ',
                    // recognizer: new TapGestureRecognizer()
                    //   ..onTap = () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (_) => CreateLocation()),
                    //       ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: commentList[index].content != null
                              ? commentList[index].content
                              : "...",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xFF868E9C),
                            fontSize: 13,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: RichText(
                    text: new TextSpan(
                      text: showDifferenceTime.length > 0
                          ? showDifferenceTime[index] + ' '
                          : '... ',
                      // text: "",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF868E9C),
                        fontSize: 12,
                      ),
                      children: <TextSpan>[
                        commentList[index].parentId == ""
                            ? TextSpan(
                                text: "Reply",
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      parentId = commentList[index].id;
                                      flagReply = 1;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(textNode);
                                  },
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Color(0xFF868E9C),
                                  fontSize: 12,
                                ))
                            : TextSpan(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
