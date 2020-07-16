class VimeoModel {
  String image;
  String title;
  String vimeoURL;
  String description;
  String tag;
  String reference;

  VimeoModel(
      {this.image = '',
      this.title = '',
      this.vimeoURL = '',
      this.description = '',
      this.tag = '',
      this.reference = '',
      });
  VimeoModel.fromJson(Map<dynamic, dynamic> json) {
    image = json['image'];
    title = json['title'];
    vimeoURL = json['videoURL'];
     description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['videoURL'] = this.vimeoURL;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
