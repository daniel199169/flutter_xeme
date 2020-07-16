class CirclePosition {
  double x;
  double y;
  String uid;
  String subOrder;

  CirclePosition({this.x = -1.4, this.y = 250, this.uid, this.subOrder = '0'});

  CirclePosition.fromJson(Map<dynamic, dynamic> json) {
    x = double.parse(json['x'].toString());
    y = double.parse(json['y'].toString());
    uid = json['uid'];
    subOrder = json['subOrder'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['x'] = this.x.toString();
    data['y'] = this.y.toString();
    data['uid'] = this.uid;
    data['subOrder'] = this.subOrder;
    return data;
  }
}
