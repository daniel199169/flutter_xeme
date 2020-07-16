
class ActivityFeedModel {

  String uid;
  String type;
  String content;
  String thumbnail;
  String xmapName;
  String createdAt;
  String postUid;
  String xmapId;
  String xmapType;

  ActivityFeedModel({this.uid, this.type, this.content, this.thumbnail, this.xmapName, this.createdAt, this.postUid, this.xmapId, this.xmapType });

  ActivityFeedModel.fromJson(Map<String, dynamic> json) {

    uid = json['uid'];
    type = json['type'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    xmapName = json['xmapName'];
    createdAt = json['createdAt'];
    postUid = json['postUid'];
    xmapId = json['xmapId'];
    xmapType = json['xmapType'];
    
  }

  Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['uid'] = this.uid;
     data['type'] = this.type;
     data['content'] = this.content;
     data['thumbnail'] = this.thumbnail;
     data['xmapName'] = this.xmapName;
     data['createdAt'] = this.createdAt;
     data['postUid'] = this.postUid;
     data['xmapId'] = this.xmapId;
     data['xmapType'] = this.xmapType;
     

     return data;
  }

}
