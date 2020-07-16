import 'package:xenome/models/decorated_text.dart';
import 'postion.dart';

class Recommended {
  String id;
  String image;
  Position position;
  DecoratedText subtitle;
  DecoratedText title;
  String uid;

  Recommended({this.id, this.image, this.position, this.subtitle, this.title, this.uid});

  Recommended.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    position = Position.fromJson(json['position']);
    subtitle = DecoratedText.fromJson(json['subtitle']);
    title = DecoratedText.fromJson(json['title']);
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['position'] = this.position.toJson();
    data['subtitle'] = this.subtitle.toJson();
    data['title'] = this.title.toJson();
    data['uid'] = this.uid;
    return data;
  }
}
