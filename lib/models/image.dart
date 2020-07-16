class ImageModel {
  
  String imageURL;
  String link;
  String description;
  String tag;
  String reference;

  ImageModel({this.imageURL = '', this.link = '', this.description = '', this.tag = '', this.reference = ''});
  ImageModel.fromJson(Map<dynamic, dynamic> json) {
    imageURL = json['image_url'];
    link = json['link'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    
    data['image_url'] = this.imageURL;
    data['link'] = this.link;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
