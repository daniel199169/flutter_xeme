class ViewCount {
  String uid;
  String sectionNumber;
  String sectionType;
  String viewNumber;
  String commentNumber;

  ViewCount({
    this.uid = '',
    this.sectionNumber = '',
    this.sectionType = '',
    this.viewNumber = '',
    this.commentNumber = '',
  });

  ViewCount.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    sectionNumber = json['section_number'];
    sectionType = json['section_type'];
    viewNumber = json['view_number'];
    commentNumber = json['comment_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['section_number'] = this.sectionNumber;
    data['section_type'] = this.sectionType;
    data['view_number'] = this.viewNumber;
    data['comment_number'] = this.commentNumber;

    return data;
  }
}
