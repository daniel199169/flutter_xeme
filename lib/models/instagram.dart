class InstagramModel {
  
  String title;
  String instagramURL;
  String description;
  String tag;
  String reference;

  InstagramModel({
    this.title = '',
    this.instagramURL = '',
  
    this.description = '',
    this.tag = '',
    this.reference = '',
  });

  InstagramModel.fromJson(Map<dynamic, dynamic> json) {
  
    title = json['title'];
    instagramURL = json['instagramURL'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
  
    data['title'] = this.title;
    data['instagramURL'] = this.instagramURL;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
