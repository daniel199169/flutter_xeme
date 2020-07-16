import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenome/utils/session_manager.dart';

import 'basic_firebase.dart';

class FollowManager {
  static SharedPreferences _sharedPrefs;

  static void initialize(SharedPreferences sharedPreferences) {
    _sharedPrefs = sharedPreferences;
  }

  static getFollowingList() async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('follower_uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    
    var followingList = docSnapShot.documents.map((doc) {
      return doc['following_uid'];
    }).toList();
    
    return followingList;
  }

  static getFollowingImage(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var followingImage = docSnapShot.documents[0]['image'];
      return followingImage;
    }
  }

  static setFollowingOther(String otherUid) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('following_uid', isEqualTo: otherUid)
        .where('follower_uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      await db
          .collection('Follows')
          .add({'following_uid': otherUid, 'follower_uid': uid});
    }
  }

  static Future<void> delFollowingOther(String otherUid) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('following_uid', isEqualTo: otherUid)
        .where('follower_uid', isEqualTo: uid)
        .getDocuments();

    docSnapShot.documents[0].reference.delete();
  }

  static getFollowStatus(String otherUid) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('following_uid', isEqualTo: otherUid)
        .where('follower_uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return "Follow";
    }else{
      return "Unfollow";
    }
  }

  static getFollowingName(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var followingName = docSnapShot.documents[0]['tellusname'];
      return followingName;
    }
  }

  static getFollowingWebsite(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var website = docSnapShot.documents[0]['website'];
      return website;
    }
  }

  static getUserDescription(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var website = docSnapShot.documents[0]['description'];
      return website;
    }
  }

  static getFollowingOtherlink(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var website = docSnapShot.documents[0]['otherlink'];
      return website;
    }
  }

  static getFollowingListCountForOtherProfile(String otherUid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('follower_uid', isEqualTo: otherUid)
        .getDocuments();

    return docSnapShot.documents.length.toString();
  }

  static getFollowersListCountForOtherProfile(String otherUid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('following_uid', isEqualTo: otherUid)
        .getDocuments();

    return docSnapShot.documents.length.toString();
  }
}
