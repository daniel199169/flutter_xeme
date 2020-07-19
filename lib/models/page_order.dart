class PageOrder {
  String pageName;
  String subOrder;
  String commentID;

  PageOrder({this.pageName = '', this.subOrder = '', this.commentID = ''});
  PageOrder.fromJson(Map<dynamic, dynamic> json) {
    pageName = json['page_name'];
    subOrder = json['sub_order'];
    commentID = json['comment_id'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['page_name'] = this.pageName;
    data['sub_order'] = this.subOrder;
    data['comment_id'] = this.commentID;

    return data;
  }
}
