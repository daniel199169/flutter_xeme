class QuadChart {
  String quadtitle;
  String quadcircleposition;
  String quadpositionlist;
  String quadheatmap;

  QuadChart({
    this.quadtitle,
    this.quadcircleposition,
    this.quadpositionlist,
    this.quadheatmap,
  });

  factory QuadChart.fromJson(Map<dynamic, dynamic> parsedJson) {
    return QuadChart(
        quadtitle: parsedJson['quadtitle'],
        quadcircleposition: parsedJson['quadcircleposition'],
        quadpositionlist: parsedJson['quadpositionlist'],
        quadheatmap: parsedJson['quadheatmap']);
  }

  Map<dynamic, dynamic> toJson() => {
        'quadtitle': quadtitle,
        'quadcircleposition': quadcircleposition,
        'quadpositionlist': quadpositionlist,
        'quadheatmap': quadheatmap
      };
}
