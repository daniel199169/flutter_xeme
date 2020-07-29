import 'dart:ui';
import 'package:flutter/material.dart';

class QuadHeatmap extends StatefulWidget {
  List<int> _colorHeatmapGrad;
  Size size;
  QuadHeatmap(this._colorHeatmapGrad, this.size);
  @override
  State<StatefulWidget> createState() {
    return _QuadHeatmapState();
  }
}

class _QuadHeatmapState extends State<QuadHeatmap> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: HeatmapPainter(widget._colorHeatmapGrad, widget.size),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeatmapPainter extends CustomPainter {
  List<int> _colorHeatmapGrad;
  Size colorSize;
  HeatmapPainter(this._colorHeatmapGrad, this.colorSize);
  @override
  int i = 0;
  void paint(Canvas canvas, Size size) async {
//     var rect2 = Rect.fromLTWH(100.0, 100.0, 80.0, 80.0);

//   var gradient2 = RadialGradient(
//     center: const Alignment(0, 0), // near the top right
//     radius: 0.5,
//     colors: [
//       Colors.red, // yellow sun
//       Colors.transparent, // blue sky
//     ],
//     stops: [0.5, 1.0],
//   );
//   // rect is the area we are painting over
//   var paint2 = Paint()
//     ..shader = gradient2.createShader(rect2)
//     ..maskFilter = MaskFilter.blur(
//           BlurStyle.normal, 50
//       );
//   canvas.drawRect(rect2, paint2);
//   for(var u=0;u<50;u++){
// canvas.drawRect(rect2, paint2);
//   }

    for (int y = 0; y < colorSize.height.floor(); y++) {
      if(i * 4 + 3 > _colorHeatmapGrad.length) break;
      for (int x = 0; x < colorSize.width.floor(); x++) {
        double minOpacity;
        if (_colorHeatmapGrad[i * 4 + 3] > 50) {
          minOpacity = 1;
        } else {
          minOpacity = _colorHeatmapGrad[i * 4 + 3] / 50;
        }
        final paint = Paint()
          ..color = Color.fromRGBO(
              _colorHeatmapGrad[i * 4],
              _colorHeatmapGrad[i * 4 + 1],
              _colorHeatmapGrad[i * 4 + 2],
              minOpacity)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.5;
        //..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);
        var offsetList = [new Offset(x.toDouble(), y.toDouble())];
        canvas.drawPoints(PointMode.points, offsetList, paint);
        i++;
      }
    }
  }

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) {
    return true;
  }
}
