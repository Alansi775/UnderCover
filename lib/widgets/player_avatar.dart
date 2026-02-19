import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/constants.dart';

class PlayerAvatar extends StatelessWidget {
  final String name;
  final double size;
  final bool isEliminated;
  final bool isSelected;
  final Color? color;

  const PlayerAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.isEliminated = false,
    this.isSelected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final bgColor = color ??
        _colorFromName(name).withOpacity(isEliminated ? 0.3 : 1.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 3)
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.inter(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: isEliminated
                ? Colors.white.withOpacity(0.5)
                : Colors.white,
          ),
        ),
      ),
    );
  }

  static Color _colorFromName(String name) {
    final colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFFFF6B6B),
      const Color(0xFF00D2A0),
      const Color(0xFFFFD93D),
      const Color(0xFFFF9FF3),
      const Color(0xFF54A0FF),
      const Color(0xFFFFA502),
      const Color(0xFF2ED573),
      const Color(0xFFFF4757),
      const Color(0xFF5352ED),
      const Color(0xFF1DD1A1),
      const Color(0xFFFF6348),
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}