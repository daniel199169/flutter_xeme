import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xenome/models/styled_quad.dart';
import 'package:xenome/utils/session_manager.dart';
import 'basic_firebase.dart';

class QuadExamplesManager {
  List<StyledQuad> quadExamplesList;

  QuadExamplesManager({this.quadExamplesList});

  factory QuadExamplesManager.fromJSON(Map<dynamic, dynamic> json) {
    return QuadExamplesManager(quadExamplesList: parsequadexamples(json));
  }

  static List<StyledQuad> parsequadexamples(quadexamplesJSON) {
    var rList = quadexamplesJSON['QuadExamples'] as List;
    List<StyledQuad> titleList =
        rList.map((data) => StyledQuad.fromJson(data)).toList();
    return titleList;
  }

  static Future<List<StyledQuad>> getQuadExamplesList() async {
    
    QuerySnapshot docSnapShot = await db
        .collection('QuadExamples')
            .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    }
    List<StyledQuad> _titleList = [];
    var list = docSnapShot.documents[0]['title_list'] as List;
    for (var item in list) {
      var data = new StyledQuad.fromJson(item);
      _titleList.add(data);
    }
    return _titleList;
  }

  static Future<int> getTitlei() async {
    
    QuerySnapshot docSnapShot = await db
    .collection('QuadExamples')
    .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0){
      return 0;
    }
    
    return docSnapShot.documents[0]['titlei'];
  }


  static Future<void> update(List<StyledQuad> titleList, int titlei) async {
    
    String uid = SessionManager.getUserId();
    QuerySnapshot docSnapShot = await db
        .collection('QuadExamples')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    List data = [];
    for (StyledQuad item in titleList){
      data.add(item.toJson());
    }
    docSnapShot.documents[0].reference.updateData({'title_list': data, 'titlei': titlei});
  }
}
