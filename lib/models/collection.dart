class Collection {
  String image;
  String title;
  String videoURL;
  String link;
  String sectionType;
  String description;
  String tag;
  String reference;

  Collection(
      {this.image = '',
      this.title = '',
      this.videoURL = '',
      this.sectionType = '',
      this.link = '',
      this.description = '',
      this.tag = '',
      this.reference = ''});

  Collection.fromJson(Map<dynamic, dynamic> json) {
    image = json['image'];
    title = json['title'];
    videoURL = json['videoURL'];
    sectionType = json['sectionType'];
    link = json['link'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['videoURL'] = this.videoURL;
    data['link'] = this.link;
    data['sectionType'] = this.sectionType;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
