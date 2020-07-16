import 'package:flutter/material.dart';

int colorToInt(Color color) {
  String colorString = color.toString(); // Color(0x12345678)
  String valueString =
      colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
  int value = int.parse(valueString, radix: 16);
  return value;
}

Color intToColor(int value) {
  return new Color(value);
}
