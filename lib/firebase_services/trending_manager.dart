import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:xenome/models/cover_image.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class TrendingManager {
  static Future<void> add(Trending trending) async {
    await db.collection('Trending').add(trending.toJson());
  }

  static getTopXmapInfo() async {
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('xmap_type', isEqualTo: "featured")
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      CoverImageModel _temp =
          CoverImageModel.fromJson(querySnapshot.documents[0]['cover_image']);
      String image = _temp.imageURL;
      String id = querySnapshot.documents[0]['id'];

      var xmapInfo = [];
      xmapInfo.add(image);

      xmapInfo.add(id);

      return xmapInfo;
    }
  }

  static Future<List<Trending>> getList() async {
    QuerySnapshot querySnapshot =
        await db.collection('Trending').getDocuments();
    List<Trending> _list = [];
    _list = querySnapshot.documents.map((doc) {
      return Trending.fromJson(doc.data);
    }).toList();
    List<Trending> _returnList = [];
    for (int i = 0; i < _list.length; i++) {
      // if (SessionManager.getEmail() != '') {
      // if (_list[i].global.global == 'private') {
      //   String _temp = _list[i].privateEmailList.privateEmailList;
      //   var _temparry = _temp.split(",");
      //   for (int j = 0; j < _temparry.length; j++) {
      //     if (_temparry[j].trim() == SessionManager.getEmail()) {
      //       _returnList.add(_list[i]);
      //       break;
      //     }
      //   }
      // } else {
      //   _returnList.add(_list[i]);
      // }

      // } else {
      if (_list[i].global.global == 'public') {
        _returnList.add(_list[i]);
      }
      // }
    }

    return _returnList;
  }

  static Future<List<Trending>> getInvitedList() async {
    QuerySnapshot querySnapshot =
        await db.collection('Trending').getDocuments();
    List<Trending> _list = [];
    _list = querySnapshot.documents.map((doc) {
      return Trending.fromJson(doc.data);
    }).toList();
    List<Trending> _returnList = [];
    for (int i = 0; i < _list.length; i++) {
      if (SessionManager.getEmail() != '') {
        if (_list[i].global.global == 'private') {
          String _temp = _list[i].privateEmailList.privateEmailList;
          var _temparry = _temp.split(",");
          if (_temparry.length > 1) {
            for (int j = 0; j < _temparry.length; j++) {
              if (_temparry[j].trim() == SessionManager.getEmail()) {
                _returnList.add(_list[i]);
                break;
              }
            }
          } else {
            if (_temp.trim() == SessionManager.getEmail()) {
              _returnList.add(_list[i]);
            }
          }
        }
        // else {
        //   _returnList.add(_list[i]);
        // }
      }
    }

    return _returnList;
  }

  static Future<Trending> getListFromID(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    Trending _result = Trending.fromJson(querySnapshot.documents[0].data);
    return _result;
  }

  static Future<StyledScale> getScale(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Trending')
        .where('id', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    StyledScale _titleList;
    _titleList =
        new StyledScale.fromJson(docSnapShot.documents[0]['scale_title_list']);
    return _titleList;
  }

  static Future<StyledQuad> getQuad(String id) async {
    QuerySnapshot docSnapShot = await db
        .collection('Trending')
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    StyledQuad _titleList;
    _titleList =
        new StyledQuad.fromJson(docSnapShot.documents[0]['quad_title_list']);
    return _titleList;
  }

  static getPageId() async {
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('order', isEqualTo: "top")
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      return querySnapshot.documents[0]['id'];
    }
  }

  static getPageIdFromSubOrderForScaleChartInfo(
      String xmapid, String subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('id', isEqualTo: xmapid)
        .getDocuments();
    String result = '';

    var _list = querySnapshot.documents[0]['page_order'];
    for (int i = 0; i < _list.length; i++) {
      if (_list[i]['page_name'] == 'Scale chart' &&
          _list[i]['sub_order'] == subOrder) {
        result = (i + 1).toString();
        break;
      }
    }

    return result;
  }

  static getPageIdFromSubOrderForQuadChartInfo(
      String xmapid, String subOrder) async {
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('id', isEqualTo: xmapid)
        .getDocuments();
    String result = '';

    var _list = querySnapshot.documents[0]['page_order'];
    for (int i = 0; i < _list.length; i++) {
      if (_list[i]['page_name'] == 'Quad chart' &&
          _list[i]['sub_order'] == subOrder) {
        result = (i + 1).toString();
        break;
      }
    }

    return result;
  }

  static getPageStructure() async {
    QuerySnapshot querySnapshot = await db
        .collection("Trending")
        .where('order', isEqualTo: "top")
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      return querySnapshot.documents[0]['pagestructure'];
    }
  }

  static getNormalPageStructure(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      return querySnapshot.documents[0]['pagestructure'];
    }
  }

  static getFeaturedUserId(String pageId, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: pageId).getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return "";
    } else {
      return querySnapshot.documents[0]['uid'];
    }
  }

  static getAvatarImage(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return "";
    } else {
      String avatarImage = docSnapShot.documents[0]['image'];

      return avatarImage;
    }
  }

  static getUserName(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return "";
    } else {
      String userName = docSnapShot.documents[0]['tellusname'];
      return userName;
    }
  }

  static getSectionInfo(String xmapid, String commentID) async {
    QuerySnapshot docSnapShot = await db
        .collection('Trending')
        .where('id', isEqualTo: xmapid)
        .getDocuments();

    var _result = [];
    String _resultURL = '';
    String _resultPageName = '';
    String _resultSubOrder = '';
    String _resultPageID = '';

    var _pageOrder = docSnapShot.documents[0]['page_order'];
    for (int i = 0; i < _pageOrder.length; i++) {
      if (_pageOrder[i]['comment_id'] == commentID) {
         _resultPageName = _pageOrder[i]['page_name'];
         _resultSubOrder = _pageOrder[i]['sub_order'];

        if (_resultPageName == "Cover image") {
          CoverImageModel _new =
              CoverImageModel.fromJson(docSnapShot.documents[0]['cover_image']);
          _resultURL = _new.imageURL;
        }
        if (_resultPageName == "Image") {
          var _new = docSnapShot.documents[0]['my_image'];
          _resultURL = _new[int.parse(_resultSubOrder)]['image_url'];
        }
        if (_resultPageName == "YouTube") {
          var _new = docSnapShot.documents[0]['youtube'];
          _resultURL = _new[int.parse(_resultSubOrder)]['image'];
        }
        if (_resultPageName == "Instagram") {
          var _new = docSnapShot.documents[0]['instagram'];
          _resultURL = _new[int.parse(_resultSubOrder)]['instagramURL'];
        }
        if (_resultPageName == "Vimeo") {
          var _new = docSnapShot.documents[0]['vimeo'];
          _resultURL = _new[int.parse(_resultSubOrder)]['image'];
        }
        _resultPageID = (i + 1).toString();
        break;
      }
    }
    _result.add(_resultURL);
    _result.add(_resultPageName);
    _result.add(_resultSubOrder);
    _result.add(_resultPageID);

    return _result;
  }
}
