import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/utils/session_manager.dart';

class SubCustomMoveableBuildder extends StatefulWidget {
  SubCustomMoveableBuildder( this.child, this.position, this.updatePosition, this.id, this.type);
  final String id;
  final String type;
//  BuildContext context;
  Widget child;
  Position position;
  Function updatePosition;

  
  @override
  State<StatefulWidget> createState() {
    return _SubCustomMoveableBuildderState();
  }
}

class _SubCustomMoveableBuildderState extends State<SubCustomMoveableBuildder> {
  double xPosition = 0;
  double yPosition = 0;
  String uid = "";

  @override
  void initState() {
    super.initState();
    uid = SessionManager.getUserId();

    getPositionList();

    if (widget.position != null) {
      xPosition = widget.position.x;
      yPosition = widget.position.y;
    } else {
//       yPosition = MediaQuery.of(context).size.height / 2;
    }
  }

  getPositionList() async {
    var _buildder = await BuildderManager.getData(uid, widget.id, widget.type);
    setState(() {
      xPosition = 35.456;
      yPosition = 67.45;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (yPosition == 0 && widget.position == null) {
      yPosition = MediaQuery.of(context).size.height / 4;
    }
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        onPanEnd: (tapInfo) {
          Position position = Position(x: xPosition, y: yPosition);
          BuildderManager.updatePosition1(position, uid, widget.id, widget.type);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
