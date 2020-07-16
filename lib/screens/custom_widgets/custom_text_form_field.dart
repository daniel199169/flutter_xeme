import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final int maxLines;
  final TextEditingController controller;

  CustomTextFormField({this.label, this.maxLines = 1, this.controller});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(14.0)),
      child: TextFormField(
        maxLines: widget.maxLines,
        style: TextStyle(
          fontFamily: 'Roboto Reqular',
          color: Color(0xFFFFFFFF),
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: 16,
            color: Color(0xFF868E9C),
            //color: myEmailFocusNode.hasFocus ? Color(0xFFFFFFFF) : Color(0xFF868E9C)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
                width: 1, color: Color(0xFFFFFFFF), style: BorderStyle.solid),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
                width: 1, color: Color(0xFF868E9C), style: BorderStyle.solid),
          ),
        ),
      ),
    );
  }
}
