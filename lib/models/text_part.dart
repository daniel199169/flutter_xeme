class TextPartModel{
  String title;
  String text;
  String description;
  String tag;
  String reference;


  TextPartModel({this.title = '', this.text = '' , this.description = '', this.tag = '', this.reference = ''});
  TextPartModel.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    text = json['text'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['title'] = this.title;
    data['text'] = this.text;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
