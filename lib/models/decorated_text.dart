import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:xenome/utils/string_helper.dart';

class DecoratedText {
  String title;
  Color color;
  double size;
  bool isBold;

  DecoratedText(
      {this.title = '',
      this.color = Colors.white,
      this.size = 30,
      this.isBold = true});

  DecoratedText.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    color = intToColor(json['color'] as int);
    size = double.parse(json['size'].toString());
    isBold = json['isBold'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['title'] = this.title;
    data['color'] = colorToInt(this.color);
    data['size'] = this.size;
    data['isBold'] = this.isBold;
    return data;
  }
}
