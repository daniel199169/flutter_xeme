class CoverImageModel {
  String imageURL;
  String description;
  String tag;
  String reference;

  CoverImageModel({this.imageURL='', this.description = '', this.tag = '', this.reference = ''});
  CoverImageModel.fromJson(Map<dynamic, dynamic> json) {
    imageURL = json['image_url'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['image_url'] = this.imageURL;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
