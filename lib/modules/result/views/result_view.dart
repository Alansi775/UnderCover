import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../controllers/result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimens.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingLG,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    _buildResultIcon(),
                    const SizedBox(height: AppDimens.paddingXL),
                    _buildResultTitle(),
                    const SizedBox(height: AppDimens.paddingSM),
                    _buildResultSubtitle(),
                    const SizedBox(height: AppDimens.paddingXXL),
                    _buildUndercoverReveal(),
                    const SizedBox(height: AppDimens.paddingMD),
                    _buildWordPairReveal(),
                    const SizedBox(height: AppDimens.paddingLG),
                    _buildPlayerSummary(),
                    const Spacer(flex: 3),
                    _buildButtons(),
                    const SizedBox(height: AppDimens.paddingXL),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    final won = controller.citizensWon;
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: won
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.danger.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: won
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.danger.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Icon(
        won ? Icons.shield_outlined : Icons.visibility_off_rounded,
        size: 36,
        color: won ? AppColors.primary : AppColors.danger,
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          curve: Curves.easeOut,
          duration: 500.ms,
        );
  }

  Widget _buildResultTitle() {
    return Text(
      controller.citizensWon ? 'Citizens Win' : 'Undercover Wins',
      style: GoogleFonts.inter(
        fontSize: AppDimens.fontXXL,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: -0.5,
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildResultSubtitle() {
    return Text(
      controller.citizensWon
          ? 'The Undercover has been found'
          : 'The Undercover survived',
      style: GoogleFonts.inter(
        fontSize: AppDimens.fontSM,
        color: AppColors.gray500,
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildUndercoverReveal() {
    final undercover = controller.undercoverPlayer;
    if (undercover == null) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      child: Row(
        children: [
          PlayerAvatar(
            name: undercover.name,
            size: 40,
            color: AppColors.danger,
          ),
          const SizedBox(width: AppDimens.paddingMD),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THE UNDERCOVER',
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontXS,
                  color: AppColors.gray600,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                undercover.name,
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontLG,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.05);
  }

  Widget _buildWordPairReveal() {
    final pair = controller.wordPair;
    if (pair == null) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      child: Column(
        children: [
          Text(
            'WORD PAIR',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              color: AppColors.gray600,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimens.paddingMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWordChip(pair.wordA, AppColors.primary),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMD),
                child: Text(
                  '—',
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontMD,
                    color: AppColors.gray700,
                  ),
                ),
              ),
              _buildWordChip(pair.wordB, AppColors.danger),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.05);
  }

  Widget _buildWordChip(String word, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingSM,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Text(
        word,
        style: GoogleFonts.inter(
          fontSize: AppDimens.fontSM,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPlayerSummary() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: controller.allPlayers.map((player) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: PlayerAvatar(
              name: player.name,
              size: 32,
              isEliminated: player.isEliminated,
              color: player.isUndercover ? AppColors.danger : null,
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 850.ms);
  }

  Widget _buildButtons() {
    return Column(
      children: [
        GradientButton(
          text: 'Play Again',
          icon: Icons.replay_rounded,
          onPressed: controller.playAgain,
        ),
        const SizedBox(height: AppDimens.paddingSM),
        GradientButton(
          text: 'Back to Menu',
          icon: Icons.home_outlined,
          isOutlined: true,
          onPressed: controller.backToMenu,
        ),
      ],
    ).animate().fadeIn(delay: 1000.ms);
  }
}