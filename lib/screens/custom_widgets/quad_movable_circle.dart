import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/models/chartCirclePosition.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/utils/string_helper.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';

class QuadMoveableCircle extends StatefulWidget {
//  BuildContext context;
  String id;
  String type;
  String subOrder;

  Function getQuadHeatmap;

  QuadMoveableCircle(this.id, this.type, this.subOrder, this.getQuadHeatmap);

  @override
  State<StatefulWidget> createState() {
    return _QuadMoveableCircleState();
  }
}

class _QuadMoveableCircleState extends State<QuadMoveableCircle> {
  double xPosition;
  double yPosition;
  double borderWidth;
  String vote;
  int circleBorderColor = 4278190080;
  int circlebackgroundcolor = 4278190080;
  int flag = 0;
  int flagMoveEnd = 0;
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
  }

  getCircleColor() async {
    String _circleBorderColor = await ViewerManager.getQuadCircleColor(
        widget.id, widget.type, int.parse(widget.subOrder));
    String _circlebackgroundcolor = "25" + _circleBorderColor;
    String _circleCustomBorderColor = "FF" + _circleBorderColor;
    setState(() {
      circleBorderColor = int.parse(_circleCustomBorderColor, radix: 16);
      circlebackgroundcolor = int.parse(_circlebackgroundcolor, radix: 16);
    });
  }

  getPositionList() async {
    CirclePosition _position = await ViewerManager.getQuadPosition(
        widget.id, widget.type, int.parse(widget.subOrder));

    setState(() {
      if (_position == null) {
        flag = 0;
      } else {
        flag = 1;
        xPosition = _position.x;
        yPosition = _position.y;
      }
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
                  xPosition += tapInfo.delta.dx;
                  yPosition += tapInfo.delta.dy;

                  if (yPosition >
                      MediaQuery.of(context).size.height * 0.8 - 58 - 43) {
                    yPosition =
                        MediaQuery.of(context).size.height * 0.8 - 58 - 43;
                  }
                  if (xPosition < 58 - 43) {
                    xPosition = 15;
                  }
                  if (xPosition > MediaQuery.of(context).size.width - 58 - 58) {
                    xPosition = MediaQuery.of(context).size.width - 58 - 58;
                  }

                  if (yPosition < 58 - 43) {
                    yPosition = 15;
                  }
                  // if (yPosition >
                  //         MediaQuery.of(context).size.height * 0.8 - 58 - 43 &&
                  //     xPosition < 58 - 43) {
                  //   yPosition = MediaQuery.of(context).size.height * 0.8 - 58 - 43;
                  //   xPosition = 15;
                  // }
                  // if (yPosition >
                  //         MediaQuery.of(context).size.height * 0.8 - 58 - 43 &&
                  //     xPosition > MediaQuery.of(context).size.width - 58 - 43) {
                  //   yPosition = MediaQuery.of(context).size.height * 0.8 - 58 - 43;
                  //   xPosition = MediaQuery.of(context).size.width - 101;
                  // }
                  // if (yPosition < 58 - 43 && xPosition < 58 - 43) {
                  //   yPosition = 15;
                  //   xPosition = 15;
                  // }
                  // if (yPosition < 58 - 43 &&
                  //     xPosition > MediaQuery.of(context).size.width - 58 - 43) {
                  //   yPosition = 15;
                  //   xPosition = MediaQuery.of(context).size.width - 101;
                  // }
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
                  double midWidth = MediaQuery.of(context).size.width / 2;
                  double midHeight =
                      MediaQuery.of(context).size.height * 0.8 / 2 + 72;
                  if (xPosition < midWidth && yPosition < midHeight) {
                    vote = "1";
                  }
                  if (xPosition > midWidth && yPosition < midHeight) {
                    vote = "2";
                  }
                  if (xPosition < midWidth && yPosition > midHeight) {
                    vote = "3";
                  }
                  if (xPosition > midWidth && yPosition < midHeight) {
                    vote = "4";
                  }
                });

                ChartCirclePosition chartPosition = ChartCirclePosition(
                    x: xPosition,
                    y: yPosition,
                    uid: SessionManager.getUserId(),
                    minOpacity: 5,
                    subOrder: widget.subOrder.toString(),
                    vote: vote);
                CirclePosition position = CirclePosition(
                    x: xPosition,
                    y: yPosition,
                    uid: SessionManager.getUserId(),
                    subOrder: widget.subOrder.toString());
                ViewerManager.updateQuadHeatmap(
                    chartPosition, widget.id, widget.type, widget.subOrder);
                ViewerManager.updateQuadPosition(
                    position, widget.id, widget.type, widget.subOrder);
                Timer(const Duration(milliseconds: 1000), () {
                  widget.getQuadHeatmap(MediaQuery.of(context).size);
                });
                setState(() {
                  flag = 1;
                  flagMoveEnd = 1;
                });
              } else {
                Timer(const Duration(milliseconds: 1000), () {
                  widget.getQuadHeatmap(MediaQuery.of(context).size);
                });
              }
            }
          }
        },
        child: flagMoveEnd == 0
            ? Container(
                child: new CircleAvatar(
                  backgroundColor:
                      intToColor(circlebackgroundcolor).withOpacity(0.4),
                  radius: 30.0,
                ),
                width: 85.0,
                height: 85.0,
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
              ),
      ),
    );
  }
}
