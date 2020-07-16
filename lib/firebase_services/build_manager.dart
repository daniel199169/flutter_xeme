import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basic_firebase.dart';

class BuildManager {
  static SharedPreferences _sharedPrefs;

  static void initialize(SharedPreferences sharedPreferences) {
    _sharedPrefs = sharedPreferences;
  }

  static Future<void> addBuild(
      var titleList, var subTitleList, var positionList, var image, String uid) async {
    db.collection('build').add({
      'uid': uid,
      'title': titleList,
      'subtitle': subTitleList,
      'image': image,
      'position_list': positionList,
    });
  }

  static Future<void> updateTitle(var titleList, String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null) return;

    if (docSnapShot.documents.length > 0) {
      docSnapShot.documents[0].reference.updateData({'title': titleList});
    } else {
      db.collection('build').add({
        'uid': uid,
        'title': titleList,
      });
    }
  }

  static Future<void> updateSubtitle(var SubtitleList, String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null) return;

    if (docSnapShot.documents.length > 0) {
      docSnapShot.documents[0].reference.updateData({'subtitle': SubtitleList});
    } else {
      db.collection('build').add({
        'uid': uid,
        'subtitle': SubtitleList,
      });
    }
  }

  static Future<void> updatePosition(List<double> positionList, String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null) return;

    if (docSnapShot.documents.length > 0) {
      docSnapShot.documents[0].reference
          .updateData({'position_list': positionList});
    } else {
      db.collection('BrandColors').add({
        'uid': uid,
        'color_list': positionList,
      });
    }
  }

  static Future<List<double>> getPositionList(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    List<double> _positionList = docSnapShot.documents[0]['position_list']
        .map<double>((val) => double.parse(val.toString()))
        .toList();
    return _positionList;
  }

  static Future<void> updateImage(var image, String uid) async {
    _sharedPrefs.setString('image', image);

    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null) return;

    if (docSnapShot.documents.length > 0) {
      docSnapShot.documents[0].reference
          .updateData({'image': image.toString()});
    } else {
      db.collection('build').add({
        'uid': uid,
        'image': image,
      });
    }
  }

  static getTitle(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    var _titleList =
        docSnapShot.documents[0]['title'].map((val) => val).toList();
    return _titleList;
  }

  static getSubtitle(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    var _SubtitleList =
        docSnapShot.documents[0]['subtitle'].map((val) => val).toList();
    return _SubtitleList;
  }

  static getImage(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('build')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return "";
    } else {
      String temp = docSnapShot.documents[0]['image'];
      return temp;
    }
  }

  static void saveTitleList(List vallist) async {
    String jsonString = json.encode(vallist);
    _sharedPrefs.setString('title', jsonString);
  }

  static void saveSubTitleList(List vallist) async {
    String jsonString = json.encode(vallist);
    _sharedPrefs.setString('subtitle', jsonString);
  }

  static void savePositionList(List vallist) async {
    String jsonString = json.encode(vallist);
    _sharedPrefs.setString('position_list', jsonString);
  }

  static void addBuildList(String uid) {
    String title = _sharedPrefs.getString('title');
    String subtitle = _sharedPrefs.getString('subtitle');
    String position = _sharedPrefs.getString('position_list');
    String image = _sharedPrefs.getString('image');
    BuildManager.addBuild(json.decode(title), json.decode(subtitle),
        json.decode(position), image, uid);
  }

  static void updateTextPart(){
    
  }
}
