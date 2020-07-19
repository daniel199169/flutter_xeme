import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/collection_manager.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/models/collection.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/screens/not_si/not_si_create_profile.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/firebase_services/activity_manager.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'comments.dart';

class ViewerCoverImage extends StatefulWidget {
  ViewerCoverImage({this.id, this.type, this.pageId, this.data});
  final String id;
  final String type;
  final String pageId;
  CoverImageModel data;

  @override
  _ViewerCoverImageState createState() => _ViewerCoverImageState();
}

class _ViewerCoverImageState extends State<ViewerCoverImage> {
  var lastComment = [];
  String lComment = '';
  String commentId = '';

  String collectionTitle;
  List collections;
  SetupInfo xmapTitle;
  final collectionTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    xmapTitle = new SetupInfo(title: '', description: '');

    getXmapTitle();
    getCollections();
    getLastComment();
   
  }

  addViewNumber() async {

    await ViewerManager.addViewNumber(
        widget.id, widget.type, commentId);
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
    collection.sectionType = 'cover_image';
    collection.image = widget.data.imageURL;
    collection.title = xmapTitle.title;
    collection.description = widget.data.description;
    collection.tag = widget.data.tag;
    collection.reference = widget.data.reference;

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
    collection.sectionType = 'cover_image';
    collection.image = widget.data.imageURL;
    collection.title = xmapTitle.title;
    collection.description = widget.data.description;
    collection.tag = widget.data.tag;
    collection.reference = widget.data.reference;

    await CollectionManager.addSelectedCollection(collection, collectionTitle);
  }

  getXmapTitle() async {
    SetupInfo _xmapTitle =
        await ViewerManager.getSetupInfo(widget.id, widget.type);

    setState(() {
      xmapTitle = _xmapTitle;
    });
  }

  getCollections() async {
    String uid = SessionManager.getUserId();
    List _collections = await CollectionManager.getCollections(uid);
    setState(() {
      collections = _collections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black87,
      body: Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 0),
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(top: 0.0, left: 0, bottom: 50.0, right: 0),
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
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: FractionallySizedBox(
                                    heightFactor: 0.4,
                                    child: ListView(
                                      padding:
                                          EdgeInsets.only(left: 30, right: 30),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 30, bottom: 40),
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
                                                  collectionTitleController
                                                      .text);
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
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: FractionallySizedBox(
                                    heightFactor: 0.45,
                                    child: ListView(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 30, bottom: 5),
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
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child:
                                                          FractionallySizedBox(
                                                        heightFactor: 0.4,
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 30,
                                                                  right: 30),
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 30,
                                                                      bottom:
                                                                          40),
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
                                                                      style: BorderStyle
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
                                                                      style: BorderStyle
                                                                          .solid),
                                                                ),
                                                              ),
                                                              // validator: (value) =>
                                                              //     value.isEmpty ? 'Password can\'t be empty' : null,
                                                              onSaved: (value) =>
                                                                  collectionTitle =
                                                                      value
                                                                          .trim(),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20),
                                                              child:
                                                                  MaterialButton(
                                                                height: 60.0,
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  addNewCollection(
                                                                      collectionTitleController
                                                                          .text);
                                                                  ActivityManager.addAPageCollect(
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
                                                                          color:
                                                                              Color(0xFF2B8DD8),
                                                                          width:
                                                                              2.0,
                                                                        )),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20),
                                                              child:
                                                                  MaterialButton(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.data.imageURL,
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
              ),
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(
              //         top: MediaQuery.of(context).size.height * 0.2),
              //     child: Column(
              //       children: <Widget>[
              //         AutoSizeText(
              //           xmapTitle.title != null ? xmapTitle.title : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 46,
              //               color: Colors.white),
              //           minFontSize: 42,
              //           maxLines: 4,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         Text(
              //           xmapTitle.description != null
              //               ? xmapTitle.description
              //               : "...",
              //           style: TextStyle(
              //               fontFamily: 'Roboto Black',
              //               fontWeight: FontWeight.w900,
              //               fontSize: 32,
              //               color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.only(bottom: 35.0),
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
          )),
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
