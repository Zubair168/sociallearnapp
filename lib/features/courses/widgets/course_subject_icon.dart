import 'dart:math' as math;
import 'package:flutter/material.dart';

enum SubjectType {
  turkish,
  mathematics,
  geometry,
  history,
  geography,
  philosophy,
  religion,
  physics,
  chemistry,
  biology,
  literature,
  foreignLanguage,
}

class CourseSubjectIcon extends StatelessWidget {
  final SubjectType type;
  final double size;

  const CourseSubjectIcon({
    super.key,
    required this.type,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SubjectIconPainter(type),
    );
  }
}

class _SubjectIconPainter extends CustomPainter {
  final SubjectType type;

  _SubjectIconPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case SubjectType.turkish:
        _drawTurkish(canvas, size);
        break;
      case SubjectType.mathematics:
        _drawMathematics(canvas, size);
        break;
      case SubjectType.geometry:
        _drawGeometry(canvas, size);
        break;
      case SubjectType.history:
        _drawHistory(canvas, size);
        break;
      case SubjectType.geography:
        _drawGeography(canvas, size);
        break;
      case SubjectType.philosophy:
        _drawPhilosophy(canvas, size);
        break;
      case SubjectType.religion:
        _drawReligion(canvas, size);
        break;
      case SubjectType.physics:
        _drawPhysics(canvas, size);
        break;
      case SubjectType.chemistry:
        _drawChemistry(canvas, size);
        break;
      case SubjectType.biology:
        _drawBiology(canvas, size);
        break;
      case SubjectType.literature:
        _drawLiterature(canvas, size);
        break;
      case SubjectType.foreignLanguage:
        _drawForeignLanguage(canvas, size);
        break;
    }
  }

  // 1. Turkish Flag
  void _drawTurkish(Canvas canvas, Size size) {
    const color = Color(0xFFE11D48);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Flagpole
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.12),
      Offset(size.width * 0.18, size.height * 0.88),
      stroke,
    );
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.12), 2.2, fill);

    // Waving flag outline
    final flag = Path();
    flag.moveTo(size.width * 0.18, size.height * 0.18);
    flag.quadraticBezierTo(
      size.width * 0.52, size.height * 0.10,
      size.width * 0.86, size.height * 0.22,
    );
    flag.lineTo(size.width * 0.86, size.height * 0.68);
    flag.quadraticBezierTo(
      size.width * 0.52, size.height * 0.56,
      size.width * 0.18, size.height * 0.64,
    );
    flag.close();
    canvas.drawPath(flag, stroke);

    // Crescent Moon
    final moon = Path();
    final cX = size.width * 0.44;
    final cY = size.height * 0.41;
    final r = size.width * 0.13;
    moon.addArc(Rect.fromCircle(center: Offset(cX, cY), radius: r), 0.5, 5.3);
    moon.arcTo(
      Rect.fromCircle(center: Offset(cX + r * 0.45, cY), radius: r * 0.78),
      5.6,
      -4.9,
      false,
    );
    moon.close();
    canvas.drawPath(moon, stroke);

    // Star
    _drawStar(canvas, Offset(size.width * 0.62, size.height * 0.41), 4.0, fill);
  }

  // 2. Mathematics (Calculator / Math symbols)
  void _drawMathematics(Canvas canvas, Size size) {
    const color = Color(0xFF0284C7);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.15, size.width * 0.70, size.height * 0.70),
      const Radius.circular(8),
    );
    canvas.drawRRect(r, stroke);

    // Grid divider lines
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.50),
      Offset(size.width * 0.85, size.height * 0.50),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.15),
      Offset(size.width * 0.50, size.height * 0.85),
      stroke,
    );

    // Top-left: Plus (+)
    canvas.drawLine(Offset(size.width * 0.325, size.height * 0.25), Offset(size.width * 0.325, size.height * 0.40), stroke);
    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.325), Offset(size.width * 0.40, size.height * 0.325), stroke);

    // Top-right: Minus (-)
    canvas.drawLine(Offset(size.width * 0.60, size.height * 0.325), Offset(size.width * 0.75, size.height * 0.325), stroke);

    // Bottom-left: Multiply (×)
    canvas.drawLine(Offset(size.width * 0.26, size.height * 0.61), Offset(size.width * 0.39, size.height * 0.74), stroke);
    canvas.drawLine(Offset(size.width * 0.39, size.height * 0.61), Offset(size.width * 0.26, size.height * 0.74), stroke);

    // Bottom-right: Divide (÷)
    canvas.drawLine(Offset(size.width * 0.60, size.height * 0.675), Offset(size.width * 0.75, size.height * 0.675), stroke);
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.675, size.height * 0.59), 1.5, fill);
    canvas.drawCircle(Offset(size.width * 0.675, size.height * 0.76), 1.5, fill);
  }

  // 3. Geometry (Triangle ruler with pencil)
  void _drawGeometry(Canvas canvas, Size size) {
    const color = Color(0xFFDB2777);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Set square outer triangle
    final tOuter = Path()
      ..moveTo(size.width * 0.15, size.height * 0.85)
      ..lineTo(size.width * 0.85, size.height * 0.85)
      ..lineTo(size.width * 0.15, size.height * 0.15)
      ..close();
    canvas.drawPath(tOuter, stroke);

    // Set square inner triangle
    final tInner = Path()
      ..moveTo(size.width * 0.26, size.height * 0.76)
      ..lineTo(size.width * 0.64, size.height * 0.76)
      ..lineTo(size.width * 0.26, size.height * 0.38)
      ..close();
    canvas.drawPath(tInner, stroke);

    // Ruler tick marks on hypotenuse
    canvas.drawLine(Offset(size.width * 0.35, size.height * 0.35), Offset(size.width * 0.40, size.height * 0.31), stroke);
    canvas.drawLine(Offset(size.width * 0.47, size.height * 0.47), Offset(size.width * 0.52, size.height * 0.43), stroke);
    canvas.drawLine(Offset(size.width * 0.59, size.height * 0.59), Offset(size.width * 0.64, size.height * 0.55), stroke);

    // Diagonal pencil
    final p = Path();
    p.moveTo(size.width * 0.35, size.height * 0.85);
    p.lineTo(size.width * 0.82, size.height * 0.38);
    p.lineTo(size.width * 0.88, size.height * 0.44);
    p.lineTo(size.width * 0.41, size.height * 0.91);
    p.close();
    canvas.drawPath(p, stroke);
  }

  // 4. History (Parchment scroll & quill)
  void _drawHistory(Canvas canvas, Size size) {
    const color = Color(0xFFD97706);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Scroll
    final scroll = Path();
    scroll.moveTo(size.width * 0.15, size.height * 0.35);
    scroll.quadraticBezierTo(size.width * 0.12, size.height * 0.25, size.width * 0.22, size.height * 0.25);
    scroll.lineTo(size.width * 0.68, size.height * 0.25);
    scroll.quadraticBezierTo(size.width * 0.78, size.height * 0.25, size.width * 0.75, size.height * 0.35);
    scroll.lineTo(size.width * 0.75, size.height * 0.75);
    scroll.quadraticBezierTo(size.width * 0.78, size.height * 0.85, size.width * 0.68, size.height * 0.85);
    scroll.lineTo(size.width * 0.22, size.height * 0.85);
    scroll.quadraticBezierTo(size.width * 0.12, size.height * 0.85, size.width * 0.15, size.height * 0.75);
    scroll.close();
    canvas.drawPath(scroll, stroke);

    // Scroll rolls at top & bottom
    canvas.drawOval(Rect.fromLTWH(size.width * 0.12, size.height * 0.24, size.width * 0.10, size.height * 0.12), stroke);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.68, size.height * 0.74, size.width * 0.10, size.height * 0.12), stroke);

    // Text lines on scroll
    canvas.drawLine(Offset(size.width * 0.28, size.height * 0.42), Offset(size.width * 0.62, size.height * 0.42), stroke);
    canvas.drawLine(Offset(size.width * 0.28, size.height * 0.52), Offset(size.width * 0.62, size.height * 0.52), stroke);
    canvas.drawLine(Offset(size.width * 0.28, size.height * 0.62), Offset(size.width * 0.48, size.height * 0.62), stroke);

    // Feather Quill Pen on right
    final quill = Path();
    quill.moveTo(size.width * 0.88, size.height * 0.12);
    quill.quadraticBezierTo(size.width * 0.92, size.height * 0.35, size.width * 0.76, size.height * 0.62);
    quill.lineTo(size.width * 0.72, size.height * 0.56);
    quill.quadraticBezierTo(size.width * 0.82, size.height * 0.32, size.width * 0.88, size.height * 0.12);
    canvas.drawPath(quill, stroke);
    canvas.drawLine(Offset(size.width * 0.72, size.height * 0.56), Offset(size.width * 0.66, size.height * 0.68), stroke);
  }

  // 5. Geography (Globe)
  void _drawGeography(Canvas canvas, Size size) {
    const color = Color(0xFF0284C7);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final c = Offset(size.width * 0.50, size.height * 0.42);
    final r = size.width * 0.28;

    // Outer globe sphere
    canvas.drawCircle(c, r, stroke);

    // Equator / Latitude lines
    final lat1 = Path()..addArc(Rect.fromLTWH(c.dx - r, c.dy - r * 0.45, r * 2, r * 0.9), 0, math.pi * 2);
    canvas.drawPath(lat1, stroke);

    // Longitude line
    final long1 = Path()..addArc(Rect.fromLTWH(c.dx - r * 0.45, c.dy - r, r * 0.9, r * 2), 0, math.pi * 2);
    canvas.drawPath(long1, stroke);

    // Stand / Arm
    final arm = Path();
    arm.addArc(Rect.fromCircle(center: c, radius: r + 4), -2.6, 3.8);
    canvas.drawPath(arm, stroke);

    // Axis pin
    canvas.drawLine(Offset(c.dx, c.dy + r + 4), Offset(c.dx, size.height * 0.84), stroke);
    // Base
    canvas.drawLine(Offset(size.width * 0.32, size.height * 0.84), Offset(size.width * 0.68, size.height * 0.84), stroke);
  }

  // 6. Philosophy (Thinker / Greek Bust)
  void _drawPhilosophy(Canvas canvas, Size size) {
    const color = Color(0xFFB45309);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final head = Path();
    // Head / Hair curls
    head.moveTo(size.width * 0.35, size.height * 0.78);
    head.lineTo(size.width * 0.35, size.height * 0.62);
    head.quadraticBezierTo(size.width * 0.30, size.height * 0.50, size.width * 0.32, size.height * 0.38);
    head.quadraticBezierTo(size.width * 0.35, size.height * 0.18, size.width * 0.55, size.height * 0.18);
    head.quadraticBezierTo(size.width * 0.72, size.height * 0.18, size.width * 0.74, size.height * 0.32);
    // Forehead & Nose
    head.lineTo(size.width * 0.68, size.height * 0.42);
    head.lineTo(size.width * 0.75, size.height * 0.50);
    head.lineTo(size.width * 0.66, size.height * 0.54);
    // Lips & Beard
    head.quadraticBezierTo(size.width * 0.74, size.height * 0.62, size.width * 0.68, size.height * 0.72);
    head.quadraticBezierTo(size.width * 0.60, size.height * 0.82, size.width * 0.48, size.height * 0.78);
    head.lineTo(size.width * 0.48, size.height * 0.86);
    head.lineTo(size.width * 0.35, size.height * 0.86);
    head.close();
    canvas.drawPath(head, stroke);

    // Eye & Ear details
    canvas.drawCircle(Offset(size.width * 0.58, size.height * 0.42), 1.5, Paint()..color = color..style = PaintingStyle.fill);
    final ear = Path()..addArc(Rect.fromLTWH(size.width * 0.42, size.height * 0.42, size.width * 0.10, size.height * 0.14), -1.5, 3.14);
    canvas.drawPath(ear, stroke);
  }

  // 7. Religion (Crescent Moon & Star in Circle)
  void _drawReligion(Canvas canvas, Size size) {
    const color = Color(0xFF16A34A);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()..color = color..style = PaintingStyle.fill;

    // Outer Circle
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.50), size.width * 0.38, stroke);

    // Crescent Moon
    final moon = Path();
    final cX = size.width * 0.46;
    final cY = size.height * 0.50;
    final r = size.width * 0.22;
    moon.addArc(Rect.fromCircle(center: Offset(cX, cY), radius: r), 0.5, 5.3);
    moon.arcTo(
      Rect.fromCircle(center: Offset(cX + r * 0.48, cY), radius: r * 0.80),
      5.6,
      -4.9,
      false,
    );
    moon.close();
    canvas.drawPath(moon, stroke);

    // Star inside
    _drawStar(canvas, Offset(size.width * 0.62, size.height * 0.42), 4.2, fill);
  }

  // 8. Physics (Newton's Cradle)
  void _drawPhysics(Canvas canvas, Size size) {
    const color = Color(0xFF9333EA);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Top horizontal bar & legs
    final frame = Path();
    frame.moveTo(size.width * 0.15, size.height * 0.40);
    frame.lineTo(size.width * 0.25, size.height * 0.22);
    frame.lineTo(size.width * 0.75, size.height * 0.22);
    frame.lineTo(size.width * 0.85, size.height * 0.40);
    canvas.drawPath(frame, stroke);
    canvas.drawLine(Offset(size.width * 0.20, size.height * 0.22), Offset(size.width * 0.80, size.height * 0.22), stroke..strokeWidth = 2.2);

    // 4 strings & balls
    final xCoords = [
      size.width * 0.32,
      size.width * 0.44,
      size.width * 0.56,
      size.width * 0.68,
    ];

    for (int i = 0; i < 4; i++) {
      final x = xCoords[i];
      final yEnd = (i == 3) ? size.height * 0.60 : size.height * 0.68;
      final xEnd = (i == 3) ? size.width * 0.78 : x;

      canvas.drawLine(Offset(x, size.height * 0.22), Offset(xEnd, yEnd), stroke..strokeWidth = 1.4);
      canvas.drawCircle(Offset(xEnd, yEnd + 4), 4.5, stroke..strokeWidth = 1.6);
    }
  }

  // 9. Chemistry (Erlenmeyer Flask)
  void _drawChemistry(Canvas canvas, Size size) {
    const color = Color(0xFFD97706);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final flask = Path();
    // Neck rim
    flask.moveTo(size.width * 0.42, size.height * 0.18);
    flask.lineTo(size.width * 0.58, size.height * 0.18);
    // Neck down
    flask.lineTo(size.width * 0.58, size.height * 0.38);
    // Body slope
    flask.lineTo(size.width * 0.82, size.height * 0.78);
    flask.quadraticBezierTo(size.width * 0.84, size.height * 0.84, size.width * 0.76, size.height * 0.84);
    flask.lineTo(size.width * 0.24, size.height * 0.84);
    flask.quadraticBezierTo(size.width * 0.16, size.height * 0.84, size.width * 0.18, size.height * 0.78);
    flask.lineTo(size.width * 0.42, size.height * 0.38);
    flask.close();
    canvas.drawPath(flask, stroke);

    // Liquid line inside
    final liquid = Path();
    liquid.moveTo(size.width * 0.27, size.height * 0.64);
    liquid.quadraticBezierTo(size.width * 0.50, size.height * 0.60, size.width * 0.73, size.height * 0.64);
    canvas.drawPath(liquid, stroke);

    // Measurement tick marks
    canvas.drawLine(Offset(size.width * 0.40, size.height * 0.52), Offset(size.width * 0.46, size.height * 0.52), stroke);
    canvas.drawLine(Offset(size.width * 0.35, size.height * 0.60), Offset(size.width * 0.43, size.height * 0.60), stroke);
    canvas.drawLine(Offset(size.width * 0.30, size.height * 0.68), Offset(size.width * 0.40, size.height * 0.68), stroke);

    // Bubbles
    canvas.drawCircle(Offset(size.width * 0.54, size.height * 0.72), 2.0, stroke);
    canvas.drawCircle(Offset(size.width * 0.62, size.height * 0.56), 1.4, stroke);
  }

  // 10. Biology (DNA Helix)
  void _drawBiology(Canvas canvas, Size size) {
    const color = Color(0xFF2563EB);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path1 = Path();
    path1.moveTo(size.width * 0.22, size.height * 0.20);
    path1.cubicTo(
      size.width * 0.78, size.height * 0.35,
      size.width * 0.22, size.height * 0.65,
      size.width * 0.78, size.height * 0.80,
    );
    canvas.drawPath(path1, stroke);

    final path2 = Path();
    path2.moveTo(size.width * 0.78, size.height * 0.20);
    path2.cubicTo(
      size.width * 0.22, size.height * 0.35,
      size.width * 0.78, size.height * 0.65,
      size.width * 0.22, size.height * 0.80,
    );
    canvas.drawPath(path2, stroke);

    // Base pairs rungs
    canvas.drawLine(Offset(size.width * 0.30, size.height * 0.24), Offset(size.width * 0.70, size.height * 0.24), stroke);
    canvas.drawLine(Offset(size.width * 0.44, size.height * 0.36), Offset(size.width * 0.56, size.height * 0.36), stroke);
    canvas.drawLine(Offset(size.width * 0.48, size.height * 0.50), Offset(size.width * 0.52, size.height * 0.50), stroke);
    canvas.drawLine(Offset(size.width * 0.44, size.height * 0.64), Offset(size.width * 0.56, size.height * 0.64), stroke);
    canvas.drawLine(Offset(size.width * 0.30, size.height * 0.76), Offset(size.width * 0.70, size.height * 0.76), stroke);
  }

  // 11. Literature (Feather quill in inkpot)
  void _drawLiterature(Canvas canvas, Size size) {
    const color = Color(0xFF7C3AED);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Inkpot bottle
    final pot = Path();
    pot.moveTo(size.width * 0.38, size.height * 0.68);
    pot.lineTo(size.width * 0.62, size.height * 0.68);
    pot.lineTo(size.width * 0.66, size.height * 0.85);
    pot.lineTo(size.width * 0.34, size.height * 0.85);
    pot.close();
    canvas.drawPath(pot, stroke);
    canvas.drawLine(Offset(size.width * 0.32, size.height * 0.68), Offset(size.width * 0.68, size.height * 0.68), stroke);

    // Large Feather Quill standing in inkpot
    final quill = Path();
    quill.moveTo(size.width * 0.46, size.height * 0.72);
    quill.lineTo(size.width * 0.78, size.height * 0.15);
    quill.quadraticBezierTo(size.width * 0.56, size.height * 0.25, size.width * 0.44, size.height * 0.56);
    quill.lineTo(size.width * 0.46, size.height * 0.72);
    canvas.drawPath(quill, stroke);

    // Spine
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.15), Offset(size.width * 0.46, size.height * 0.72), stroke);
  }

  // 12. Foreign Language (Globe with speech bubbles A / Д)
  void _drawForeignLanguage(Canvas canvas, Size size) {
    const color = Color(0xFFE11D48);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Central globe
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.54), size.width * 0.28, stroke);
    canvas.drawArc(Rect.fromCircle(center: Offset(size.width * 0.50, size.height * 0.54), radius: size.width * 0.28), -1.0, 2.0, false, stroke);

    // Left Speech Bubble with letter "A"
    final b1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.14, size.height * 0.16, size.width * 0.34, size.height * 0.32),
      const Radius.circular(6),
    );
    canvas.drawRRect(b1, stroke);

    // Letter 'A'
    final textPainterA = TextPainter(
      text: const TextSpan(
        text: 'A',
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainterA.paint(canvas, Offset(size.width * 0.26, size.height * 0.23));

    // Right Speech Bubble with letter "Д"
    final b2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.54, size.height * 0.24, size.width * 0.34, size.height * 0.32),
      const Radius.circular(6),
    );
    canvas.drawRRect(b2, stroke);

    // Letter 'Д' / 'B'
    final textPainterD = TextPainter(
      text: const TextSpan(
        text: 'Д',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainterD.paint(canvas, Offset(size.width * 0.66, size.height * 0.32));
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 5;
    final double innerRadius = radius * 0.45;
    double angle = -math.pi / 2;
    final double step = math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      final double r = i.isEven ? radius : innerRadius;
      final double x = center.dx + math.cos(angle) * r;
      final double y = center.dy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
