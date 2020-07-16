import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/recommended.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/styled_scale.dart';
import 'basic_firebase.dart';

class RecommendedManager {
  static Future<void> add(Recommended recommended) async {
    await db.collection('Recommended').add(recommended.toJson());
  }

  static Future<List<Recommended>> getList() async {
    QuerySnapshot querySnapshot = await db
        .collection('Recommended')
        .getDocuments();
    List<Recommended> _list = [];
    _list = querySnapshot.documents.map((doc) {
      return Recommended.fromJson(doc.data);
    }).toList();
    return _list;
  }

  static Future<StyledScale> getScale(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Recommended')
        .where('id', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }
    StyledScale _titleList;
    _titleList = new StyledScale.fromJson(docSnapShot.documents[0]['scale_title_list']);
    return _titleList;
  }

  static Future<StyledQuad> getQuad(String id) async {
    QuerySnapshot docSnapShot = await db
        .collection('Recommended')
        .where('id', isEqualTo: id)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    StyledQuad _titleList;
    _titleList = new StyledQuad.fromJson(docSnapShot.documents[0]['quad_title_list']);
    return _titleList;
  }

}
