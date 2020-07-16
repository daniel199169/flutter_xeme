import 'package:flutter/material.dart';

const String ANIMATED_SPLASH = '/SplashScreen', PROFILE = '/SettingScreen';
const Color primaryColor = Color.fromRGBO(213, 67, 106, 1.0);
const Color secondaryColor = Color.fromRGBO(5, 0, 78, 1.0);
const Color thirdColor = Color.fromRGBO(251, 133, 133, 1.0);
const Color fourthColor = Color.fromRGBO(167, 167, 170, 1.0);
const Color customButtonColor = Colors.orange;

ShapeBorder customButtonShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
    bottomLeft: Radius.circular(10.0),
    bottomRight: Radius.circular(10.0),
  ),
);

const double font_size_caption = 40.0;

const double title_font = 20.0;
