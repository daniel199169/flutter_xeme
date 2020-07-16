import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/comment.dart';
import 'package:xenome/models/xmap_info.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class CommentsManager {
  static Future<List<Comment>> getComments(
      String id, String type, String commentId) async {
    QuerySnapshot querySnapshot = await db
        .collection('Comments')
        .where('xmap_id', isEqualTo: id)
        .where('collection_type', isEqualTo: type)
        .where('comment_id', isEqualTo: commentId)
        .getDocuments();

    if (querySnapshot.documents[0]['contents'] == null ||
        querySnapshot.documents[0]['contents'] == 0) {
      List _listInitComment = [];
      querySnapshot.documents[0].reference
          .updateData({'contents': _listInitComment});
      return [];
    } else {
      List<Comment> _commentList = [];
      for (int i = 0; i < querySnapshot.documents[0]['contents'].length; i++) {
        _commentList
            .add(Comment.fromJson(querySnapshot.documents[0]['contents'][i]));
      }
      return _commentList;
    }
  }

  static Future<String> getUserName(String uid) async {
    QuerySnapshot querySnapshot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    return querySnapshot.documents[0]['tellusname'];
  }

  static Future<String> getUserImage(String uid) async {
    QuerySnapshot querySnapshot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    return querySnapshot.documents[0]['image'];
  }

  static Future<void> addComment(String id, String type, String commentId,
      String uid, String comment, String commentParentId) async {
    List pageList;

    QuerySnapshot docSnapShot = await db
        .collection('Comments')
        .where('xmap_id', isEqualTo: id)
        .where('collection_type', isEqualTo: type)
        .where('comment_id', isEqualTo: commentId)
        .getDocuments();

    if (docSnapShot.documents[0]['contents'] == null ||
        docSnapShot.documents[0]['contents'].length == 0) {
      pageList = [];
    } else {
      pageList = docSnapShot.documents[0]['contents'].toList();
    }

    DateTime nowTime = DateTime.now();
    String comid = pageList.length.toString();
    pageList.add({
      'uid': uid,
      'content': comment,
      'id': comid,
      'parent_id': commentParentId,
      'createdAt': nowTime.toString(),
    });

    docSnapShot.documents[0].reference.updateData({'contents': pageList});
  }

  static Future<void> addCommentNumber(String xmapid, String type,
      String sectionNumber, String sectionType) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot querySnapshot = await db
        .collection("XmapInfo")
        .where('xmapID', isEqualTo: xmapid)
        .where('type', isEqualTo: type)
        .getDocuments();

    var list = querySnapshot.documents[0]['page_order'].toList();
    for (int i = 0; i < list.length; i++) {
      if (list[i]['uid'] == uid &&
          list[i]['section_number'] == sectionNumber 
          ) {
        list[i]['comment_number'] =
            (int.parse(list[i]['comment_number']) + 1).toString();
        break;
      }
    }
    querySnapshot.documents[0].reference.updateData({'page_order': list});
  }
}
