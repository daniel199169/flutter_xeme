import 'package:xenome/models/setup_info.dart';
import 'package:xenome/models/cover_image.dart';

class Trending {
  String id;
  CoverImageModel image;
  SetupInfo title;
  SetupInfo description;
  SetupInfo global;
  SetupInfo privateEmailList;
  String uid;

  Trending(
      {this.id,
      this.image,
      this.title,
      this.description,
      this.global,
      this.privateEmailList,
      this.uid});

  Trending.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = CoverImageModel.fromJson(json['cover_image']);
    title = SetupInfo.fromJson(json['SetupInfo']);
    description = SetupInfo.fromJson(json['SetupInfo']);
    global = SetupInfo.fromJson(json['SetupInfo']);
    privateEmailList = SetupInfo.fromJson(json['SetupInfo']);
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image.toJson();
    data['title'] = this.title.toJson();
    data['description'] = this.description.toJson();
    data['global'] = this.global.toJson();
    data['private_email_list'] = this.privateEmailList.toJson();
    data['uid'] = this.uid;
    return data;
  }
}
