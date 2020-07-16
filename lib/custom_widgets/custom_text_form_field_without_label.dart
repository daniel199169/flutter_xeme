import 'package:flutter/material.dart';

class CustomTextFormFieldWithoutLabel extends StatefulWidget {
  final String hintTitle;
  final ValueChanged<String> onChanged;
  final double fontSize;

  CustomTextFormFieldWithoutLabel(
      {this.hintTitle, this.fontSize, this.onChanged});
  @override
  _CustomTextFormFieldWithoutLabelState createState() =>
      _CustomTextFormFieldWithoutLabelState();
}

class _CustomTextFormFieldWithoutLabelState
    extends State<CustomTextFormFieldWithoutLabel> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (val) {
        widget.onChanged(val);
      },
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Roboto Reqular',
        fontWeight: FontWeight.w900,
        fontSize: widget.fontSize,
        color: Colors.white,
      ),
      decoration: InputDecoration(
//        contentPadding: E,
        hintText: widget.hintTitle,
        hintStyle: TextStyle(
          fontFamily: 'Roboto Black',
          fontWeight: FontWeight.w900,
          fontSize: widget.fontSize,
          color: Colors.white,
        ),
        disabledBorder: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          //borderSide:
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          //borderSide:
        ),
      ),
    );
  }
}
