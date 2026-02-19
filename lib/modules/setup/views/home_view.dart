import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../../app/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // For very wide screens, cap content width and scale down oversized elements
    final maxContentWidth = width * 0.9 > 900 ? 900.0 : width * 0.9;
    final scale = width <= 900 ? 1.0 : 900 / width;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingLG),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    _buildLogo(context, scale),
                    const SizedBox(height: AppDimens.paddingMD),
                    Text(
                      AppStrings.tagline,
                      style: GoogleFonts.inter(
                        fontSize: AppDimens.fontMD * scale,
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                    const Spacer(flex: 3),
                    GradientButton(
                      text: 'New Game',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () => Get.toNamed(Routes.setup),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
                    const SizedBox(height: AppDimens.paddingMD),
                    _buildHowToPlayButton(context),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, double scale) {
    final width = MediaQuery.of(context).size.width;
    final logoSize = (width * 0.12).clamp(72.0, 140.0);
    final iconSize = (logoSize * 0.48).clamp(32.0, 64.0);

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Icon(
            Icons.visibility_off_rounded,
            size: iconSize,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 800.ms).scale(
              begin: const Offset(0.5, 0.5),
              curve: Curves.elasticOut,
              duration: 1000.ms,
            ),
        const SizedBox(height: AppDimens.paddingLG),
        Text(
          AppStrings.appName.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontDisplay * scale,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 6,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildHowToPlayButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showHowToPlay(context),
      icon: const Icon(
          Icons.help_outline_rounded, color: AppColors.textSecondary),
      label: Text(
        'How to Play',
        style: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: AppDimens.fontMD,
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  void _showHowToPlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.paddingLG),
            Text(
              'How to Play',
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontXL,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.paddingMD),
            ..._howToPlaySteps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(
                    bottom: AppDimens.paddingSM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(
                          right: AppDimens.paddingSM, top: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          step['num']!,
                          style: GoogleFonts.inter(
                            fontSize: AppDimens.fontXS,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        step['text']!,
                        style: GoogleFonts.inter(
                          fontSize: AppDimens.fontSM,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.paddingMD),
          ],
        ),
      ),
    );
  }

  static const _howToPlaySteps = [
    {'num': '1', 'text': 'Add 3–12 players and start the game.'},
    {
      'num': '2',
      'text':
          'Each player privately views their secret role and word. One player is the Undercover with a slightly different word.'
    },
    {
      'num': '3',
      'text':
          'Take turns describing your word without saying it directly.'
    },
    {
      'num': '4',
      'text':
          'After each round, vote for who you think is the Undercover.'
    },
    {
      'num': '5',
      'text':
          'Citizens win if the Undercover is eliminated. The Undercover wins if only 2 players remain.'
    },
  ];
}