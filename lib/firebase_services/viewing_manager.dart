import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:xenome/models/viewing.dart';
import 'basic_firebase.dart';
import 'package:xenome/utils/session_manager.dart';

class ViewingManager {
  static Future<void> add(Viewing viewing) async {
    await db.collection('Viewing').add(viewing.toJson());
  }

  static Future<List<Viewing>> getList() async {
    QuerySnapshot querySnapshot = await db
        .collection('Viewing')
        .where('uid', isEqualTo: SessionManager.getUserId())
        .getDocuments();
    List<Viewing> _list = [];
    _list = querySnapshot.documents.map((doc) {
      return Viewing.fromJson(doc.data);
    }).toList();
    return _list;
  }

  static Future<StyledScale> getScale(String id) async {
    QuerySnapshot docSnapShot = await db
        .collection('Viewing')
        .where('id', isEqualTo: id)
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
        .collection('Viewing')
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
