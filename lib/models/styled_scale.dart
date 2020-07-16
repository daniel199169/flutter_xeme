class StyledScale {
  String title;
  String sub1title;
  String sub2title;

  StyledScale({
    this.title,
    this.sub1title,
    this.sub2title,
  });

  factory StyledScale.fromJson(Map<dynamic, dynamic> parsedJson) {
    return StyledScale(
        title: parsedJson['title'],
        sub1title: parsedJson['sub1title'],
        sub2title: parsedJson['sub2title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sub1title'] = this.sub1title;
    data['sub2title'] = this.sub2title;
    return data;
  }
}
