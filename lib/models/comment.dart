class Comment{
  String uid;
  String content;
  String id;
  String parentId;
  String createdAt;
  Comment({this.uid = '', this.content = '', this.id='', this.parentId = '', this.createdAt});

  Comment.fromJson(Map<dynamic, dynamic> json){
    uid = json['uid'];
    content = json['content'];
    id = json['id'];
    parentId = json['parent_id'];
    createdAt = json['createdAt'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['uid'] = this.uid;
    data['content'] = this.content;
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}