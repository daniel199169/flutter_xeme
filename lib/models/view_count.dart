class ViewCount {
  String uid;
  String commentID;
  String viewNumber;
  String commentNumber;

  ViewCount({
    this.uid = '',
    this.commentID = '',
    this.viewNumber = '',
    this.commentNumber = '',
  });

  ViewCount.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    commentID = json['commentID'];
    viewNumber = json['view_number'];
    commentNumber = json['comment_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['commentID'] = this.commentID;
    data['view_number'] = this.viewNumber;
    data['comment_number'] = this.commentNumber;

    return data;
  }
}
