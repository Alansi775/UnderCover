import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;
import '../../../core/constants/constants.dart';

class HowToPlayOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const HowToPlayOverlay({super.key, required this.onClose});

  static const _steps = [
    'Add 3–12 players and start the game.',
    'Each player privately sees their role and word. One is the Undercover.',
    'Take turns describing your word without saying it.',
    'After each round, vote for who you think is the Undercover.',
    'Citizens win if Undercover is eliminated. Undercover wins if only 2 remain.',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
                color: AppColors.black.withOpacity(0.5)),
          ),
        ).animate().fadeIn(duration: 300.ms),
        Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(AppDimens.paddingLG),
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(AppDimens.paddingXL),
              decoration: BoxDecoration(
                color: const Color(0xFF0d0d0d).withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                    color: AppColors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.8),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppDimens.paddingXL),
                  ..._steps.asMap().entries.map(
                      (e) => _buildStep(e.key, e.value)),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(
                    begin: const Offset(0.95, 0.95),
                    curve: Curves.easeOut,
                    duration: 300.ms),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RULES',
                style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray600,
                    letterSpacing: 3)),
            const SizedBox(height: 4),
            Text('How to Play',
                style: GoogleFonts.inter(
                    fontSize: AppDimens.fontXL,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white)),
          ],
        ),
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.06),
            ),
            child: const Icon(Icons.close_rounded,
                size: 16, color: AppColors.gray400),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int index, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin:
                const EdgeInsets.only(right: AppDimens.paddingMD),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.white.withOpacity(0.04),
              border: Border.all(
                  color: AppColors.white.withOpacity(0.06)),
            ),
            child: Center(
              child: Text('${index + 1}',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray400)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text,
                  style: GoogleFonts.inter(
                      fontSize: AppDimens.fontSM,
                      color: AppColors.gray400,
                      height: 1.5)),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
            delay: (150 + index * 80).ms, duration: 400.ms)
        .slideX(
            begin: 0.05,
            delay: (150 + index * 80).ms,
            duration: 400.ms);
  }
}