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

  final Function callback;

  QuadMoveableCircle(this.id, this.type, this.subOrder, this.callback);

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
  int diffsc = 0;
  int flagEndStart = 0;
  int flagMoveEnd = 0;
  double midWidth = 0.0;
  double midHeight = 0.0;
  double dWidth = 0.0;
  double dHeight = 0.0;
  DateTime dateTimeUpdate;
  DateTime dateTimeEnd;
  ChartCirclePosition chartPosition;
  CirclePosition position;

  int timerNo = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();

    if (SessionManager.getUserId() != '') {
      getPositionList();
    }

    borderWidth = 2.0;
    getCircleColor();

    midWidth = (SessionManager.getMediaWidth() - 20) * 0.5 - 50;
    midHeight = (SessionManager.getMediaHeight() - 20) * 0.4 - 40;
    dWidth = SessionManager.getMediaWidth() - 20;
    dHeight = (SessionManager.getMediaHeight() - 20) * 0.8;

    xPosition = midWidth;
    yPosition = midHeight;
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
        xPosition =
            num.parse(((_position.x / 100) * dWidth).toStringAsFixed(3));
        yPosition =
            num.parse(((_position.y / 100) * dHeight).toStringAsFixed(3));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanStart: (tapInfo) async {
          dateTimeUpdate = DateTime.now();

          if (dateTimeEnd != null) {
            diffsc = dateTimeUpdate.difference(dateTimeEnd).inSeconds;
            if (diffsc <= 1)
              setState(() {
                timerNo = 0;
                flagEndStart = 0;
              });
          }
        },
        onPanUpdate: (tapInfo) {
          print("++++++++++++++++++   pan update  ++++++++++++++++++++++");
          if (SessionManager.getUserId() != '') {
            if (flagMoveEnd == 0) {
              if (flag == 0) {
                if (diffsc <= 1) {
                  setState(() {
                    borderWidth = 8.0;

                    xPosition += tapInfo.delta.dx;
                    yPosition += tapInfo.delta.dy;

                    if (yPosition > dHeight - 110) {
                      yPosition = dHeight - 110;
                    }
                    if (xPosition < 20) {
                      xPosition = 20;
                    }
                    if (xPosition > MediaQuery.of(context).size.width - 130) {
                      xPosition = MediaQuery.of(context).size.width - 130;
                    }

                    if (yPosition < 20) {
                      yPosition = 20;
                    }
                  });
                }
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
                dateTimeEnd = DateTime.now();
                setState(() {
                  flagEndStart = 1;
                });

                if (diffsc <= 1) {
                  setState(() {
                    borderWidth = 2.0;

                    if (xPosition < midWidth && yPosition < midHeight) {
                      vote = "1";
                    }
                    if (xPosition > midWidth && yPosition < midHeight) {
                      vote = "2";
                    }
                    if (xPosition < midWidth && yPosition > midHeight) {
                      vote = "3";
                    }
                    if (xPosition > midWidth && yPosition > midHeight) {
                      vote = "4";
                    }
                  });
                  double xxPosition = (xPosition / dWidth) * 100;
                  xxPosition = double.parse(xxPosition.toStringAsFixed(3));
                  double yyPosition = (yPosition / dHeight) * 100;
                  yyPosition = double.parse(yyPosition.toStringAsFixed(3));

                  chartPosition = ChartCirclePosition(
                      x: xxPosition,
                      y: yyPosition,
                      uid: SessionManager.getUserId(),
                      minOpacity: 5,
                      subOrder: widget.subOrder.toString(),
                      vote: vote);
                  position = CirclePosition(
                      x: xxPosition,
                      y: yyPosition,
                      uid: SessionManager.getUserId(),
                      subOrder: widget.subOrder.toString());
                }
                if (timer == null) {
                  timer = Timer.periodic(const Duration(milliseconds: 100),
                      (Timer _) async {
                    if (flagEndStart == 1) {
                      timerNo++;

                      if (timerNo == 10) {
                        await ViewerManager.updateQuadHeatmap(chartPosition,
                            widget.id, widget.type, widget.subOrder);
                        await ViewerManager.updateQuadPosition(
                            position, widget.id, widget.type, widget.subOrder);
                        widget.callback(MediaQuery.of(context).size);
                        setState(() {
                          flag = 1;
                          flagMoveEnd = 1;
                          timerNo = 0;
                        });
                        timer.cancel();
                      }
                    }
                  });
                }
              }
            }
          }
        },
        child: flagMoveEnd == 0
            ? Container(
                child: new CircleAvatar(
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
