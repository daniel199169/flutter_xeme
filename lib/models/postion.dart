class Position {
  double x;
  double y;

  Position({this.x = -1.4, this.y = 250});

  Position.fromJson(Map<dynamic, dynamic> json) {
    x = double.parse(json['x'].toString());
    y = double.parse(json['y'].toString());
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['x'] = this.x.toString();
    data['y'] = this.y.toString();
    return data;
  }
}
