import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final int maxLines;
  CustomTextFormField({this.label, this.maxLines = 1});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          color: Color(0xFF272D3A),
          borderRadius: new BorderRadius.circular(12.0)),
      child: TextFormField(
        maxLines: widget.maxLines,
        style: TextStyle(
          fontFamily: 'Roboto Reqular',
          color: Color(0xFF868E9C),
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            labelText: widget.label,
            labelStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFF868E9C),
            )),
      ),
    );
  }
}
