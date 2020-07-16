import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenome/models/activityfeedmodel.dart';
import 'package:xenome/models/User.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class FollowStatusManager {
  static SharedPreferences _sharedPrefs;

  static void initialize(SharedPreferences sharedPreferences) {
    _sharedPrefs = sharedPreferences;
  }


  static getFollowingList(String otherUid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('follower_uid', isEqualTo: otherUid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }

    var followingList = docSnapShot.documents.map((doc) {
      return doc['following_uid'];
    }).toList();
    return followingList;
  }

  static getFollowerList(String otherUid) async {
   
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('following_uid', isEqualTo: otherUid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }

    var followerList = docSnapShot.documents.map((doc) {
      return doc['follower_uid'];
    }).toList();
    return followerList;
  }

  static getUserImage(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      String userImage = docSnapShot.documents[0]['image'];
      return userImage;
    }
  }

  static getUserName(String uid) async {
   
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      
      return [];
    } else {
      String userName = docSnapShot.documents[0]['tellusname'];
      return userName;
    }
  }

}
