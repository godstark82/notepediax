import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.blue.shade700;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height*0.2);
    ovalPath.quadraticBezierTo(width*0.45, height*0.25, width*0.5, height*0.5);
    ovalPath.quadraticBezierTo(width*0.45, height*0.25, width*0.1, height);

    // ovalPath.lineTo(width, 0);
    // ovalPath.lineTo(0, 0);
    // ovalPath.close();
    paint.color = Colors.blue.shade300;
    canvas.drawPath(ovalPath, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
