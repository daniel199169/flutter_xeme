import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/models/scaleTitle.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/screens/custom_widgets/scale_heatmap.dart';
import 'package:xenome/screens/custom_widgets/scale_moveable_circle.dart';
import 'package:xenome/screens/custom_widgets/scale_circle_remember.dart';
import 'package:xenome/screens/viewer/comments.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/utils/session_manager.dart';

import 'dart:ui' as ui;

class ViewScaleStart extends StatefulWidget {
  ViewScaleStart({this.id, this.type, this.subOrder, this.pageId});
  final String id;
  final String type;
  final String subOrder;
  final String pageId;
  @override
  _ViewScaleStartState createState() => _ViewScaleStartState();
}

class _ViewScaleStartState extends State<ViewScaleStart>
    with SingleTickerProviderStateMixin {
  final commentWidgets = List<Widget>();
  bool isSwitched = true;
  Position position;

  ScaleTitleModel scaleTitle;
  var lastComment = [];
  String commentId = '';
  double dWidth = 0.0;
  double dHeight = 0.0;

  //heatmap variables
  final scaleHeatmapWidgets = List<Widget>();
  var scaleHeatmapData = [];

  getLastComment() async {
    var _lastCommentArray = await ViewerManager.getLastComment(
        widget.id, widget.type, widget.pageId);
    setState(() {
      lastComment = _lastCommentArray;
    });

    String _commentId =
        await ViewerManager.getCommentID(widget.id, widget.type, widget.pageId);
    setState(() {
      commentId = _commentId;
    });
  }

  getScaleTitle() async {
    ScaleTitleModel _scaleTitle = await BuildderManager.getScaleTitleData(
        widget.id, widget.type, int.parse(widget.subOrder));

    setState(() {
      scaleTitle = _scaleTitle;
    });
  }

  getScaleHeatmap(Size size) async {
    var _scaleHeatmapData = await ViewerManager.getScaleHeatmap(
        widget.id, widget.type, int.parse(widget.subOrder));
    // print("---------- scaleHeatmap Data ----------");
    // print(_scaleHeatmapData);
    // print(_scaleHeatmapData.length);
    setState(() {
      scaleHeatmapWidgets.clear();
      scaleHeatmapData = _scaleHeatmapData;
    });

    List<int> _grad = new List();
    List<int> _blackHeatmapGrad = new List();
    final recorder = ui.PictureRecorder();
    // create a 256x1 gradient that we'll use to turn a grayscale heatmap into a colored one
    final gradientCanvas =
        Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(1.0, 256.0)));

    final colors = [
      Color(0xFF2B8DD8).withOpacity(0.8),
      Color(0xFF6D72A9).withOpacity(0.5),
      Color(0xFFBA5473).withOpacity(0.8),
      Color(0xFFD8485D).withOpacity(1.0),
      Color(0xFFF93B46).withOpacity(0.0),
    ];

    final colorStops = [0.1, 0.3, 0.4, 0.5, 1.0];
    final gradient = new ui.Gradient.linear(
      Offset(0.0, 0.0),
      Offset(0.0, 256.0),
      colors,
      colorStops,
    );
    var rect = Rect.fromLTWH(0.0, 0.0, 1.0, 256.0);
    final gradientPaint = new Paint()..shader = gradient;
    gradientCanvas.drawRect(rect, gradientPaint);
    final picture = recorder.endRecording();
    final img = await picture.toImage(1, 256);
    final pngBytes = await img.toByteData();

    _grad = Uint8List.view(pngBytes.buffer);

    // Get Black heatmap data
    print("999980979879   88888888888888888888 =====");
    print(size.width);
    print(size.height);

    final blackHeatmapRecorder = ui.PictureRecorder();
    final blackHeatmapCanvas = Canvas(
        blackHeatmapRecorder,
        Rect.fromPoints(
            Offset(0.0, 0.0), Offset(size.width, size.height * 0.8)));

    for (int i = 0; i < scaleHeatmapData.length; i++) {
      double minOpacity;
      if (scaleHeatmapData[i].minOpacity > 50) {
        minOpacity = 1;
      } else {
        minOpacity = scaleHeatmapData[i].minOpacity / 50;
      }
      double radius = 60.0;
      Offset center = Offset(
          num.parse(((scaleHeatmapData[i].x / 100) * dWidth)
                  .toStringAsFixed(3)) +
              50,
          num.parse(((scaleHeatmapData[i].y / 100) * dHeight)
                  .toStringAsFixed(3)) +
              50);
      // draw shadow first
      Path oval = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius + 8));
      Paint shadowPaint = Paint()
        ..color = Colors.black.withOpacity(minOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
      blackHeatmapCanvas.drawPath(oval, shadowPaint);
      // draw circle
      Paint thumbPaint = Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.fill;
      blackHeatmapCanvas.drawCircle(center, radius, thumbPaint);
    }

    final blackHeatmapPicture = blackHeatmapRecorder.endRecording();
    final blackImg = await blackHeatmapPicture.toImage(
        size.width.floor(), (size.height * 0.8).floor());
    final blackPngBytes = await blackImg.toByteData();

    _blackHeatmapGrad = Uint8List.view(blackPngBytes.buffer);

    //colorize the black

    for (int i = 0; i < _blackHeatmapGrad.length; i += 4) {
      int j = _blackHeatmapGrad[i + 3] * 4;

      if (j != 255) {
        _blackHeatmapGrad[i] = _grad[j];
        _blackHeatmapGrad[i + 1] = _grad[j + 1];
        _blackHeatmapGrad[i + 2] = _grad[j + 2];
      }
    }

    setState(() {
      var scaleHeatmap = new ScaleHeatmap(_blackHeatmapGrad, size);

      scaleHeatmapWidgets.add(scaleHeatmap);
    });
  }

  void initState() {
    super.initState();

    scaleTitle = new ScaleTitleModel(
        title: "",
        color: "",
        labelOne: "",
        labelTwo: "",
        description: "",
        tag: "",
        reference: "");

    dWidth = SessionManager.getMediaWidth() - 20;
    dHeight = (SessionManager.getMediaHeight() - 20) * 0.8;
   

    getLastComment();
    getScaleTitle();

    // getCenterPosition();

    showHeatmap();
  }

  getCenterPosition() async {}

  showHeatmap() async {
    if (SessionManager.getUserId() != '') {
      CirclePosition _position = await ViewerManager.getScalePosition(
          widget.id, widget.type, int.parse(widget.subOrder));

      if (_position == null) {
        var tapCircle = new ScaleMoveableCircle(
            widget.id, widget.type, widget.subOrder, this.getScaleHeatmap);
        commentWidgets.add(tapCircle);
      } else {
        var tapCircle = new ScaleCircleRemember(
            widget.id, widget.type, widget.subOrder, this.getScaleHeatmap);
        commentWidgets.add(tapCircle);
      }
    } else {
      var tapCircle = new ScaleMoveableCircle(
          widget.id, widget.type, widget.subOrder, this.getScaleHeatmap);
      commentWidgets.add(tapCircle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: scaleHeatmapWidgets +
              <Widget>[
                GestureDetector(
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Color(
                              0xFF272D3A), //                   <--- border color
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                        child: Container(
                          color: Colors.transparent,
                          height: dHeight + 18,
                          width: dWidth,
                          child: CustomPaint(
                            painter: PathPainter(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Center(
                        child: Text(
                          scaleTitle.labelOne,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Roboto Medium',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          '',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.only(left: 30, bottom: dHeight / 0.8 * 0.125, right: 30),
                      alignment: AlignmentDirectional(0, 400.0),
                      child: Center(
                        child: Text(
                          scaleTitle.labelTwo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Roboto Medium',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) => Comments(
                            //       id: widget.id,
                            //       type: widget.type,
                            //       commentId: commentId,
                            //       callback: getLastComment,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Text(
                            scaleTitle.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Roboto Medium',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: dHeight / 0.8 * 0.044 ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        if (SessionManager.getUserId() != '') {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 1,
                                  child: Container(
                                    color: Colors.black,
                                    height: MediaQuery.of(context).size.height,
                                    child: Container(
                                      child: Comments(
                                        id: widget.id,
                                        type: widget.type,
                                        commentId: commentId,
                                        callback: () {
                                          getLastComment();
                                          showHeatmap();
                                        },
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              });
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
                      child: lastComment.length != 0
                          ? RichText(
                              text: new TextSpan(
                                text: lastComment[0],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Color(0xFF868E9C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " " +
                                          lastComment[1] +
                                          " " +
                                          "..." +
                                          " ",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF868E9C),
                                        fontSize: 14,
                                      )),
                                  TextSpan(
                                      text: "+" + lastComment[2],
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                            )
                          : Text(
                              "Have your say...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF868E9C),
                              ),
                            ),
                    ),
                  ),
                ),
              ] +
              commentWidgets,
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFF272D3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path = Path();
    // TODO: do operations here

    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);

    path.moveTo(0, size.height * 0.5 * 0.3);
    path.lineTo(size.width, size.height * 0.5 * 0.3);

    path.moveTo(0, size.height * 0.5 * 0.5);
    path.lineTo(size.width, size.height * 0.5 * 0.5);

    path.moveTo(0, size.height * 0.5 * 0.7);
    path.lineTo(size.width, size.height * 0.5 * 0.7);

    path.moveTo(0, size.height * 13 / 20 );
    path.lineTo(size.width, size.height * 13 / 20);

    path.moveTo(0, size.height *  15 / 20);
    path.lineTo(size.width, size.height * 15 / 20);

    path.moveTo(0, size.height * 17 / 20);
    path.lineTo(size.width, size.height * 17 / 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
