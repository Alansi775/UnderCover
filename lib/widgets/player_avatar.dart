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
    this.size = 44,
    this.isEliminated = false,
    this.isSelected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final bgColor = color ?? _colorFromName(name);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEliminated
            ? AppColors.gray800
            : bgColor.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? AppColors.white
              : isEliminated
                  ? AppColors.gray700
                  : bgColor.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.inter(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w600,
            color: isEliminated
                ? AppColors.gray600
                : bgColor,
          ),
        ),
      ),
    );
  }

  static Color _colorFromName(String name) {
    final colors = [
      AppColors.primary,
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
      const Color(0xFFF97316),
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}