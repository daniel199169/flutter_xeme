import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // Used for the caption of register and login page:
      caption: base.caption.copyWith(
        fontFamily: 'Roboto Medium',
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),

      // Used for the description of register and login page:
      subtitle: base.subtitle.copyWith(
        fontFamily: 'Roboto Medium',
        color: Color(0xFF868E9C),
        fontSize: 12,
      ),

      // Used for the descriptin:
      headline: base.headline.copyWith(
        fontFamily: 'Roboto Medium',
        fontWeight: FontWeight.w500,
        color: Color(0xFFFFFFFF),
        fontSize: 12,
      ),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xFFFFF8E1),
    indicatorColor: const Color(0xFF807A6B),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    accentColor: const Color(0xFFFFF8E1),
    iconTheme: IconThemeData(
      color: const Color(0xFFCCC5AF),
      size: 20.0,
    ),
    buttonColor: Colors.white,
  );
}
