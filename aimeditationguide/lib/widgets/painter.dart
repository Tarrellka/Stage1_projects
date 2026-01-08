import 'package:flutter/material.dart';

// 1. ТОТ САМЫЙ СИЛУЭТ (Большой фон 359x299)
class SilhouettePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  SilhouettePainter({required this.color, this.strokeWidth = 12.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Масштабируем под размер контейнера, если он отличается от 359x299
    double scaleX = size.width / 359;
    double scaleY = size.height / 299;
    Matrix4 matrix = Matrix4.identity()..scale(scaleX, scaleY);

    Path p1 = Path()
      ..moveTo(81.5494, 102.231)
      ..cubicTo(81.5494, 169.222, 179.283, 223.529, 179.283, 223.529)
      ..cubicTo(179.283, 223.529, 277.018, 169.222, 277.018, 102.231)
      ..cubicTo(277.018, 35.2394, 179.283, -19.0676, 179.283, -19.0676)
      ..cubicTo(179.283, -19.0676, 81.5494, 35.2394, 81.5494, 102.231)
      ..close();

    Path p2 = Path()
      ..moveTo(81.0483, 67.5739)
      ..cubicTo(42.6357, 51.046, 6.00024, 50.2456, 6.00024, 50.2456)
      ..cubicTo(6.00024, 50.2456, 7.6589, 126.168, 55.5097, 174.019)
      ..cubicTo(103.361, 221.87, 179.283, 223.529, 179.283, 223.529)
      ..cubicTo(179.283, 223.529, 255.206, 221.87, 303.057, 174.019)
      ..cubicTo(350.908, 126.168, 352.567, 50.2456, 352.567, 50.2456)
      ..cubicTo(352.567, 50.2456, 315.931, 51.046, 277.519, 67.5739);

    Path p3 = Path()
      ..moveTo(179.642, 223.529)
      ..cubicTo(176.76, 246.633, 190.727, 292.842, 240.166, 292.842)
      ..cubicTo(274.751, 292.842, 292.043, 258.185, 352.567, 292.842)
      ..cubicTo(345.635, 258.184, 331.77, 236.004, 311.549, 223.529);

    Path p4 = Path()
      ..moveTo(178.925, 223.529)
      ..cubicTo(181.807, 246.633, 167.84, 292.842, 118.401, 292.842)
      ..cubicTo(83.8162, 292.842, 66.5238, 258.185, 6.00024, 292.842)
      ..cubicTo(12.9324, 258.184, 26.7973, 236.004, 47.0176, 223.529);

    canvas.drawPath(p1.transform(matrix.storage), paint);
    canvas.drawPath(p2.transform(matrix.storage), paint);
    canvas.drawPath(p3.transform(matrix.storage), paint);
    canvas.drawPath(p4.transform(matrix.storage), paint);
  }

  @override
  bool shouldRepaint(covariant SilhouettePainter oldDelegate) => false;
}

// 2. DAILY ROUTINE (Иконка с галочкой)
class RoutineIconPainter extends CustomPainter {
  final Color color;
  RoutineIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = color..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    double s = size.width / 24;
    Matrix4 m = Matrix4.identity()..scale(s, s);

    Path fillPath = Path()
      ..moveTo(6.74994, 13.5)..cubicTo(6.74994, 13.0858, 6.41415, 12.75, 5.99994, 12.75)..cubicTo(5.58573, 12.75, 5.24994, 13.0858, 5.24994, 13.5)..moveTo(10.6571, 12.7742)..lineTo(9.96456, 13.062)..moveTo(10.4909, 15.0122)..lineTo(11.0878, 15.4663)..moveTo(19.1716, 17.2426)..lineTo(19.7019, 17.773)..moveTo(20.5858, 15.8284)..lineTo(20.0555, 15.2981)..moveTo(21.9999, 14.0116)..lineTo(22.7499, 14.0202)..moveTo(21.6989, 13.2848)..lineTo(21.1747, 13.8212)..moveTo(17.3196, 18.7716)..lineTo(17.6066, 19.4645)..moveTo(17.9999, 12.25)..cubicTo(17.5857, 12.25, 17.2499, 12.5858, 17.2499, 13)..cubicTo(17.2499, 13.4142, 17.5857, 13.75, 17.9999, 13.75)..moveTo(8.49994, 16)..lineTo(8.49994, 15.25)..cubicTo(7.53344, 15.25, 6.74994, 14.4665, 6.74994, 13.5)..lineTo(5.24994, 13.5)..cubicTo(5.24994, 15.2949, 6.70501, 16.75, 8.49994, 16.75)..moveTo(6.49994, 19)..lineTo(6.49994, 18.25)..cubicTo(4.42887, 18.25, 2.74994, 16.5711, 2.74994, 14.5)..lineTo(1.24994, 14.5)..cubicTo(1.24994, 17.3995, 3.60044, 19.75, 6.49994, 19.75)..moveTo(1.99994, 14.5)..lineTo(2.74994, 14.5)..cubicTo(2.74994, 12.4289, 4.42887, 10.75, 6.49994, 10.75)..lineTo(6.49994, 9.25)..cubicTo(3.60044, 9.25, 1.24994, 11.6005, 1.24994, 14.5)..moveTo(6.49994, 19)..lineTo(6.49994, 19.75)..lineTo(14.9289, 19.75)..lineTo(14.9289, 18.25)..lineTo(6.49994, 18.25)..moveTo(6.49994, 10)..lineTo(6.49994, 10.75)..cubicTo(8.06032, 10.75, 9.39983, 11.7032, 9.96456, 13.062)..lineTo(11.3497, 12.4864)..cubicTo(10.5605, 10.5875, 8.6873, 9.25, 6.49994, 9.25)..moveTo(10.4909, 15.0122)..lineTo(9.89398, 14.5581)..cubicTo(9.57307, 14.98, 9.06818, 15.25, 8.49994, 15.25)..lineTo(8.49994, 16.75)..cubicTo(9.55654, 16.75, 10.4955, 16.245, 11.0878, 15.4663)..moveTo(10.6571, 12.7742)..cubicTo(10.2031, 13.6359, 10.1615, 14.2065, 9.89398, 14.5581)..lineTo(11.0878, 15.4663)..cubicTo(11.7802, 14.5561, 11.7197, 13.3765, 11.3497, 12.4864)..moveTo(19.1716, 17.2426)..lineTo(19.7019, 17.773)..lineTo(21.1161, 16.3588)..lineTo(20.0555, 15.2981)..lineTo(18.6412, 16.7123)..moveTo(20.5858, 15.8284)..lineTo(21.1161, 16.3588)..cubicTo(21.5744, 15.9005, 21.9582, 15.5179, 22.2223, 15.1973)..cubicTo(22.4696, 14.8972, 22.7443, 14.5021, 22.7499, 14.0202)..lineTo(21.25, 14.0029)..cubicTo(21.2509, 13.9284, 21.2883, 13.972, 21.0646, 14.2435)..cubicTo(20.8577, 14.4946, 20.5368, 14.8168, 20.0555, 15.2981)..moveTo(19.4142, 13)..lineTo(19.4142, 13.75)..cubicTo(20.0949, 13.75, 20.5496, 13.7508, 20.8735, 13.7821)..cubicTo(21.2237, 13.8159, 21.228, 13.8733, 21.1747, 13.8212)..lineTo(22.2231, 12.7483)..cubicTo(21.8783, 12.4115, 21.4048, 12.3264, 21.0177, 12.2891)..cubicTo(20.6043, 12.2492, 20.0624, 12.25, 19.4142, 12.25)..moveTo(14.9289, 19)..lineTo(14.9289, 18.25)..cubicTo(16.2164, 18.25, 16.6512, 18.2367, 17.0326, 18.0787)..lineTo(17.6066, 19.4645)..cubicTo(16.8854, 19.7633, 16.094, 19.75, 14.9289, 19.75);

    Path strokePath = Path()
      ..moveTo(10.4999, 15)..lineTo(17.121, 10.4933)..cubicTo(17.3079, 10.3543, 17.4747, 10.1902, 17.6163, 10.0061)..cubicTo(18.1007, 9.37595, 18.0911, 8.50194, 17.784, 7.77083)..cubicTo(17.1008, 6.14397, 15.4795, 5, 13.5882, 5)..cubicTo(12.6545, 5, 11.7867, 5.2788, 11.065, 5.75685)..lineTo(3.99994, 10.7508);

    canvas.drawPath(fillPath.transform(m.storage), fillPaint);
    canvas.drawPath(strokePath.transform(m.storage), strokePaint);
  }

  @override
  bool shouldRepaint(covariant RoutineIconPainter old) => old.color != color;
}

// 3. BREATHING EXERCISE (Иконка с кружком сверху)
class BreathingIconPainter extends CustomPainter {
  final Color color;
  BreathingIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    double s = size.width / 24;
    Matrix4 m = Matrix4.identity()..scale(s, s);

    Path p1 = Path()..moveTo(7.88598, 10)..cubicTo(8.57173, 11.3968, 9.30442, 12.7049, 9.1352, 14.3142)..cubicTo(8.86468, 16.8869, 5.74512, 17.8552, 3.75022, 19.0404)..cubicTo(2.44325, 19.8169, 2.9319, 22, 4.53582, 22)..cubicTo(6.48047, 22, 8.21607, 21.8448, 9.9706, 21.0201)..lineTo(13.4111, 18.9028)..cubicTo(13.8887, 18.6783, 14.4913, 18.774, 15, 19);
    Path p2 = Path()..moveTo(16.0105, 10)..cubicTo(15.3102, 11.3968, 14.562, 12.7049, 14.7348, 14.3142)..cubicTo(15.0111, 16.8869, 18.1967, 17.8552, 20.2339, 19.0404)..cubicTo(21.5685, 19.8169, 21.0695, 22, 19.4316, 22)..cubicTo(17.4458, 22, 15.6734, 21.8448, 13.8817, 21.0201)..lineTo(10.3683, 18.9028)..cubicTo(9.95819, 18.714, 9.45777, 18.7517, 9, 18.9028);
    Path p3 = Path()..addOval(Rect.fromCircle(center: const Offset(12, 4), radius: 2));
    Path p4 = Path()..moveTo(3, 16)..cubicTo(5.44586, 16, 6.54368, 13.2949, 6.89335, 11.4291)..cubicTo(6.98463, 10.9421, 7.13246, 10.4565, 7.45625, 10.0814)..cubicTo(8.55651, 8.80674, 10.184, 8, 12, 8)..cubicTo(13.816, 8, 15.4435, 8.80674, 16.5437, 10.0814)..cubicTo(16.8675, 10.4565, 17.0154, 10.9421, 17.1067, 11.4291)..cubicTo(17.4563, 13.2949, 18.5541, 16, 21, 16);

    canvas.drawPath(p1.transform(m.storage), paint);
    canvas.drawPath(p2.transform(m.storage), paint);
    canvas.drawPath(p3.transform(m.storage), paint);
    canvas.drawPath(p4.transform(m.storage), paint);
  }

  @override
  bool shouldRepaint(covariant BreathingIconPainter old) => old.color != color;
}

// 4. GENERATE MEDITATION (Иконка лотоса)
class LotusIconPainter extends CustomPainter {
  final Color color;
  LotusIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    double s = size.width / 24;
    Matrix4 m = Matrix4.identity()..scale(s, s);

    Path p1 = Path()..moveTo(6.35986, 10)..cubicTo(6.35986, 13.866, 12, 17, 12, 17)..cubicTo(12, 17, 17.6401, 13.866, 17.6401, 10)..cubicTo(17.6401, 6.13401, 12, 3, 12, 3)..cubicTo(12, 3, 6.35986, 6.13401, 6.35986, 10)..close();
    Path p2 = Path()..moveTo(6.33095, 8)..cubicTo(4.11419, 7.04619, 2, 7, 2, 7)..cubicTo(2, 7, 2.09572, 11.3814, 4.85714, 14.1429)..cubicTo(7.61857, 16.9043, 12, 17, 12, 17)..cubicTo(12, 17, 16.3814, 16.9043, 19.1429, 14.1429)..cubicTo(21.9043, 11.3814, 22, 7, 22, 7)..cubicTo(22, 7, 19.8858, 7.04619, 17.6691, 8);
    Path p3 = Path()..moveTo(12.0207, 17)..cubicTo(11.8544, 18.3333, 12.6604, 21, 15.5135, 21)..cubicTo(17.5093, 21, 18.5072, 19, 22, 21)..cubicTo(21.6, 18.9999, 20.7998, 17.7199, 19.6329, 17);
    Path p4 = Path()..moveTo(11.9793, 17)..cubicTo(12.1456, 18.3333, 11.3396, 21, 8.48654, 21)..cubicTo(6.49068, 21, 5.49275, 19, 2, 21)..cubicTo(2.40005, 18.9999, 3.20018, 17.7199, 4.36707, 17);
    Path eyeL = Path()..moveTo(10.6282, 8.90161)..lineTo(10.6282, 10.6175);
    Path eyeR = Path()..moveTo(13.9187, 8.90161)..lineTo(13.9187, 10.6175);

    canvas.drawPath(p1.transform(m.storage), paint);
    canvas.drawPath(p2.transform(m.storage), paint);
    canvas.drawPath(p3.transform(m.storage), paint);
    canvas.drawPath(p4.transform(m.storage), paint);
    canvas.drawPath(eyeL.transform(m.storage), paint);
    canvas.drawPath(eyeR.transform(m.storage), paint);
  }

  @override
  bool shouldRepaint(covariant LotusIconPainter old) => old.color != color;
}

class BreathingSilhouettePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  BreathingSilhouettePainter({required this.color, this.strokeWidth = 12.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Масштабируем пути под размер контейнера
    double sx = size.width / 327;
    double sy = size.height / 331;

    // Первый путь (левая рука/нога)
    var path1 = Path();
    path1.moveTo(91.5 * sx, 114.9 * sy);
    path1.quadraticBezierTo(103.5 * sx, 139.3 * sy, 116.3 * sx, 162.2 * sy);
    path1.quadraticBezierTo(113.3 * sx, 190.4 * sy, 108.6 * sx, 235.4 * sy);
    path1.cubicTo(54.0 * sx, 252.3 * sy, 19.1 * sx, 273.1 * sy, 19.1 * sx, 273.1 * sy);
    path1.quadraticBezierTo(-3.7 * sx, 286.6 * sy, 32.8 * sx, 324.9 * sy);
    path1.lineTo(127.9 * sx, 307.7 * sy);
    path1.lineTo(188.1 * sx, 270.7 * sy);
    canvas.drawPath(path1, paint);

    // Второй путь (правая рука/нога)
    var path2 = Path();
    path2.moveTo(233.6 * sx, 114.9 * sy);
    path2.quadraticBezierTo(221.4 * sx, 139.3 * sy, 208.3 * sx, 162.2 * sy);
    path2.quadraticBezierTo(211.3 * sx, 190.4 * sy, 216.1 * sx, 235.4 * sy);
    path2.cubicTo(271.9 * sx, 252.3 * sy, 307.5 * sx, 273.1 * sy, 307.5 * sx, 273.1 * sy);
    path2.quadraticBezierTo(330.9 * sx, 286.6 * sy, 293.5 * sx, 324.9 * sy);
    path2.lineTo(196.4 * sx, 307.7 * sy);
    path2.lineTo(134.9 * sx, 270.7 * sy);
    canvas.drawPath(path2, paint);

    // Голова (круг)
    canvas.drawCircle(Offset(163.5 * sx, 9.9 * sy), 35 * sx, paint);

    // Туловище/Плечи
    var path4 = Path();
    path4.moveTo(6 * sx, 219.9 * sy);
    path4.cubicTo(48.8 * sx, 219.9 * sy, 68.0 * sx, 172.5 * sy, 74.1 * sx, 139.9 * sy);
    path4.cubicTo(83.9 * sx, 116.3 * sy, 131.7 * sx, 79.9 * sy, 163.5 * sx, 79.9 * sy);
    path4.cubicTo(195.2 * sx, 79.9 * sy, 243.0 * sx, 116.3 * sy, 252.8 * sx, 139.9 * sy);
    path4.cubicTo(258.9 * sx, 172.5 * sy, 278.1 * sx, 219.9 * sy, 321 * sx, 219.9 * sy);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}