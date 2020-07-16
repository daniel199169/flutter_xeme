import 'package:cloud_firestore/cloud_firestore.dart';
import 'basic_firebase.dart';
import 'package:xenome/models/xmap.dart';

class FeaturedManager {
  static getTopXmapInfo() async {
    QuerySnapshot querySnapshot = await db
        .collection("FeaturedXmap")
        .where('order', isEqualTo: "top")
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      String image = querySnapshot.documents[0]['image'];
      String title = querySnapshot.documents[0]['title']['title'];
      String subtitle = querySnapshot.documents[0]['subtitle']['title'];
      String titleIsBold = querySnapshot.documents[0]['title']['isBold'].toString();
      String titleSize = querySnapshot.documents[0]['title']['size'].toString();
      String subtitleIsBold = querySnapshot.documents[0]['subtitle']['isBold'].toString();
      String subtitleSize = querySnapshot.documents[0]['subtitle']['size'].toString();
      String titleColor =
          querySnapshot.documents[0]['title']['color'].toString();
      String subtitleColor =
          querySnapshot.documents[0]['subtitle']['color'].toString();
      String id = querySnapshot.documents[0]['id'];
      String positionY = querySnapshot.documents[0]['position']['y'];
      String position1Y = querySnapshot.documents[0]['position1']['y'];
     
      var xmapInfo = [];
      xmapInfo.add(image);
      xmapInfo.add(title);
      xmapInfo.add(subtitle);
      xmapInfo.add(titleColor);
      xmapInfo.add(subtitleColor);
      xmapInfo.add(id);
      xmapInfo.add(positionY);
      xmapInfo.add(position1Y);
      xmapInfo.add(titleIsBold);
      xmapInfo.add(titleSize);
      xmapInfo.add(subtitleIsBold);
      xmapInfo.add(subtitleSize);
      

      return xmapInfo;
    }
  }
 

  static getFeaturedUserId(String pageId) async {
    QuerySnapshot querySnapshot = await db
        .collection("FeaturedXmap")
        .where('id', isEqualTo: pageId)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return [];
    } else {
      return querySnapshot.documents[0]['uid'];
    }
  }

  static Future<XmapCoverImage> getData(String id, String type) async {
    QuerySnapshot querySnapshot =
        await db.collection(type).where('id', isEqualTo: id).getDocuments();
    XmapCoverImage _viewer = XmapCoverImage.fromJson(querySnapshot.documents[0].data);
    return _viewer;
  }
  static getAvatarImage(String uid) async {

    QuerySnapshot docSnapShot = await db
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (docSnapShot == null || docSnapShot.documents.length == 0) {
      return [];
    } else {
      var avatarImage = docSnapShot.documents[0]['image'];
      return avatarImage;
    }
  }
}

 
