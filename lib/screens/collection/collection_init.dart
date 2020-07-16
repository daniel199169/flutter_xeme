import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/collection_manager.dart';
import 'package:xenome/screens/collection/instagram.dart';
import 'package:xenome/screens/collection/video_item.dart';
import 'package:xenome/screens/collection/viewer_cover_image.dart';
import 'package:xenome/screens/base_widgets/custom_yes_cancel_dialog.dart';
import 'package:xenome/screens/collection/viewer_image.dart';
import 'package:xenome/screens/collection/vimeo.dart';
import 'package:xenome/screens/collection/youtube.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:xenome/screens/profile/my_profile.dart';

class CollectionInit extends StatefulWidget {
  CollectionInit({this.uid, this.collectionTitle});
  final String uid;
  final String collectionTitle;
  @override
  _CollectionInitState createState() => _CollectionInitState();
}

class _CollectionInitState extends State<CollectionInit> {
  PageController _pageController;
  int _currentIndex;
  List collectionList = [];
  List<Widget> commentWidgets = [];
  // TextEditingController titleController;
  // TextEditingController subTitleController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = new PageController(initialPage: _currentIndex);
    getCollectionList();
  }

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  close() {
    Navigator.pop(context);
  }

  deletePage(int pageNumber) async {
    await CollectionManager.delSelectedPages(
        pageNumber, widget.collectionTitle);

    final _commentWidgets = List<Widget>();
    List _collectionList = await CollectionManager.getCollectionList(
        widget.uid, widget.collectionTitle);
    setState(() {
      collectionList = _collectionList;
    });
    for (int i = 0; i < collectionList.length; i++) {
      if (collectionList[i].sectionType == 'cover_image') {
        _commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewerCoverImage(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'image') {
        _commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewerImage(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'instagram') {
        _commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: Instagram(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'vimeo') {
        _commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: Vimeo(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'youtube') {
        _commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: YouTube(data: collectionList[i]),
        ));
      }
    }

    setState(() {
      commentWidgets = _commentWidgets;
    });
  }

  deleteCollection() async {
    await CollectionManager.delCollection(widget.collectionTitle);
    Navigator.push(context, FadeRoute(page: MyProfile()));
  }

  getCollectionList() async {
    List _collectionList = await CollectionManager.getCollectionList(
        widget.uid, widget.collectionTitle);
    setState(() {
      collectionList = _collectionList;
    });
    for (int i = 0; i < collectionList.length; i++) {
      // if (_collectionList[i].title == null) {
      //   titleController = TextEditingController(text: "");
      // } else {
      //   titleController =
      //       TextEditingController(text: _collectionList[i].title.title);
      // }
      // if (_collectionList[i].subtitle == null) {
      //   subTitleController = TextEditingController(text: "");
      // } else {
      //   subTitleController =
      //       TextEditingController(text: _collectionList[i].subtitle.title);
      // }
      if (collectionList[i].sectionType == 'cover_image') {
        commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewerCoverImage(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'image') {
        commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: ViewerImage(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'instagram') {
        commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: Instagram(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'vimeo') {
        commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: Vimeo(data: collectionList[i]),
        ));
      }
      if (collectionList[i].sectionType == 'youtube') {
        commentWidgets.add(Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.all(10.0),
          child: YouTube(data: collectionList[i]),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
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
                  margin: EdgeInsets.fromLTRB(25, 40, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new GestureDetector(
                        child: Text(
                          (_currentIndex + 1).toString() +
                              ' / ' +
                              (collectionList.length).toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto Medium',
                            color: Color(0xFF868E9C),
                          ),
                        ),
                      ),
                      new GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: PopupMenuButton(
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
                              child: Text('Delete page',
                                  style: TextStyle(color: Color(0xFF868E9C))),
                              value: 'DelPage',
                              height: 40,
                            ),
                            new PopupMenuItem<String>(
                              child: Text('Delete collection',
                                  style: TextStyle(color: Color(0xFF868E9C))),
                              value: 'DelCollection',
                              height: 40,
                            ),
                          ],
                          icon: Icon(Icons.more_horiz,
                              size: 25, color: Color(0xFF868E9C)),
                          onSelected: (value) async {
                            if (value == "Close") {
                              close();
                            } else if (value == "DelPage") {
                              ConfirmAction _selAction =
                                  await CustomYesCancelDialog(context,
                                      title:
                                          'Are you sure you want to delete this page?',
                                      content: '');
                              if (_selAction == ConfirmAction.YES) {
                                deletePage(_currentIndex);
                              }
                              if (_selAction == ConfirmAction.CANCEL) {
                                return;
                              }
                            } else if (value == "DelCollection") {
                              ConfirmAction _selAction =
                                  await CustomYesCancelDialog(context,
                                      title:
                                          'Are you sure you want to delete this collection?',
                                      content: '');
                              if (_selAction == ConfirmAction.YES) {
                                deleteCollection();
                              }
                              if (_selAction == ConfirmAction.CANCEL) {
                                return;
                              }
                            }
                          },
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: PageView(
            controller: _pageController,
            onPageChanged: _onPageViewChange,
            children: <Widget>[] + commentWidgets));
  }

  _onPageViewChange(int page) {
    setState(() {
      _currentIndex = page;
    });
  }
}
