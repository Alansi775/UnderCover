import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class SmokePainter extends CustomPainter {
  final double time;
  SmokePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final speeds = [0.13, 0.091, 0.077, 0.053, 0.117, 0.069];
    final sizes = [20.0, 16.0, 22.0, 14.0, 18.0, 12.0];
    final opacities = [0.2, 0.15, 0.12, 0.18, 0.1, 0.14];
    final orbits = [18.0, 14.0, 20.0, 12.0, 16.0, 10.0];
    final phases = [0.0, 1.3, 2.7, 4.1, 5.3, 0.8];

    for (int i = 0; i < speeds.length; i++) {
      final angle = time * speeds[i] * 2 * math.pi + phases[i];
      final bx = cx + math.cos(angle) * orbits[i];
      final by =
          cy + math.sin(angle * 0.7 + phases[i]) * orbits[i] * 0.8;

      final rect = Rect.fromCenter(
        center: Offset(bx, by),
        width: sizes[i] * 1.4,
        height: sizes[i],
      );

      final paint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(bx, by),
          sizes[i] * 0.9,
          [
            Colors.black.withOpacity(opacities[i]),
            Colors.black.withOpacity(opacities[i] * 0.4),
            Colors.black.withOpacity(opacities[i] * 0.1),
            Colors.transparent,
          ],
          [0.0, 0.3, 0.6, 1.0],
        );

      canvas.save();
      canvas.translate(bx, by);
      canvas.rotate(angle * 0.3);
      canvas.translate(-bx, -by);
      canvas.drawOval(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant SmokePainter old) => true;
}