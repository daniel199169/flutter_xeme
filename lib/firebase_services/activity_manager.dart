import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenome/models/activityfeedmodel.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class ActivityManager {
  static SharedPreferences _sharedPrefs;

  static void initialize(SharedPreferences sharedPreferences) {
    _sharedPrefs = sharedPreferences;
  }

  static Future<List<ActivityFeedModel>> getActivityList() async {
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = new List();

    QuerySnapshot querySnapshot = await db
        .collection('ActivityFeed')
        .orderBy('createdAt')
        .getDocuments();


    templist = querySnapshot.documents;
    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();

    List<ActivityFeedModel> _list = [];
    _list = list.map((doc) {
      
      return ActivityFeedModel.fromJson(doc);
    }).toList();
    return _list;
  }

  static getUserImage(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var userImage = docSnapShot.documents[0]['image'];
      return userImage;
    }
  }
  
  static getUserWebsite(String uid) async {
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
  static getUserDescription(String uid) async{
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var description = docSnapShot.documents[0]['description'];
      return description;
    }
  }

  static getUserOtherlink(String uid) async{
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var otherlink = docSnapShot.documents[0]['otherlink'];
      return otherlink;
    }
  }

  static getPostUserName(String uid) async {
    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var userName = docSnapShot.documents[0]['tellusname'];
      return userName;
    }
  }

  static getFollowingList(String uid) async {
    String myUid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('Follows')
        .where('follower_uid', isEqualTo: myUid)
        .where('following_uid', isEqualTo: uid)
        .getDocuments();

    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }

    var followingList = docSnapShot.documents.map((doc) {
      return doc['following_uid'];
    }).toList();
    return followingList;
  }
  
  static addReplyComment(String id, String type, String uid, String comment) async{
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .getDocuments();
    
    String thumbnail = docSnapShot.documents[0]['image'].toString();
    String xmapName = docSnapShot.documents[0]['title']['title'].toString();
    String commentUid = docSnapShot.documents[0]['uid'].toString();
    DateTime nowTime = DateTime.now();

    ActivityFeedModel newActivity = ActivityFeedModel(
      uid: uid,
      type: 'reply',
      content: comment,
      thumbnail: thumbnail,
      xmapName: xmapName,
      createdAt: nowTime.toString(),
      postUid: commentUid,
      xmapId : id,
      xmapType : type,
    );
    addNewActivity(newActivity);

  }

  static addAPageComment(String id, String type, String uid, String comment) async{
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .getDocuments();
    
    String thumbnail = docSnapShot.documents[0]['image'].toString();
    String xmapName = docSnapShot.documents[0]['title']['title'].toString();
    String commentUid = docSnapShot.documents[0]['uid'].toString();
    DateTime nowTime = DateTime.now();

    ActivityFeedModel newActivity = ActivityFeedModel(
      uid: uid,
      type: 'aPageComment',
      content: comment,
      thumbnail: thumbnail,
      xmapName: xmapName,
      createdAt: nowTime.toString(),
      postUid: commentUid,
      xmapId : id,
      xmapType : type,

    );
    addNewActivity(newActivity);

  }

  static addAPageCollect(String id, String type, String uid) async{
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .getDocuments();

    String thumbnail = docSnapShot.documents[0]['image'].toString();
    String xmapName = docSnapShot.documents[0]['title']['title'].toString();
    String commentUid = docSnapShot.documents[0]['uid'].toString();
    DateTime nowTime = DateTime.now();

    ActivityFeedModel newActivity = ActivityFeedModel(
      uid: uid,
      type: 'aPageCollect',
      content: '',
      thumbnail: thumbnail,
      xmapName: xmapName,
      createdAt: nowTime.toString(),
      postUid: commentUid,
      xmapId : id,
      xmapType : type,

    );
    addNewActivity(newActivity);

  }

  static addMyList(String id, String type, String uid) async{
    QuerySnapshot docSnapShot = await db
        .collection(type)
        .where('id', isEqualTo: id)
        .getDocuments();

    String thumbnail = docSnapShot.documents[0]['image'].toString();
    String xmapName = docSnapShot.documents[0]['title']['title'].toString();
    String commentUid = docSnapShot.documents[0]['uid'].toString();
    DateTime nowTime = DateTime.now();

    ActivityFeedModel newActivity = ActivityFeedModel(
      uid: uid,
      type: 'addMyList',
      content: '',
      thumbnail: thumbnail,
      xmapName: xmapName,
      createdAt: nowTime.toString(),
      postUid: commentUid,
      xmapId : id,
      xmapType : type,

    );
    addNewActivity(newActivity);

  }

  static Future<void> addNewActivity(ActivityFeedModel newActivity) async {
    await db.collection('ActivityFeed')
    .add(newActivity.toJson());
  }
  
  static addPushTokenToUsers(String token) async {
    
    String myUid = SessionManager.getUserId();
      await db
        .collection('Users')
        .document(myUid)
        .updateData({'pushToken': token});
        
  }

}
