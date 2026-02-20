import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class RibbonPainter extends CustomPainter {
  final double time;
  final double centerY;
  RibbonPainter({required this.time, required this.centerY});

  @override
  void paint(Canvas canvas, Size size) {
    _paintStrand(canvas, size, 0.17, 0.0, 20, 0.065);
    _paintStrand(canvas, size, 0.11, 1.9, 14, 0.04);
    _paintStrand(canvas, size, 0.07, 3.7, 10, 0.022);
  }

  void _paintStrand(Canvas canvas, Size size, double speed,
      double phase, double thick, double opacity) {
    final t = time * speed * 2 * math.pi;
    final topPts = <Offset>[];
    final botPts = <Offset>[];

    for (double x = 0; x <= size.width; x += 3) {
      final nx = x / size.width;
      final w1 = math.sin(nx * 3.7 + t + phase) * 30;
      final w2 = math.sin(nx * 6.3 + t * 1.3 + phase * 1.7) * 16;
      final w3 = math.cos(nx * 2.1 + t * 0.7 + phase * 2.3) * 10;
      final cd = (nx - 0.5);
      final twist =
          math.exp(-cd * cd * 10) * 22 * math.sin(t * 0.4 + phase);
      final y = centerY + w1 + w2 + w3 + twist;
      topPts.add(Offset(x, y - thick / 2));
      botPts.add(Offset(x, y + thick / 2));
    }

    final path = Path();
    path.moveTo(topPts.first.dx, topPts.first.dy);
    for (final p in topPts) {
      path.lineTo(p.dx, p.dy);
    }
    for (final p in botPts.reversed) {
      path.lineTo(p.dx, p.dy);
    }
    path.close();

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, centerY),
        Offset(size.width, centerY),
        [
          Colors.transparent,
          Colors.white.withOpacity(opacity * 0.3),
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.3),
          Colors.transparent,
        ],
        const [0.0, 0.1, 0.3, 0.7, 0.9, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RibbonPainter old) => true;
}