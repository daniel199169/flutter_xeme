import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/viewer_manager.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/models/quadTitle.dart';
import 'package:xenome/models/circleposition.dart';
import 'package:xenome/screens/custom_widgets/quad_heatmap.dart';
import 'package:xenome/screens/custom_widgets/quad_movable_circle.dart';
import 'package:xenome/screens/custom_widgets/quad_circle_remember.dart';
import 'package:xenome/screens/viewer/comments.dart';
import 'package:xenome/screens/custom_widgets/bottom_sheet.dart';
import 'package:xenome/utils/session_manager.dart';
import 'dart:ui';
import 'dart:ui' as ui;

class ViewQuadStart extends StatefulWidget {
  ViewQuadStart({this.id, this.type, this.subOrder, this.pageId});
  final String id;
  final String type;
  final String subOrder;
  final String pageId;
  @override
  _QuadStartState createState() => _QuadStartState();
}

class _QuadStartState extends State<ViewQuadStart>
    with SingleTickerProviderStateMixin {
  final commentWidgets = List<Widget>();
  final quadHeatmapWidgets = List<Widget>();
  var quadHeatmapData = [];
  bool isSwitched = true;
  double dWidth = 0.0;
  double dHeight = 0.0;

  int border = 5;
  var lastComment = [];
  String commentId = '';
  QuadTitleModel quadTitle;

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

  getQuadTitle() async {
    QuadTitleModel _quadTitle = await BuildderManager.getQuadTitleData(
        widget.id, widget.type, int.parse(widget.subOrder));

    setState(() {
      quadTitle = _quadTitle;
    });
  }

  getQuadHeatmap(Size size) async {
    var _quadHeatmapData = await ViewerManager.getQuadHeatmap(
        widget.id, widget.type, int.parse(widget.subOrder));
    setState(() {
      quadHeatmapWidgets.clear();
      quadHeatmapData = _quadHeatmapData;
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
    final blackHeatmapRecorder = ui.PictureRecorder();
    final blackHeatmapCanvas = Canvas(
      blackHeatmapRecorder,
      Rect.fromPoints(Offset(0.0, 0.0), Offset(size.width, size.height * 0.8)),
    );

    for (int i = 0; i < quadHeatmapData.length; i++) {
      double minOpacity;
      if (quadHeatmapData[i].minOpacity > 50) {
        minOpacity = 1;
      } else {
        minOpacity = quadHeatmapData[i].minOpacity / 50;
      }
      double radius = 60.0;
      Offset center = Offset(
          num.parse(
                  ((quadHeatmapData[i].x / 100) * dWidth).toStringAsFixed(3)) +
              50,
          num.parse(
                  ((quadHeatmapData[i].y / 100) * dHeight).toStringAsFixed(3)) +
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
      var quadHeatmap = new QuadHeatmap(_blackHeatmapGrad, size);
      quadHeatmapWidgets.add(quadHeatmap);
    });
  }

  @override
  void initState() {
    super.initState();

    quadTitle = new QuadTitleModel(
        title: "",
        color: "",
        labelOne: "",
        labelTwo: "",
        labelThree: "",
        labelFour: "",
        description: "",
        tag: "",
        reference: "");

    dWidth = SessionManager.getMediaWidth() - 20;
    dHeight = (SessionManager.getMediaHeight() - 20) * 0.8;

    getLastComment();

    this.getQuadTitle();
    showHeatmap();
  }

  showHeatmap() async {
    if (SessionManager.getUserId() != '') {
      CirclePosition _position = await ViewerManager.getQuadPosition(
          widget.id, widget.type, int.parse(widget.subOrder));
      if (_position == null) {
        var tapCircle = new QuadMoveableCircle(
            widget.id, widget.type, widget.subOrder, this.getQuadHeatmap);
        commentWidgets.add(tapCircle);
      } else {
        var tapCircle = new QuadCircleRemember(
            widget.id, widget.type, widget.subOrder, this.getQuadHeatmap);
        commentWidgets.add(tapCircle);
      }
    } else {
      var tapCircle = new QuadMoveableCircle(
          widget.id, widget.type, widget.subOrder, this.getQuadHeatmap);
      commentWidgets.add(tapCircle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        color: Colors.black,
        child: _buildFrontSide(),
      ),
    );
  }

  Widget _buildFrontSide() {
    return Stack(
      children: quadHeatmapWidgets +
          <Widget>[
            GestureDetector(
              child: Container(
                padding:
                    EdgeInsets.only(top: 0, left: 0, bottom: 0.0, right: 0),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 10, bottom: 0.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: new Column(
                          children: <Widget>[
                            Text(
                              quadTitle.labelOne,
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Container(
                        width: 100,
                        child: new Column(
                          children: <Widget>[
                            Text(
                              quadTitle.labelTwo,
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.white),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  padding: EdgeInsets.only(left: 10, bottom: dHeight / 0.8 * 0.1, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: new Column(
                          children: <Widget>[
                            Text(
                              quadTitle.labelThree,
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Container(
                        width: 100,
                        child: new Column(
                          children: <Widget>[
                            Text(
                              quadTitle.labelFour,
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.white),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      quadTitle.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Roboto Medium',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: dHeight / 0.8 * 0.044),
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
                                  text:
                                      " " + lastComment[1] + " " + "..." + " ",
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
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print("--------- canvas --------");
    print(size.width);
    print(size.height);

    Paint paint = Paint()
      ..color = Color(0xFF272D3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path = Path();
    // TODO: do operations here
    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);
    // path.close();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);

    //path.moveTo(0, 0);
    path.addOval(
        Rect.fromLTWH(10, 60, size.width - 20, size.height - 120));
    path.addOval(
        Rect.fromLTWH(60, 110, size.width - 120, size.height  - 220));
    path.addOval(
        Rect.fromLTWH(110, 160, size.width - 220, size.height - 320));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
