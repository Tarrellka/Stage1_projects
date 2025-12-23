import 'package:flutter/material.dart';

class BallModel {
  double x, y, vx, vy;
  double radius;
  final Color color;

  BallModel({
    required this.x,
    required this.y,
    this.vx = 0,
    this.vy = 0,
    required this.radius,
    required this.color,
  });
}