import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' as ui;
import '../../../core/constants/constants.dart';

class HomeWelcomeOverlay extends StatelessWidget {
  final VoidCallback onEnter;

  const HomeWelcomeOverlay({super.key, required this.onEnter});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
              color: AppColors.black.withOpacity(0.85)),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(),
                const SizedBox(height: AppDimens.paddingXL),
                _buildTitle(),
                const SizedBox(height: AppDimens.paddingSM),
                _buildSubtitle(),
                const SizedBox(height: AppDimens.paddingXXL),
                _buildEnterButton(),
                const SizedBox(height: AppDimens.paddingLG),
                _buildHint(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.35),
          radius: 0.85,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.6),
            Colors.white.withOpacity(0.3),
            const Color(0xFFb0b0b0),
          ],
          stops: const [0.0, 0.25, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withOpacity(0.1),
            blurRadius: 50,
            spreadRadius: 15,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 1000.ms)
        .scale(
            begin: const Offset(0.5, 0.5),
            duration: 1200.ms,
            curve: Curves.easeOut);
  }

  Widget _buildTitle() {
    return Text(
      'UNDERCOVER',
      style: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        letterSpacing: 8,
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 600.ms);
  }

  Widget _buildSubtitle() {
    return Text(
      'A game of deception',
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.gray500,
        letterSpacing: 2,
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildEnterButton() {
    return GestureDetector(
      onTap: onEnter,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppDimens.radiusFull),
          boxShadow: [
            BoxShadow(
              color: AppColors.white.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow_rounded,
                size: 18, color: AppColors.black),
            const SizedBox(width: 8),
            Text(
              'Enter',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms)
        .slideY(begin: 0.15)
        .then(delay: 500.ms)
        .shimmer(
            duration: 2000.ms,
            color: AppColors.white.withOpacity(0.2));
  }

  Widget _buildHint() {
    return Text(
      'Tap to begin',
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.gray600,
        letterSpacing: 4,
      ),
    )
        .animate()
        .fadeIn(delay: 1400.ms, duration: 800.ms)
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(
          begin: 1,
          end: 0.3,
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }
}