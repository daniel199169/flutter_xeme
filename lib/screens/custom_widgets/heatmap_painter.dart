import 'dart:math';

import 'package:flutter/material.dart';
class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // create a bounding square, based on the centre and radius of the arc
    Rect rect = new Rect.fromCircle(
      center: new Offset(165.0, 55.0),
      radius: 180.0,
    );

    // a fancy rainbow gradient
    final Gradient gradient = new RadialGradient(
      colors: <Color>[
        Colors.green.withOpacity(1.0),
        Colors.green.withOpacity(0.3),
        Colors.yellow.withOpacity(0.2),
        Colors.red.withOpacity(0.1),
        Colors.red.withOpacity(0.0),
      ],
      stops: [
        0.0,
        0.5,
        0.7,
        0.9,
        1.0,
      ],
    );

    // create the Shader from the gradient and the bounding square
    final Paint paint = new Paint()..shader = gradient.createShader(rect);

    // and draw an arc
    canvas.drawArc(rect, pi / 4, pi , true, paint);
  }

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) {
    return true;
  }
}

class X1Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Arcs etc')),
      body: new CustomPaint(
        painter: new HeatmapPainter(),
      ),
    );
  }
}