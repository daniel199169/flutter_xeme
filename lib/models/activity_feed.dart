class ActivityFeed{
  String uid;
  String postUid;
  String type;
  String comment;


  ActivityFeed({this.uid = '',this.postUid = '', this.type = '', this.comment = ''});
  ActivityFeed.fromJson(Map<dynamic, dynamic> json) {
    uid = json['uid'];
    postUid = json['postUid'];
    type = json['type'];
    comment = json['comment'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['uid'] = this.uid;
    data['postUid'] = this.postUid;
    data['type'] = this.type;
    data['comment'] = this.comment;
    return data;
  }
}
