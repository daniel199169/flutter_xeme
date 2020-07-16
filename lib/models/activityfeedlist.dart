// import 'package:xenome/models/decorated_text.dart';
// import 'postion.dart';

class ActivityFeedList {
  String userName;
  String userImageUrl;
  String postUserName;
  String type;
  String content;
  // DateTime createdAt;

  ActivityFeedList({this.userName, this.userImageUrl, this.postUserName, this.type,this.content});

  // ActivityFeed.fromJson(Map<String, dynamic> json) {
  //   uid = json['uid'];
  //   postUid = json['postUid'];
  //   type = json['type'];
  //   content = json['content'];
  //   // createdAt = json['createdAt'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['image'] = this.image;
  //   data['position'] = this.position.toJson();
  //   data['subtitle'] = this.subtitle.toJson();
  //   data['title'] = this.title.toJson();
  //   data['uid'] = this.uid;
  //   return data;
  // }
}
