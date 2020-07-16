import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class BrandColorManager {
  static Future<void> updateColor(List<int> colorList) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('BrandColors')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null) return;

    if (docSnapShot.documents.length > 0) {
      docSnapShot.documents[0].reference.updateData({'color_list': colorList, 'uid':uid});
    } else {
      db.collection('BrandColors').add({
        'uid': uid,
        'color_list': colorList,
      });
    }
  }

  static Future<void> deleteColor(List<int> colorList) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('BrandColors')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if(docSnapShot == null) return;

    if(docSnapShot.documents.length > 0) {
      docSnapShot.documents[0].reference.updateData({'color_list': colorList, 'uid':uid});
    }
  }

  static Future<List<int>> getColorList() async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('BrandColors')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    List<int> _colorList = docSnapShot.documents[0]['color_list']
        .map<int>((val) => int.parse(val.toString()))
        .toList();
    return _colorList;
  }

  static Future<List<double>> getFontSizeList() async {
    QuerySnapshot docSnapShot = await db.collection('FontSizes').getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    List<double> _fontSizeList = docSnapShot.documents[0]['size_list']
        .map<double>((val) => double.parse(val.toString()))
        .toList();
    return _fontSizeList;
  }
}
