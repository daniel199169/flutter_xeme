class Follow {
  String uid;
  Follow({this.uid});
  Follow.fromJson(Map<String, dynamic> json) {
    uid = json['following_uid'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['following_uid'] = this.uid;
    return data;
  }
}