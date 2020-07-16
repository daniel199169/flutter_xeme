class YoutubeModel{
  String image;
  String title;
  String youtubeURL;
  String description;
  String tag;
  String reference;


  YoutubeModel({this.image = '',this.title = '', this.youtubeURL = '', this.description = '', this.tag = '' , this.reference = ''});
  YoutubeModel.fromJson(Map<dynamic, dynamic> json) {
    image = json['image'];
    title = json['title'];
    youtubeURL = json['youtubeURL'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['youtubeURL'] = this.youtubeURL;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
