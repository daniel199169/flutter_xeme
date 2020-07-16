class StyledQuad {
  String title;
  String sub1title;
  String sub2title;
  String sub3title;
  String sub4title;

  StyledQuad({
    this.title,
    this.sub1title,
    this.sub2title,
    this.sub3title,
    this.sub4title,
  });

  factory StyledQuad.fromJson(Map<dynamic, dynamic> parsedJson) {
    return StyledQuad(
        title: parsedJson['title'],
        sub1title: parsedJson['sub1title'],
        sub2title: parsedJson['sub2title'],
        sub3title: parsedJson['sub3title'],
        sub4title: parsedJson['sub4title']);
  }

  Map<dynamic, dynamic> toJson() => {
    'title': title,
    'sub1title': sub1title,
    'sub2title': sub2title,
    'sub3title': sub3title,
    'sub4title': sub4title,
  };
}
