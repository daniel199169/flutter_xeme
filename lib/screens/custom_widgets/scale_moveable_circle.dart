import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/models/chartCirclePosition.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/utils/string_helper.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';

class ScaleMoveableCircle extends StatefulWidget {
//  BuildContext context;
  String id;
  String type;
  String subOrder;

  Function getScaleHeatmap;

  ScaleMoveableCircle(this.id, this.type, this.subOrder, this.getScaleHeatmap);

  @override
  State<StatefulWidget> createState() {
    return _ScaleMoveableCircleState();
  }
}

class _ScaleMoveableCircleState extends State<ScaleMoveableCircle> {
  double xPosition;
  double yPosition;
  double borderWidth;
  String vote = "";
  int circleBorderColor = 4278190080;
  int circlebackgroundcolor = 4278190080;
  int flag = 0;

  int flagMoveEnd = 0;
  double midWidth = 0.0;
  double midHeight = 0.0;
  Timer _newTimer;

  @override
  void initState() {
    super.initState();

    if (SessionManager.getUserId() != '') {
      getPositionList();
    }
    borderWidth = 2.0;

    getCircleColor();
    xPosition = SessionManager.getMediaWidth() * 0.36;
    yPosition = SessionManager.getMediaHeight() * 0.335;
    midWidth = xPosition;
    midHeight = yPosition;
  }

  getPositionList() async {
    CirclePosition _position = await ViewerManager.getScalePosition(
        widget.id, widget.type, int.parse(widget.subOrder));
    setState(() {
      if (_position == null) {
        flag = 0;
      } else {
        flag = 1;
        yPosition = _position.y;
      }
    });
  }

  getCircleColor() async {
    String _circleBorderColor = await ViewerManager.getScaleCircleColor(
        widget.id, widget.type, int.parse(widget.subOrder));
    String _circlebackgroundcolor = "25" + _circleBorderColor;
    String _circleCustomBorderColor = "FF" + _circleBorderColor;

    setState(() {
      circleBorderColor = int.parse(_circleCustomBorderColor, radix: 16);
      circlebackgroundcolor = int.parse(_circlebackgroundcolor, radix: 16);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          if (SessionManager.getUserId() != '') {
            if (flagMoveEnd == 0) {
              if (flag == 0) {
                setState(() {
                  borderWidth = 8.0;

                  yPosition += tapInfo.delta.dy;
                  if (yPosition >
                      MediaQuery.of(context).size.height * 0.8 - 58 - 43) {
                    yPosition =
                        MediaQuery.of(context).size.height * 0.8 - 58 - 43;
                  }
                  if (yPosition < 58 - 43) {
                    yPosition = 15;
                  }
                });
              }
            }
          } else {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.6,
                    child: Container(
                      color: Color(0xFF737373),
                      height: 500,
                      child: Container(
                        child: BottomSheetWidget(),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                  );
                });
          }
        },
        onPanEnd: (tapInfo) {
          if (SessionManager.getUserId() != '') {
            if (flagMoveEnd == 0) {
              if (flag == 0) {
                setState(() {
                  borderWidth = 2.0;

                  if (yPosition < midHeight) {
                    vote = "1";
                  } else {
                    vote = "2";
                  }
                });

                ChartCirclePosition chartPosition = ChartCirclePosition(
                    x: xPosition,
                    y: yPosition,
                    uid: SessionManager.getUserId(),
                    minOpacity: 5,
                    subOrder: widget.subOrder,
                    vote: vote);
                CirclePosition position = CirclePosition(
                    x: xPosition,
                    y: yPosition,
                    uid: SessionManager.getUserId(),
                    subOrder: widget.subOrder);

                if (_newTimer != null) {
                  _newTimer.cancel();
                }

                _newTimer =
                    new Timer(const Duration(milliseconds: 1000), () async {
                  await ViewerManager.updateScaleHeatmap(
                      chartPosition, widget.id, widget.type, widget.subOrder);
                  await ViewerManager.updateScalePosition(
                      position, widget.id, widget.type, widget.subOrder);
                  widget.getScaleHeatmap(MediaQuery.of(context).size);
                  setState(() {
                    flag = 1;
                    flagMoveEnd = 1;
                  });
                });
              } else {
                Timer(const Duration(milliseconds: 1000), () {
                  widget.getScaleHeatmap(MediaQuery.of(context).size);
                });
              }
            }
          }
        },
        child: flagMoveEnd == 0
            ? Container(
                child: new CircleAvatar(
                  child: new Text(''),
                  backgroundColor:
                      intToColor(circlebackgroundcolor).withOpacity(0.4),
                  radius: 40.0,
                ),
                width: 100.0,
                height: 100.0,
                padding: const EdgeInsets.all(0.0),
                decoration: new BoxDecoration(
                  color: Colors.transparent, // border color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: intToColor(circleBorderColor),
                    width: borderWidth,
                  ),
                ))
            : Container(
                child: new CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40.0,
                ),
                width: 100.0,
                height: 100.0,
                padding: const EdgeInsets.all(0.0),
                decoration: new BoxDecoration(
                  color: Colors.transparent, // border color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFB4C5D6),
                    width: borderWidth,
                  ),
                ),
              ),
      ),
    );
  }
}
