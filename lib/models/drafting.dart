import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/cover_image.dart';

class Drafting {
  String id;
  CoverImageModel image;
  SetupInfo title;
  SetupInfo description;
  String uid;
  String xmaptype;

  Drafting(
      {this.id,
      this.image,
      this.title,
      this.description,
      this.uid,
      this.xmaptype});

  Drafting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = CoverImageModel.fromJson(json['cover_image']);
    title = SetupInfo.fromJson(json['SetupInfo']);
    description = SetupInfo.fromJson(json['SetupInfo']);
    uid = json['uid'];
    xmaptype = json['xmaptype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image.toJson();
    data['title'] = this.title.toJson();
    data['description'] = this.description.toJson();
    data['uid'] = this.uid;
    data['xmaptype'] = this.xmaptype;
    return data;
  }
}
