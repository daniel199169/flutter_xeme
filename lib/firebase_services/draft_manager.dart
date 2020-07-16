import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:xenome/models/drafting.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class DraftingManager {
  
  static Future<List<Drafting>> getList() async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection('SavedDraft')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List<Drafting> _list = [];
    
    _list = querySnapshot.documents.map((doc) {
      return Drafting.fromJson(doc.data);
    }).toList();
   
    return _list;
  }


  static Future<StyledScale> getScale(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('SavedDraft')
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
        .collection('SavedDraft')
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
