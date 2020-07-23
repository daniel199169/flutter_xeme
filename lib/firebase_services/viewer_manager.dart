import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/chartCirclePosition.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/models/collection.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/models/image.dart';
import 'package:xenome/models/instagram.dart';
import 'package:xenome/models/quadTitle.dart';
import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/text_part.dart';
import 'package:xenome/models/vimeo.dart';
import 'package:xenome/models/page_order.dart';
import 'package:xenome/models/xmap.dart';
import 'package:xenome/models/youtube.dart';
import 'package:xenome/models/buildder.dart';
import 'package:xenome/models/xmap_all.dart';
import 'package:xenome/models/xmap_info.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/models/view_count.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/utils/string_helper.dart';
import 'basic_firebase.dart';

class ViewerManager {
  static getXmapAllData(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    XmapAllData _data = XmapAllData.fromJson(querySnapshot.documents[0].data);
    return _data;
  }

  static Future<CoverImageModel> getCoverImage(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    CoverImageModel _coverImage =
        CoverImageModel.fromJson(querySnapshot.documents[0]['cover_image']);
    return _coverImage;
  }

  static Future<SetupInfo> getSetupInfo(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot.documents[0]['SetupInfo'] == null) {
      SetupInfo _initSetupInfo = new SetupInfo(title: '', description: '');
      querySnapshot.documents[0].reference
          .updateData({'SetupInfo': _initSetupInfo.toJson()});

      return _initSetupInfo;
    } else {
      SetupInfo _result =
          SetupInfo.fromJson(querySnapshot.documents[0]['SetupInfo']);
      return _result;
    }
  }

  static Future<ImageModel> getImage(
      String id, String type, int subOrder) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    ImageModel _myImage;

    var list = querySnapshot.documents[0]['my_image'];
    _myImage = ImageModel.fromJson(list[subOrder]);

    return _myImage;
  }

  static Future<List<ImageModel>> getImageAll(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    List<ImageModel> result = [];
    if (querySnapshot.documents[0]['my_image'] != null &&
        querySnapshot.documents[0]['my_image'].length != 0) {
      var list = querySnapshot.documents[0]['my_image'];
      for (int i = 0; i < list.length; i++) {
        result.add(ImageModel.fromJson(list[i]));
      }
      return result;
    } else {
      return result;
    }
  }

  static Future<void> addViewNumber(
      String xmapid, String type, String commentID) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection("XmapInfo")
        .where('xmapID', isEqualTo: xmapid)
        .getDocuments();

    List list = [];

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      XmapInfo _new = new XmapInfo(
        xmapID: xmapid,
        type: type,
      );

      await db.collection('XmapInfo').add(_new.toJson());

      QuerySnapshot querySnapshot1 = await db
          .collection("XmapInfo")
          .where('xmapID', isEqualTo: xmapid)
          .getDocuments();

      ViewCount _addViewNumber = new ViewCount(
          uid: uid, commentID: commentID, viewNumber: '1', commentNumber: '0');
      List _listInitMyView = [];
      _listInitMyView.add(_addViewNumber.toJson());
      querySnapshot1.documents[0].reference
          .updateData({'page_order': _listInitMyView});
    } else {
      int flag = 0;
      if (querySnapshot.documents[0]['page_order'] == null) {
        ViewCount _addViewNumber = new ViewCount(
            uid: uid,
            commentID: commentID,
            viewNumber: '1',
            commentNumber: '0');
        List _listInitMyView = [];
        _listInitMyView.add(_addViewNumber.toJson());
        querySnapshot.documents[0].reference
            .updateData({'page_order': _listInitMyView});
      } else {
        list = querySnapshot.documents[0]['page_order'].toList();
        // print("*****************     *****************");
        // print(xmapid);
        // print(list);
        for (int i = 0; i < list.length; i++) {
          if (list[i]['uid'] == uid && list[i]['commentID'] == commentID) {
            int viewNum = int.parse(list[i]['view_number']) + 1;

            list[i]['view_number'] = viewNum.toString();

            flag = 1;
            break;
          }
        }
        if (flag == 1) {
          querySnapshot.documents[0].reference.updateData({'page_order': list});
        } else {
          ViewCount _addViewNumber = new ViewCount(
              uid: uid,
              commentID: commentID,
              viewNumber: '1',
              commentNumber: '0');

          list.add(_addViewNumber.toJson());
          querySnapshot.documents[0].reference.updateData({'page_order': list});
        }
      }
    }
  }

  static getTrendingView(String xmapid) async {
    QuerySnapshot querySnapshot = await db
        .collection("XmapInfo")
        .where('xmapID', isEqualTo: xmapid)
        .getDocuments();

    var _list = [];
    var _result = [];
    var _midTempArry = [];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return _result;
    } else {
      _list = querySnapshot.documents[0]['page_order'];

      var _sectionArry = [];
      for (int i = 0; i < _list.length; i++) {
        _sectionArry.add(_list[i]['commentID']);
      }

      _sectionArry = Set.of(_sectionArry).toList();

      for (int i = 0; i < _sectionArry.length; i++) {
        int point1 = 0;
        int point2 = 0;

        for (int j = 0; j < _list.length; j++) {
          if (_list[j]['commentID'] == _sectionArry[i]) {
            point1 = point1 + int.parse(_list[j]['comment_number']);
            point2 = point2 + int.parse(_list[j]['view_number']);
          }
        }

        _midTempArry.add(MidSaveArray(
            _sectionArry[i], point1.toString(), point2.toString()));
      }

      _midTempArry.sort((a, b) => (int.parse(a.viewNumber) +
              int.parse(a.commentNumber))
          .compareTo((int.parse(b.viewNumber) + int.parse(b.commentNumber))));

      for (int i = _midTempArry.length - 1; i >= 0; i--) {
        var temp = [];
        var _sectionInfo = [];
        _sectionInfo =
            await TrendingManager.getSectionInfo(xmapid, _midTempArry[i].uid);

        temp.add(_sectionInfo[0]);
        temp.add(_midTempArry[i].viewNumber);
        temp.add(_midTempArry[i].commentNumber);
        temp.add(_sectionInfo[1]);
        temp.add(_sectionInfo[2]);
        temp.add(_sectionInfo[3]);
        _result.add(temp);
      }
      return _result;
    }
  }

  static getMostActiveViewers(String xmapid) async {
    QuerySnapshot querySnapshot = await db
        .collection("XmapInfo")
        .where('xmapID', isEqualTo: xmapid)
        .getDocuments();

    var _list = [];
    var _result = [];
    var _midTempArry = [];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return _result;
    } else {
      _list = querySnapshot.documents[0]['page_order'];

      var _uidArry = [];
      for (int i = 0; i < _list.length; i++) {
        _uidArry.add(_list[i]['uid']);
      }
      _uidArry = Set.of(_uidArry).toList();

      for (int i = 0; i < _uidArry.length; i++) {
        int point1 = 0;
        int point2 = 0;

        for (int j = 0; j < _list.length; j++) {
          if (_list[j]['uid'] == _uidArry[i]) {
            point1 = point1 + int.parse(_list[j]['comment_number']);
            point2 = point2 + int.parse(_list[j]['view_number']);
          }
        }

        _midTempArry.add(
            MidSaveArray(_uidArry[i], point1.toString(), point2.toString()));
      }

      _midTempArry.sort((a, b) => (int.parse(a.viewNumber) +
              int.parse(a.commentNumber))
          .compareTo((int.parse(b.viewNumber) + int.parse(b.commentNumber))));

      int k = 0;
      for (int i = _midTempArry.length - 1; i >= 0; i--) {
        k++;

        if (k > 4) break;
        String avatarImage =
            await TrendingManager.getAvatarImage(_midTempArry[i].uid);
        String username =
            await TrendingManager.getUserName(_midTempArry[i].uid);
        if (avatarImage == "" || username == "") continue;
        var temp = [];
        temp.add(avatarImage);
        temp.add(username);
        temp.add(_midTempArry[i].viewNumber);
        temp.add(_midTempArry[i].commentNumber);
        temp.add(_midTempArry[i].uid);
        temp.add(await TrendingManager.getNewXmapCreated(_midTempArry[i].uid));
        _result.add(temp);
      }
      return _result;
    }
  }

  static Future<List<Trending>> getViewerAlsoViewed(
      String xmapid, String uid) async {
    QuerySnapshot querySnapshot =
        await db.collection("XmapInfo").getDocuments();

    var _list = [];
    var list = [];

    if (querySnapshot.documents == null) {
      return [];
    } else {
      _list = querySnapshot.documents;

      for (int i = 0; i < _list.length; i++) {
        if (_list[i]['page_order'] == null) continue;

        for (int j = 0; j < _list[i]['page_order'].length; j++) {
          if (uid == _list[i]['page_order'][j]['uid']) {
            list.add(_list[i]['xmapID']);
            break;
          }
        }
      }

      // for (int ]i = 0; i < _list.length; i++) {
      //   if (_list[i].xmapID != xmapid) {
      //     list.add(_list[i]);
      //   }
      // }

      List<Trending> result = [];
      for (int i = 0; i < list.length; i++) {
        result.add(await TrendingManager.getListFromID(list[i], 'Trending'));
      }

      return result;
    }
  }

  static getAllViewers(String xmapid) async {
    QuerySnapshot querySnapshot = await db
        .collection("XmapInfo")
        .where('xmapID', isEqualTo: xmapid)
        .getDocuments();

    var _list = [];
    var result = [];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return result;
    } else {
      _list = querySnapshot.documents[0]['page_order'];

      var _uidArry = [];
      for (int i = 0; i < _list.length; i++) {
        _uidArry.add(_list[i]['uid']);
      }

      _uidArry = Set.of(_uidArry).toList();
     
      for (int i = 0; i < _uidArry.length; i++) {
        
        if (i > 9) break;
        if (_uidArry[i] != '') {
          String avatarImage =
              await TrendingManager.getAvatarImage(_uidArry[i]);
          String username = await TrendingManager.getUserName(_uidArry[i]);
          if (avatarImage == "" || username == "") continue;
          var temp = [];
          temp.add(_uidArry[i]);
          temp.add(avatarImage);
          temp.add(username);
          temp.add(await TrendingManager.getNewXmapCreated(_uidArry[i]));
          result.add(temp);
        }
      }
    }
    return result;
  }

  static getScaleChart(String xmapid) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('id', isEqualTo: xmapid)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      if (querySnapshot.documents[0]['scale_heatmap'] == null ||
          querySnapshot.documents[0]['scale_heatmap'].length == 0) {
        return [];
      } else {
        var scaleHeatmap = querySnapshot.documents[0]['scale_heatmap'];
        var scaleTitle = querySnapshot.documents[0]['scale_title'];

        int maxSuborder = int.parse(scaleHeatmap[0]['subOrder']);
        if (scaleHeatmap.length > 1) {
          for (int i = 0; i < scaleHeatmap.length; i++) {
            if (maxSuborder < int.parse(scaleHeatmap[i]['subOrder'])) {
              maxSuborder = int.parse(scaleHeatmap[i]['subOrder']);
            }
          }
        }

        var result = [];
        for (int j = 0; j <= maxSuborder; j++) {
          int title1 = 0;
          int title2 = 0;
          String labelOne = '';
          String labelTwo = '';
          String title = '';
          var _temp = [];
          for (int i = 0; i < scaleHeatmap.length; i++) {
            if (scaleHeatmap[i]['uid'] != '') {
              if (scaleHeatmap[i]['subOrder'] == j.toString()) {
                if (scaleHeatmap[i]['vote'] == "1") {
                  title1 = title1 + 1;
                }
                if (scaleHeatmap[i]['vote'] == "2") {
                  title2 = title2 + 1;
                }
                labelOne = scaleTitle[j]['labelOne'];
                labelTwo = scaleTitle[j]['labelTwo'];
                title = scaleTitle[j]['title'];
              }
            }
          }

          double per1 = 0;
          double per2 = 0;
          if (title2 + title1 > 0) {
            per1 = title1 / (title1 + title2);
            per2 = title2 / (title1 + title2);
          }
          _temp.add(title);
          _temp.add(labelOne);
          _temp.add(title1.toString());
          _temp.add(per1.toStringAsFixed(1));
          _temp.add(labelTwo);
          _temp.add(title2.toString());
          _temp.add(per2.toStringAsFixed(1));
          _temp.add(j.toString());
          _temp.add(
              await TrendingManager.getPageIdFromSubOrderForScaleChartInfo(
                  xmapid, j.toString()));
          result.add(_temp);
        }

        return result;
      }
    }
  }

  static getQuadChart(String xmapid) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('id', isEqualTo: xmapid)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      if (querySnapshot.documents[0]['quad_heatmap'] == null ||
          querySnapshot.documents[0]['quad_heatmap'].length == 0) {
        return [];
      } else {
        var quadHeatmap = querySnapshot.documents[0]['quad_heatmap'];
        var quadTitle = querySnapshot.documents[0]['quad_title'];

        int maxSuborder = int.parse(quadHeatmap[0]['subOrder']);
        if (quadHeatmap.length > 1) {
          for (int i = 0; i < quadHeatmap.length; i++) {
            if (maxSuborder < int.parse(quadHeatmap[i]['subOrder'])) {
              maxSuborder = int.parse(quadHeatmap[i]['subOrder']);
            }
          }
        }
        // print("%%%%%%%%%%%%%%   %%%%%%%%%%%");
        // print(maxSuborder);
        var result = [];
        for (int j = 0; j <= maxSuborder; j++) {
          int title1 = 0;
          int title2 = 0;
          int title3 = 0;
          int title4 = 0;
          String labelOne = '';
          String labelTwo = '';
          String labelThree = '';
          String labelFour = '';
          String title = '';
          var _temp = [];
          for (int i = 0; i < quadHeatmap.length; i++) {
            if (quadHeatmap[i]['uid'] != '') {
              if (quadHeatmap[i]['subOrder'] == j.toString()) {
                if (quadHeatmap[i]['vote'] == "1") {
                  title1 = title1 + 1;
                }
                if (quadHeatmap[i]['vote'] == "2") {
                  title2 = title2 + 1;
                }
                if (quadHeatmap[i]['vote'] == "3") {
                  title3 = title3 + 1;
                }
                if (quadHeatmap[i]['vote'] == "4") {
                  title4 = title4 + 1;
                }
                labelOne = quadTitle[j]['labelOne'];
                labelTwo = quadTitle[j]['labelTwo'];
                labelThree = quadTitle[j]['labelThree'];
                labelFour = quadTitle[j]['labelFour'];
                title = quadTitle[j]['title'];
              }
            }
          }
          double per1 = 0;
          double per2 = 0;
          double per3 = 0;
          double per4 = 0;
          if (title2 + title1 + title3 + title4 > 0) {
            per1 = title1 / (title1 + title2 + title3 + title4);
            per2 = title2 / (title1 + title2 + title3 + title4);
            per3 = title3 / (title1 + title2 + title3 + title4);
            per4 = title4 / (title1 + title2 + title3 + title4);
          }

          // print("%%%%%%%%%%%%%% jjjjjjjjjj  %%%%%%%%%%%");
          // print(j);

          _temp.add(title);
          _temp.add(labelOne);
          _temp.add(title1.toString());
          _temp.add(per1.toStringAsFixed(1));
          _temp.add(labelTwo);
          _temp.add(title2.toString());
          _temp.add(per2.toStringAsFixed(1));
          _temp.add(labelThree);
          _temp.add(title3.toString());
          _temp.add(per3.toStringAsFixed(1));
          _temp.add(labelFour);
          _temp.add(title4.toString());
          _temp.add(per4.toStringAsFixed(1));
          _temp.add(j.toString());
          _temp.add(await TrendingManager.getPageIdFromSubOrderForQuadChartInfo(
              xmapid, j.toString()));

          result.add(_temp);
        }

        return result;
      }
    }
  }

  static getBuilderId() async {
    String uid = SessionManager.getUserId();

    QuerySnapshot querySnapshot = await db
        .collection("Buildder")
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      Buildder _newbuildder = new Buildder(
        uid: SessionManager.getUserId(),
      );

      BuildderManager.add(_newbuildder);
      QuerySnapshot querySnapshotaddid = await db
          .collection("Buildder")
          .where('uid', isEqualTo: uid)
          .getDocuments();
      querySnapshotaddid.documents[0].reference
          .updateData({'id': querySnapshotaddid.documents[0].documentID});

      String id = querySnapshotaddid.documents[0].documentID;
      // await db.collection('Buildder').document(id).collection('comments').add({'page_order_id': '', 'collection_type': ''});

      return id;
    } else {
      String id = querySnapshot.documents[0].documentID;
      querySnapshot.documents[0].reference.updateData({'id': id});
      return id;
    }
  }

  static getPageOrder(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      var pageOrder = querySnapshot.documents[0]['page_order'];

      return pageOrder;
    }
  }

  static getCommentID(String id, String type, String pageOrderId) async {
    QuerySnapshot querySnapshotCommentId =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    List<PageOrder> _pageOrderList = [];
    for (int i = 0;
        i < querySnapshotCommentId.documents[0]['page_order'].length;
        i++) {
      _pageOrderList.add(PageOrder.fromJson(
          querySnapshotCommentId.documents[0]['page_order'][i]));
    }
    // int orderId = int.parse(pageOrderId) - 1;
    int orderId = int.parse(pageOrderId);
    String commentID = _pageOrderList[orderId].commentID;
    return commentID;
  }

  static getLastComment(String id, String type, String pageOrderId) async {
    QuerySnapshot querySnapshotCommentId =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    // print("------------  kkk ============  kkk  ---------------");
    // print(id);
    // print(type);
    // print(pageOrderId);

    // cover page absolutely exist in page_order
    List<PageOrder> _pageOrderList = [];
    for (int i = 0;
        i < querySnapshotCommentId.documents[0]['page_order'].length;
        i++) {
      _pageOrderList.add(PageOrder.fromJson(
          querySnapshotCommentId.documents[0]['page_order'][i]));
    }
    // int orderId = int.parse(pageOrderId) - 1;
    int orderId = int.parse(pageOrderId);
    String commentID = _pageOrderList[orderId].commentID;

    QuerySnapshot querySnapshot = await db
        .collection("Comments")
        .where('xmap_id', isEqualTo: id)
        .where('comment_id', isEqualTo: commentID)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      DocumentReference docRef = await db.collection('Comments').add({
        'xmap_id': id,
        'collection_type': type,
        'comment_id': '',
      });

      String documentId = docRef.documentID;
      DocumentReference docSnapShot1 =
          db.collection('Comments').document(documentId);
      docSnapShot1.updateData({'comment_id': documentId});

      // update comment_id from page order table

      QuerySnapshot querySnapshot2 =
          await db.collection(type).where('id', isEqualTo: id).getDocuments();

      var _pageOrderList = querySnapshot2.documents[0]['page_order'];

      _pageOrderList[orderId]['comment_id'] = documentId;

      querySnapshot2.documents[0].reference
          .updateData({'page_order': _pageOrderList});

      // await ViewerManager.addViewNumber(
      //     widget.id, widget.type, widget.pageId, 'Cover image');
      // }
      return [];
    } else {
      List commentList = [];

      if (querySnapshot.documents[0]['contents'] == null ||
          querySnapshot.documents[0]['contents'].length == 0) {
        return [];
      } else {
        commentList = querySnapshot.documents[0]['contents'];

        int length = commentList.length;

        String commentLast = commentList[length - 1]['content'];
        if (commentLast.length > 25) {
          commentLast = commentLast.substring(0, 24);
        }

        String commentUserId = commentList[length - 1]['uid'];
        QuerySnapshot docSnapShot1 = await db
            .collection('Users')
            .where('uid', isEqualTo: commentUserId)
            .getDocuments();
        String commentUserName = docSnapShot1.documents[0]['tellusname'];
        var result = [];
        result.add(commentUserName);
        result.add(commentLast);
        result.add(length.toString());

        return result;
      }
    }
  }

  static getXmapTitle() async {
    QuerySnapshot querySnapshot =
        await db.collection("FeaturedXmap").getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      var xmapTitleList = querySnapshot.documents.map((doc) {
        return doc['title']['title'];
      }).toList();
      var xmapIDList = querySnapshot.documents.map((doc) {
        return doc['id'];
      }).toList();

      var result = [];
      for (int i = 0; i < xmapTitleList.length; i++) {
        var temp = [];
        temp.add(xmapTitleList[i]);
        temp.add(xmapIDList[i]);
        result.add(temp);
      }

      return result;
    }
  }

  static Future<StyledQuad> getScale(String id, String type) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    StyledQuad _titleList;
    _titleList =
        new StyledQuad.fromJson(docSnapShot.documents[0]['scale_title_list']);
    return _titleList;
  }

  static Future<CirclePosition> getQuadPosition(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    var temp = [];
    temp = docSnapShot.documents[0]['quad_circle_position'];
    CirclePosition quadCirclePositionList;
    for (int i = 0; i < temp.length; i++) {
      if (temp[i]['subOrder'] == subOrder.toString()) {
        CirclePosition _quadCirclePositionList =
            new CirclePosition.fromJson(temp[i]);
        if (_quadCirclePositionList.uid == SessionManager.getUserId()) {
          quadCirclePositionList = _quadCirclePositionList;
        }
      }
    }
    return quadCirclePositionList;
  }

  static Future<void> updateQuadPosition(
      var position, String id, String type, String subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    int isPosition;
    for (int i = 0;
        i < docSnapShot.documents[0]['quad_circle_position'].length;
        i++) {
      if (docSnapShot.documents[0]['quad_circle_position'][i]['subOrder'] ==
          subOrder.toString()) {
        CirclePosition _quadCirclePosition = new CirclePosition.fromJson(
            docSnapShot.documents[0]['quad_circle_position'][i]);

        if (_quadCirclePosition.uid == position.uid) {
          docSnapShot.documents[0]['quad_circle_position'][i] =
              position.toJson();
          isPosition = 1;
        }
      }
    }
    docSnapShot.documents[0].reference.updateData({
      'quad_circle_position': docSnapShot.documents[0]['quad_circle_position']
    });
    if (isPosition == null) {
      List _quadCirclePosition =
          docSnapShot.documents[0]['quad_circle_position'].toList();
      _quadCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'quad_circle_position': _quadCirclePosition});
    }
  }

  static Future<CirclePosition> getScalePosition(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    var temp = [];
    temp = docSnapShot.documents[0]['scale_circle_position'];

    CirclePosition scaleCirclePosition;
    for (int i = 0; i < temp.length; i++) {
      if (temp[i]['subOrder'] == subOrder.toString()) {
        CirclePosition _scaleCirclePositionList =
            new CirclePosition.fromJson(temp[i]);
        if (_scaleCirclePositionList.uid == SessionManager.getUserId()) {
          scaleCirclePosition = _scaleCirclePositionList;
        }
      }
    }
    return scaleCirclePosition;
  }

  static getQuadCircleColor(String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    var list = [];
    list = docSnapShot.documents[0]['quad_title'];
    String valueString = list[subOrder]['color'].split('#')[1];
    // int value = int.parse(valueString, radix: 16);

    return valueString;
  }

  static getScaleCircleColor(String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    var list = [];
    list = docSnapShot.documents[0]['scale_title'];
    String valueString = list[subOrder]['color'].split('#')[1];

    return valueString;
  }

  static Future<List<ChartCirclePosition>> getQuadHeatmap(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    var list = [];
    list = docSnapShot.documents[0]['quad_heatmap'];
    List<ChartCirclePosition> quadChartList = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i]['subOrder'] == subOrder.toString()) {
        quadChartList.add(new ChartCirclePosition.fromJson(list[i]));
      }
    }
    return quadChartList;
  }

  static Future<List<ChartCirclePosition>> getScaleHeatmap(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    var list = [];
    list = docSnapShot.documents[0]['scale_heatmap'];
    List<ChartCirclePosition> scaleChartList = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i]['subOrder'] == subOrder.toString()) {
        scaleChartList.add(new ChartCirclePosition.fromJson(list[i]));
      }
    }
    return scaleChartList;
  }

  static Future<void> updateScalePosition(
      var position, String id, String type, String subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    int isPosition;
    for (int i = 0;
        i < docSnapShot.documents[0]['scale_circle_position'].length;
        i++) {
      if (docSnapShot.documents[0]['scale_circle_position'][i]['subOrder'] ==
          subOrder.toString()) {
        CirclePosition _scaleCirclePositionList = new CirclePosition.fromJson(
            docSnapShot.documents[0]['scale_circle_position'][i]);

        if (_scaleCirclePositionList.uid == position.uid) {
          docSnapShot.documents[0]['scale_circle_position'][i] =
              position.toJson();
          isPosition = 1;
        }
      }
    }
    docSnapShot.documents[0].reference.updateData({
      'scale_circle_position': docSnapShot.documents[0]['scale_circle_position']
    });

    if (isPosition == null) {
      List _scaleCirclePosition =
          docSnapShot.documents[0]['scale_circle_position'].toList();
      _scaleCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'scale_circle_position': _scaleCirclePosition});
    }
  }

  static Future<void> updateQuadHeatmap(ChartCirclePosition position, String id,
      String type, String subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    // int isPosition;
    // for (int i = 0; i < docSnapShot.documents[0]['quad_heatmap'].length; i++) {
    //   if (docSnapShot.documents[0]['quad_heatmap'][i]['subOrder'] == subOrder) {
    //     ChartCirclePosition _quadCirclePosition =
    //         new ChartCirclePosition.fromJson(
    //             docSnapShot.documents[0]['quad_heatmap'][i]);
    //     if (_quadCirclePosition.uid == position.uid) {
    //       docSnapShot.documents[0]['quad_heatmap'][i] = position.toJson();
    //       isPosition = 1;
    //     }
    //   }
    // }
    // docSnapShot.documents[0].reference
    //     .updateData({'quad_heatmap': docSnapShot.documents[0]['quad_heatmap']});
    // if (isPosition == null) {
    List _quadCirclePosition =
        docSnapShot.documents[0]['quad_heatmap'].toList();
    _quadCirclePosition.add(position.toJson());
    docSnapShot.documents[0].reference
        .updateData({'quad_heatmap': _quadCirclePosition});
    // }
  }

  static Future<void> updateScaleHeatmap(ChartCirclePosition position,
      String id, String type, String subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    int isPosition;
    for (int i = 0; i < docSnapShot.documents[0]['scale_heatmap'].length; i++) {
      if (docSnapShot.documents[0]['scale_heatmap'][i]['subOrder'] ==
          subOrder) {
        ChartCirclePosition _scaleCirclePosition =
            new ChartCirclePosition.fromJson(
                docSnapShot.documents[0]['scale_heatmap'][i]);

        if (_scaleCirclePosition.uid == position.uid) {
          docSnapShot.documents[0]['scale_heatmap'][i] = position.toJson();
          isPosition = 1;
        }
        docSnapShot.documents[0].reference.updateData(
            {'scale_heatmap': docSnapShot.documents[0]['scale_heatmap']});
      }
    }
    if (isPosition == null) {
      List _scaleCirclePosition =
          docSnapShot.documents[0]['scale_heatmap'].toList();
      _scaleCirclePosition.add(position.toJson());
      docSnapShot.documents[0].reference
          .updateData({'scale_heatmap': _scaleCirclePosition});
    }
  }

  static Future<int> getQuadColor(String id, String type) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    int _color;
    _color = docSnapShot.documents[0]['quad_circle_color'];
    return _color;
  }

  static Future<int> getScaleColor(String id, String type) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    int _color;
    _color = docSnapShot.documents[0]['scale_circle_color'];
    return _color;
  }

  static Future<TextPartModel> getTextPart(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    TextPartModel _myTextPart;

    var list = docSnapShot.documents[0]['text_part'];
    _myTextPart = TextPartModel.fromJson(list[subOrder]);

    return _myTextPart;
  }

  static Future<List<TextPartModel>> getTextPartAll(
      String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    List<TextPartModel> result = [];
    if (querySnapshot.documents[0]['text_part'] != null &&
        querySnapshot.documents[0]['text_part'].length != 0) {
      var list = querySnapshot.documents[0]['text_part'];
      for (int i = 0; i < list.length; i++) {
        result.add(TextPartModel.fromJson(list[i]));
      }
      return result;
    } else {
      return result;
    }
  }

  static Future<List<YoutubeModel>> getYoutubeAll(
      String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    List<YoutubeModel> result = [];
    if (querySnapshot.documents[0]['youtube'] != null &&
        querySnapshot.documents[0]['youtube'].length != 0) {
      var list = querySnapshot.documents[0]['youtube'];
      for (int i = 0; i < list.length; i++) {
        result.add(YoutubeModel.fromJson(list[i]));
      }
      return result;
    } else {
      return result;
    }
  }

  static Future<List<VimeoModel>> getVimeoAll(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    List<VimeoModel> result = [];
    if (querySnapshot.documents[0]['vimeo'] != null &&
        querySnapshot.documents[0]['vimeo'].length != 0) {
      var list = querySnapshot.documents[0]['vimeo'];
      for (int i = 0; i < list.length; i++) {
        result.add(VimeoModel.fromJson(list[i]));
      }
      return result;
    } else {
      return result;
    }
  }

  static Future<List<InstagramModel>> getInstagramAll(
      String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    List<InstagramModel> result = [];
    if (querySnapshot.documents[0]['instagram'] != null &&
        querySnapshot.documents[0]['instagram'].length != 0) {
      var list = querySnapshot.documents[0]['instagram'];
      for (int i = 0; i < list.length; i++) {
        result.add(InstagramModel.fromJson(list[i]));
      }
      return result;
    } else {
      return result;
    }
  }

  static Future<VimeoModel> getVimeo(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    VimeoModel _vimeoList;

    List list = [];
    list = docSnapShot.documents[0]['vimeo'];
    _vimeoList = VimeoModel.fromJson(list[subOrder]);

    return _vimeoList;
  }

  static Future<YoutubeModel> getYoutube(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    YoutubeModel _youtubeList;

    List list = [];
    list = docSnapShot.documents[0]['youtube'];
    _youtubeList = YoutubeModel.fromJson(list[subOrder]);

    return _youtubeList;
  }

  static Future<InstagramModel> getInstagram(
      String id, String type, int subOrder) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    InstagramModel _instagramList;
    List list = [];
    list = docSnapShot.documents[0]['instagram'];
    _instagramList = new InstagramModel.fromJson(list[subOrder]);
    return _instagramList;
  }

  static getXmapFollowingUsers(String id, String type) async {
    QuerySnapshot docSnapShot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      String uid = docSnapShot.documents[0]['uid'];

      QuerySnapshot docSnapShot1 = await db
          .collection("Follows")
          .where('follower_uid', isEqualTo: uid)
          .getDocuments();

      if (docSnapShot1 == null || docSnapShot1.documents.length == 0) {
        return [];
      } else {
        var followingList = docSnapShot1.documents.map((doc) {
          return doc['following_uid'];
        }).toList();
        return followingList;
      }
    }
  }

  static getXmapInfo(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      CoverImageModel _temp =
          CoverImageModel.fromJson(querySnapshot.documents[0]['cover_image']);
      String image = _temp.imageURL;
      String id = querySnapshot.documents[0]['id'];
      String uid = querySnapshot.documents[0]['uid'];

      var xmapInfo = [];
      xmapInfo.add(image);
      xmapInfo.add(id);
      xmapInfo.add(uid);

      return xmapInfo;
    }
  }
}

class MidSaveArray {
  String uid;
  String commentNumber;
  String viewNumber;

  MidSaveArray(this.uid, this.commentNumber, this.viewNumber);

  @override
  String toString() {
    return '{ ${this.uid}, ${this.commentNumber}, ${this.viewNumber} }';
  }
}
