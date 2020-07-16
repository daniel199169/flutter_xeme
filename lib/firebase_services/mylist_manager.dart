import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/mylist.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:xenome/models/xmap_info.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class MylistManager {
  static Future<void> add(String id, String type) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    DocumentReference docRef =
        await db.collection('Mylist').add(querySnapshot.documents[0].data);
    String documentId = docRef.documentID;

    DocumentReference docSnapShot =
        db.collection('Mylist').document(documentId);
    docSnapShot.updateData({'uid': uid});
  }

  static remove(String id, String type) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      querySnapshot.documents[0].reference.delete();
    }
  }

  static Future<void> addFromViewingToFeaturedXmap() async {
    QuerySnapshot querySnapshot = await db.collection("Viewing").getDocuments();

    int len = querySnapshot.documents.length;
    for (int i = 0; i < len; i++) {
      DocumentReference docRef = await db
          .collection('FeaturedXmap')
          .add(querySnapshot.documents[i].data);
      String documentId = docRef.documentID;
      DocumentReference docSnapShot =
          db.collection('FeaturedXmap').document(documentId);
      docSnapShot.updateData({'id': documentId});
    }
  }

  static Future<List<Mylist>> getList(String uid) async {
    QuerySnapshot querySnapshot = await db
        .collection('Mylist')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List<Mylist> _list = [];
    _list = querySnapshot.documents.map((doc) {
      return Mylist.fromJson(doc.data);
    }).toList();
    return _list;
  }

  static Future<Mylist> getData(String id) async {
    QuerySnapshot querySnapshot =
        await db.collection('Mylist').where('id', isEqualTo: id).getDocuments();
    Mylist _buildder = Mylist.fromJson(querySnapshot.documents[0].data);
    return _buildder;
  }

  static getAddMyListStatus(String id) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection('Mylist')
        .where('uid', isEqualTo: uid)
        .where('id', isEqualTo: id)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return "Not exist";
    } else {
      return "Exist";
    }
  }

  static Future<StyledScale> getScale(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Mylist')
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

  static Future<StyledQuad> getQuad(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Mylist')
        .where('id', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    StyledQuad _titleList;
    _titleList =
        new StyledQuad.fromJson(docSnapShot.documents[0]['quad_title_list']);
    return _titleList;
  }

  static getPageStructure(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      return querySnapshot.documents[0]['pagestructure'];
    }
  }
}
