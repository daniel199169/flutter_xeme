import 'package:flutter/material.dart';
import 'package:xenome/screens/not_si/not_si_create_profile.dart';

class BottomSheetWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        children: <Widget>[
          NotSiCreateProfile(),
        ],
      ),
    );
  }
}
