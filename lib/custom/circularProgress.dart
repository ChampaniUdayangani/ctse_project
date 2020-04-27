import 'package:flutter/material.dart';
import 'dart:math';


// Code is referred from https://mightytechno.com/flutter-percent-indicator/ and adopted to match requirement of this project
class CircularProgress extends CustomPainter{

  //to store the progress
  double currentProgress;

  CircularProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {

    //draw base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 6
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    //paint the arc
    Paint completeArc = Paint()
      ..strokeWidth = 6
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    //draw main outer circle
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}