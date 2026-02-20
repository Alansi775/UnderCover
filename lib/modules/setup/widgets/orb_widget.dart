import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'smoke_painter.dart';

class OrbWidget extends StatelessWidget {
  final double elapsed;

  const OrbWidget({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final float = math.sin(elapsed * 0.4) * 4;

    return Transform.translate(
      offset: Offset(0, float),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.35),
            radius: 0.85,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.7),
              Colors.white.withOpacity(0.4),
              const Color(0xFFb0b0b0),
            ],
            stops: const [0.0, 0.25, 0.55, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 60,
              spreadRadius: 20,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.04),
              blurRadius: 100,
              spreadRadius: 40,
            ),
          ],
        ),
        child: ClipOval(
          child: CustomPaint(
            size: const Size(110, 110),
            painter: SmokePainter(time: elapsed),
          ),
        ),
      ),
    );
  }
}