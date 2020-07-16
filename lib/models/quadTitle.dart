class QuadTitleModel {
 
  String title;
  String color;
  String labelOne;
  String labelTwo;
  String labelThree;
  String labelFour;
  String description;
  String tag;
  String reference;
  

  QuadTitleModel({
    this.title = '',
    this.color = '',
    this.labelOne = '',
    this.labelTwo = '',
    this.labelThree = '',
    this.labelFour = '',
    this.description = '',
    this.tag = '',
    this.reference = '',
  });

  QuadTitleModel.fromJson(Map<dynamic, dynamic> json) {
    
    title = json['title'];
    color = json['color'];
    labelOne = json['labelOne'];
    labelTwo = json['labelTwo'];
    labelThree = json['labelThree'];
    labelFour = json['labelFour'];
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
    data['labelThree'] = this.labelThree;
    data['labelFour'] = this.labelFour;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['reference'] = this.reference;
    return data;
  }
}
