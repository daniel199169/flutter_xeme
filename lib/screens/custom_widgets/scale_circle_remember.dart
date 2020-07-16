import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/models/circleposition.dart';
import 'dart:async';

class ScaleCircleRemember extends StatefulWidget {
//  BuildContext context;
  String id;
  String type;
  String subOrder;

  Function getScaleHeatmap;

  ScaleCircleRemember(this.id, this.type, this.subOrder, this.getScaleHeatmap);

  @override
  State<StatefulWidget> createState() {
    return _ScaleCircleRememberState();
  }
}

class _ScaleCircleRememberState extends State<ScaleCircleRemember> {
  double xPosition;
  double yPosition;
  double borderWidth;

  @override
  void initState() {
    super.initState();
    getPositionList();

    borderWidth = 2.0;

    heatmap();
    
  }
  
  heatmap() async{
   Timer(const Duration(milliseconds: 1000), () {
      widget.getScaleHeatmap(MediaQuery.of(context).size);
    });
  }

  getPositionList() async {
    CirclePosition _position = await ViewerManager.getScalePosition(
        widget.id, widget.type, int.parse(widget.subOrder));
    setState(() {
      xPosition = _position.x;
      yPosition = _position.y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: xPosition != 0.0 && xPosition != null
          ? Container(
              child: new CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30.0,
              ),
              width: 85.0,
              height: 85.0,
              padding: const EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: Colors.transparent, // border color
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFFB4C5D6),
                  width: borderWidth,
                ),
              ),
            )
          : Container(),
    );
  }
}
