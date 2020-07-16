import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/firebase_services/basic_firebase.dart';
import 'package:xenome/models/collection.dart';
import 'package:xenome/utils/session_manager.dart';

class CollectionManager {
  static Future<List> getCollections(String uid) async {
    QuerySnapshot querySnapshot = await db
        .collection('collections')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List collections = [];
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      collections.add({
        'collection_title': querySnapshot.documents[i]['collection_title'],
        'collection_image': querySnapshot.documents[i]['collection_list'][0]
            ['image']
      });
    }
    return collections;
  }

  static Future<List> getCollectionList(
      String uid, String collectionTitle) async {
    QuerySnapshot querySnapshot = await db
        .collection('collections')
        .where('collection_title', isEqualTo: collectionTitle)
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List _collectionList = [];

    for (int i = 0;
        i < querySnapshot.documents[0]['collection_list'].length;
        i++) {
      _collectionList.add(Collection.fromJson(
          querySnapshot.documents[0]['collection_list'][i]));
    }

    return _collectionList;
  }

  static Future<void> addNewCollection(
      Collection collection, String collectionTitle) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('collections')
        .where('collection_title', isEqualTo: collectionTitle)
        .where('uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot.documents.length == 0) {
      List collectionList = [];
      collectionList.add(collection.toJson());
      DocumentReference docRef = await db.collection("collections").add({
        'collection_title': collectionTitle,
        'uid': uid,
        'collection_image': collection.image,
        'collection_list': collectionList,
      });
    }
  }

  static Future<void> addSelectedCollection(
      Collection collection, String collectionTitle) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('collections')
        .where('collection_title', isEqualTo: collectionTitle)
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List collectionList = docSnapShot.documents[0]['collection_list'].toList();
    collectionList.add(collection.toJson());
    docSnapShot.documents[0].reference
        .updateData({'collection_list': collectionList});
  }

  static Future<void> delSelectedPages(
      int pageNumber, String collectionTitle) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('collections')
        .where('collection_title', isEqualTo: collectionTitle)
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List _temp = [];
    List collectionList = docSnapShot.documents[0]['collection_list'].toList();
    for (int i = 0; i < collectionList.length; i++) {
      if (i != pageNumber) {
        _temp.add(collectionList[i]);
      }
    }

    docSnapShot.documents[0].reference.updateData({'collection_list': _temp});
  }

  static Future<void> delCollection(String collectionTitle) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('collections')
        .where('collection_title', isEqualTo: collectionTitle)
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot != null && docSnapShot.documents.length != 0) {
      docSnapShot.documents[0].reference.delete();
    }
  }
}
