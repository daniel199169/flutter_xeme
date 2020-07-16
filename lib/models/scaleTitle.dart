class ScaleTitleModel {
  String title;
  String color;
  String labelOne;
  String labelTwo;
  String description;
  String tag;
  String reference;

  ScaleTitleModel({
    this.title = '',
    this.color = '',
    this.labelOne = '',
    this.labelTwo = '',
    this.description = '',
    this.tag = '',
    this.reference = '',
  });

  ScaleTitleModel.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    color = json['color'];
    labelOne = json['labelOne'];
    labelTwo = json['labelTwo'];
    description = json['description'];
    tag = json['tag'];
    reference = json['reference'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['title'] = this.title;
    data['color'] = this.color;
    data['labelOne'] = this.labelOne;
    data['labelTwo'] = this.labelTwo;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
