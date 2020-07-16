import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:xenome/utils/session_manager.dart';

import 'basic_firebase.dart';

class ScaleExampleManager{
  StyledScale scaleExample;
  ScaleExampleManager({this.scaleExample});

  static Future<StyledScale> getScaleExample() async {
    
    QuerySnapshot docSnapShot = await db
        .collection('ScaleExamples')
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return null;
    }

    StyledScale _titleList;
    _titleList = new StyledScale.fromJson(docSnapShot.documents[0]['title_list']);
    return _titleList;
  }
  
  static Future<int> getTitlei() async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
    .collection('ScaleExamples')
    .where('uid', isEqualTo: uid)
    .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0){
      return 0;
    }
    return docSnapShot.documents[0]['titlei'];
  }

  static Future<void> updateScale(StyledScale titleList, int titlei) async {
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('ScaleExamples')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    docSnapShot.documents[0].reference.updateData({'title_list': titleList.toJson(), 'titlei': titlei});
  }
}