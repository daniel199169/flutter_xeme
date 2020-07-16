import 'package:flutter/material.dart';
import 'package:xenome/utils/string_helper.dart';

class StyledBuildText {
  String title;
  String subTitle;
  Color color;
  Color subColor;
  double size;
  double subSize;
  bool isBold;
  bool isSubBold;
  double yPosition;

  StyledBuildText(
      {this.title,
      this.subTitle,
      this.color,
      this.subColor,
      this.size,
      this.subSize,
      this.isBold,
      this.isSubBold,
      this.yPosition});

  StyledBuildText.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
    color = intToColor(json['color'] as int);
    subColor = intToColor(json['subColor'] as int);
    size = json['size'];
    subSize = json['subSize'];
    isBold = json['isBold'];
    isSubBold = json['isSubBold'];
    yPosition = json['yPosition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['color'] = colorToInt(this.color);
    data['subColor'] = colorToInt(this.subColor);
    data['size'] = this.size;
    data['subSize'] = this.subSize;
    data['isBold'] = this.isBold;
    data['isSubBold'] = this.isSubBold;
    data['yPosition'] = this.yPosition;
    return data;
  }
}
