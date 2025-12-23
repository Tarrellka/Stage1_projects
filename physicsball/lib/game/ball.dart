import 'dart:math';
import 'package:flutter/material.dart';
import '../game/models/ball_model.dart';

class BallLogic {
  // Логика движения и границ
  static void update(BallModel ball, double dt, Size size, double gravity, double bounce) {
    ball.vy += gravity * dt;
    ball.x += ball.vx * dt;
    ball.y += ball.vy * dt;

    // Стены
    if (ball.x + ball.radius > size.width) {
      ball.x = size.width - ball.radius;
      ball.vx = -ball.vx * bounce;
    } else if (ball.x - ball.radius < 0) {
      ball.x = ball.radius;
      ball.vx = -ball.vx * bounce;
    }

    // Пол и потолок
    if (ball.y + ball.radius > size.height) {
      ball.y = size.height - ball.radius;
      ball.vy = -ball.vy * bounce;
    } else if (ball.y - ball.radius < 0) {
      ball.y = ball.radius;
      ball.vy = -ball.vy * bounce;
    }
  }

  // Логика столкновения между двумя шарами
  static void handleCollision(BallModel b1, BallModel b2, double bounce) {
    double dx = b2.x - b1.x;
    double dy = b2.y - b1.y;
    double distance = sqrt(dx * dx + dy * dy);
    double minDistance = b1.radius + b2.radius;

    if (distance < minDistance && distance > 0) {
      // 1. Раздвигаем (Overlap correction)
      double overlap = minDistance - distance;
      double nx = dx / distance;
      double ny = dy / distance;
      b1.x -= nx * overlap / 2;
      b1.y -= ny * overlap / 2;
      b2.x += nx * overlap / 2;
      b2.y += ny * overlap / 2;

      // 2. Отскок (Impulse)
      double rvx = b2.vx - b1.vx;
      double rvy = b2.vy - b1.vy;
      double velAlongNormal = rvx * nx + rvy * ny;
      if (velAlongNormal > 0) return;

      double j = -(1 + bounce) * velAlongNormal;
      j /= 2;

      b1.vx -= j * nx;
      b1.vy -= j * ny;
      b2.vx += j * nx;
      b2.vy += j * ny;
    }
  }
}

class BallWidget extends StatelessWidget {
  final BallModel model;
  const BallWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: model.x - model.radius,
      top: model.y - model.radius,
      child: Container(
        width: model.radius * 2,
        height: model.radius * 2,
        decoration: BoxDecoration(
          color: model.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: model.color.withOpacity(0.4), blurRadius: 10),
          ],
        ),
      ),
    );
  }
}