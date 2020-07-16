class SetupInfo{
  String title;
  String description;
  String global;
  String privateEmailList;


  SetupInfo({this.title = '', this.description = '', this.global = 'public', this.privateEmailList = ''});
  SetupInfo.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    description = json['description'];
    global = json['global'];
    privateEmailList = json['private_email_list'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['global'] = this.global;
    data['private_email_list'] = this.privateEmailList;
    return data;
  }
}
