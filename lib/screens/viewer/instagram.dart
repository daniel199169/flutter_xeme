import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/models/instagram.dart';
import 'package:video_player/video_player.dart';
import 'package:xenome/models/collection.dart';
import 'package:xenome/firebase_services/activity_manager.dart';
import 'package:xenome/firebase_services/collection_manager.dart';
import 'package:xenome/screens/not_si/not_si_create_profile.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'comments.dart';

class Instagram extends StatefulWidget {
  final String id;
  final String type;
  final String subOrder;
  final String pageId;
  var data;
  Instagram({this.id, this.type, this.subOrder, this.pageId, this.data});

  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  InstagramModel instagram;
  bool visible;
  var lastComment = [];
  double dWidth = 0.0;
  double dHeight = 0.0;
  String collectionTitle;
  String commentId = '';
  List collections;
  final collectionTitleController = TextEditingController();
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    visible = true;
    instagram = new InstagramModel(
        title: "", instagramURL: "", description: '', tag: '', reference: '');

    dWidth = SessionManager.getMediaWidth() - 20;
    dHeight = (SessionManager.getMediaHeight() - 20) * 0.8;

    getLastComment();
    getCollections();

    super.initState();
  }

  addViewNumber() async {
    if (SessionManager.getUserId() != '') {
      await ViewerManager.addViewNumber(widget.id, widget.type, commentId);
    }
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

    addViewNumber();
  }

  getCollections() async {
    String uid = SessionManager.getUserId();
    List _collections = await CollectionManager.getCollections(uid);
    setState(() {
      collections = _collections;
    });
  }

  void addNewCollection(String collectionTitle) async {
    Collection collection = Collection(
        image: '',
        title: '',
        videoURL: '',
        link: '',
        sectionType: '',
        description: '',
        tag: '',
        reference: '');
    collection.image = widget.data[int.parse(widget.subOrder)].instagramURL;
    collection.videoURL = widget.data[int.parse(widget.subOrder)].instagramURL;
    collection.sectionType = 'instagram';
    collection.title = widget.data[int.parse(widget.subOrder)].title;
    collection.description =
        widget.data[int.parse(widget.subOrder)].description;
    collection.tag = widget.data[int.parse(widget.subOrder)].tag;
    collection.reference = widget.data[int.parse(widget.subOrder)].reference;
    await CollectionManager.addNewCollection(collection, collectionTitle);
  }

  void addSelectedCollection(String collectionTitle) async {
    Collection collection = Collection(
        image: '',
        title: '',
        videoURL: '',
        link: '',
        sectionType: '',
        description: '',
        tag: '',
        reference: '');
    collection.image = widget.data[int.parse(widget.subOrder)].instagramURL;
    collection.videoURL = widget.data[int.parse(widget.subOrder)].instagramURL;
    collection.title = widget.data[int.parse(widget.subOrder)].title;
    collection.sectionType = 'instagram';
    collection.description =
        widget.data[int.parse(widget.subOrder)].description;
    collection.tag = widget.data[int.parse(widget.subOrder)].tag;
    collection.reference = widget.data[int.parse(widget.subOrder)].reference;
    await CollectionManager.addSelectedCollection(collection, collectionTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onPanUpdate: (details) async {
                if (SessionManager.getUserId() != '') {
                  if (details.delta.dy > 0) {
                    if (collections.length == 0) {
                      showModalBottomSheet(
                          backgroundColor: Colors.black,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: FractionallySizedBox(
                                heightFactor: 0.4,
                                child: ListView(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 30, bottom: 40),
                                      child: Center(
                                        child: CustomPaint(
                                            painter: Drawhorizontalline()),
                                      ),
                                    ),
                                    TextFormField(
                                      maxLines: 1,
                                      autofocus: false,
                                      style: TextStyle(
                                        fontFamily: 'Roboto Reqular',
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      controller: collectionTitleController,
                                      decoration: InputDecoration(
                                        labelText: 'Collection',
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
                                      // validator: (value) =>
                                      //     value.isEmpty ? 'Password can\'t be empty' : null,
                                      onSaved: (value) =>
                                          collectionTitle = value.trim(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: MaterialButton(
                                        height: 60.0,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          addNewCollection(
                                              collectionTitleController.text);
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(
                                              "Add",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto Medium',
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            )
                                          ],
                                        ),
                                        elevation: 0,
                                        minWidth: 350,
                                        textColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            side: BorderSide(
                                              color: Color(0xFF2B8DD8),
                                              width: 2.0,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: MaterialButton(
                                        height: 60.0,
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto Medium',
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            )
                                          ],
                                        ),
                                        elevation: 0,
                                        minWidth: 350,
                                        textColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      showModalBottomSheet(
                          backgroundColor: Colors.black,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: FractionallySizedBox(
                                heightFactor: 0.45,
                                child: ListView(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 30, bottom: 5),
                                      child: Center(
                                        child: CustomPaint(
                                            painter: Drawhorizontalline()),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          "Select a collection",
                                          style: TextStyle(
                                              fontFamily: 'Roboto Black',
                                              fontSize: 16,
                                              color: Colors.white),
                                          minFontSize: 12,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 15.0, 0.0, 0.0),
                                      constraints: const BoxConstraints(
                                          maxHeight: 220.0),
                                      child: new ListView.builder(
                                        itemCount: collections.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: _buildCollectionChild,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showModalBottomSheet(
                                              backgroundColor: Colors.black,
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: FractionallySizedBox(
                                                    heightFactor: 0.4,
                                                    child: ListView(
                                                      padding: EdgeInsets.only(
                                                          left: 30, right: 30),
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30,
                                                                  bottom: 40),
                                                          child: Center(
                                                            child: CustomPaint(
                                                                painter:
                                                                    Drawhorizontalline()),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          maxLines: 1,
                                                          autofocus: false,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Reqular',
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                          ),
                                                          controller:
                                                              collectionTitleController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Collection',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFF868E9C),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.0),
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.0),
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF868E9C),
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                            ),
                                                          ),
                                                          // validator: (value) =>
                                                          //     value.isEmpty ? 'Password can\'t be empty' : null,
                                                          onSaved: (value) =>
                                                              collectionTitle =
                                                                  value.trim(),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          child: MaterialButton(
                                                            height: 60.0,
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              addNewCollection(
                                                                  collectionTitleController
                                                                      .text);
                                                              ActivityManager
                                                                  .addAPageCollect(
                                                                      widget.id,
                                                                      widget
                                                                          .type,
                                                                      SessionManager
                                                                          .getUserId());
                                                            },
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Add",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Roboto Medium',
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            elevation: 0,
                                                            minWidth: 350,
                                                            textColor:
                                                                Colors.grey,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    side:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xFF2B8DD8),
                                                                      width:
                                                                          2.0,
                                                                    )),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          child: MaterialButton(
                                                            height: 60.0,
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Cancel",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Roboto Medium',
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            elevation: 0,
                                                            minWidth: 350,
                                                            textColor:
                                                                Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: "or add a ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle,
                                            ),
                                            TextSpan(
                                              text: "new collection",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline,
                                            )
                                          ]),
                                        ),
                                        height: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  } else {
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
                    }
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
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 0, bottom: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: CachedNetworkImage(
                        imageUrl: widget
                            .data[int.parse(widget.subOrder)].instagramURL,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.8,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                          'assets/icos/loader.gif',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                        errorWidget: _error,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height - 270),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListView(
                        children: <Widget>[
                          SvgPicture.asset('assets/icos/instagram.svg'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.data[int.parse(widget.subOrder)].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Instagram',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF868E9C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                      height:
                                          MediaQuery.of(context).size.height,
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
                                        text: " " +
                                            lastComment[1] +
                                            " " +
                                            "..." +
                                            " ",
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
            ),
          )
        ],
      ),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    print(error);
    return const Center(child: Icon(Icons.error));
  }

  Widget _buildCollectionChild(BuildContext context, int index) {
    // final List collection = collections[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        addSelectedCollection(collections[index]['collection_title']);
        ActivityManager.addAPageCollect(
            widget.id, widget.type, SessionManager.getUserId());
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 10.0, left: 40)
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
