class ChartCirclePosition {
  double x;
  double y;
  String uid;
  double minOpacity;
  String subOrder;
  String vote;


  ChartCirclePosition({this.x = -1.4, this.y = 250, this.uid, this.minOpacity = 0.01, this.subOrder = '0', this.vote = ''});

  ChartCirclePosition.fromJson(Map<dynamic, dynamic> json) {
    x = double.parse(json['x'].toString());
    y = double.parse(json['y'].toString());
    minOpacity = double.parse(json['min_opacity'].toString());
    uid = json['uid'];
    subOrder = json['subOrder'];
    vote = json['vote'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['x'] = this.x.toString();
    data['y'] = this.y.toString();
    data['min_opacity'] = this.minOpacity.toString();
    data['uid'] = this.uid;
    data['subOrder'] = this.subOrder;
    data['vote'] = this.vote;
    return data;
  }
}
