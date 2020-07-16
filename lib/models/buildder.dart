import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/cover_image.dart';

class Buildder {
  String uid;

  Buildder({this.uid});

  Buildder.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    return data;
  }
}
