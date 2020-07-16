class XmapInfo {
  
  String xmapID;
  String type;
  XmapInfo({
    this.type,
    this.xmapID,
  });

  XmapInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    xmapID = json['xmapID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['xmapID'] = this.xmapID;

    return data;
  }
}
