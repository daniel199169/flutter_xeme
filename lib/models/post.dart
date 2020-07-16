import 'package:xenome/models/postion.dart';

class Post {
  Position position;
  String title;
  String subTitle;
  String introduction;
  String imageUrl;

  Post(position, title, subTitle, introduction, imageUrl);

  Post.fromJson(Map<String, dynamic> json) {
    position = Position.fromJson(json['position']);
    title = json['title']?.toString() ?? '';
    subTitle = json['sub_title']?.toString() ?? '';
    introduction = json['introduction']?.toString() ?? '';
    imageUrl = json['image_url']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = position.toJson();
    data['title'] = title;
    data['sub_title'] = subTitle;
    data['introduction'] = introduction;
    data['image_url'] = imageUrl;
    return data;
  }
}
