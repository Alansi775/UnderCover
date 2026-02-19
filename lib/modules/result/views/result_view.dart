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
          child: ResponsiveBody(
            child: Column(
              children: [
                const Spacer(),
                _buildResultIcon(),
                const SizedBox(height: AppDimens.paddingXL),
                _buildResultTitle(),
                const SizedBox(height: AppDimens.paddingSM),
                _buildResultSubtitle(),
                const SizedBox(height: AppDimens.paddingXXL),
                _buildUndercoverReveal(),
                const SizedBox(height: AppDimens.paddingLG),
                _buildWordPairReveal(),
                const SizedBox(height: AppDimens.paddingLG),
                _buildPlayerSummary(),
                const Spacer(),
                _buildButtons(),
                const SizedBox(height: AppDimens.paddingLG),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    final won = controller.citizensWon;
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: won
            ? AppColors.primaryGradient
            : AppColors.dangerGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (won
                    ? AppColors.citizenColor
                    : AppColors.undercoverColor)
                .withOpacity(0.4),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Icon(
        won ? Icons.shield_rounded : Icons.visibility_off_rounded,
        size: 56,
        color: Colors.white,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(
          begin: const Offset(0.3, 0.3),
          curve: Curves.elasticOut,
          duration: 1000.ms,
        );
  }

  Widget _buildResultTitle() {
    return Text(
      controller.citizensWon
          ? AppStrings.citizensWin
          : AppStrings.undercoverWins,
      style: GoogleFonts.inter(
        fontSize: AppDimens.fontXXL,
        fontWeight: FontWeight.w800,
        color: controller.citizensWon
            ? AppColors.citizenColor
            : AppColors.undercoverColor,
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildResultSubtitle() {
    return Text(
      controller.citizensWon
          ? AppStrings.citizensWinDesc
          : AppStrings.undercoverWinsDesc,
      style: GoogleFonts.inter(
        fontSize: AppDimens.fontMD,
        color: AppColors.textSecondary,
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildUndercoverReveal() {
    final undercover = controller.undercoverPlayer;
    if (undercover == null) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(AppDimens.paddingLG),
      border: Border.all(
        color: AppColors.undercoverColor.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayerAvatar(
            name: undercover.name,
            size: 44,
            color: AppColors.undercoverColor,
          ),
          const SizedBox(width: AppDimens.paddingMD),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.theUndercoverWas,
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontXS,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              Text(
                undercover.name,
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontLG,
                  fontWeight: FontWeight.w800,
                  color: AppColors.undercoverColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2);
  }

  Widget _buildWordPairReveal() {
    final pair = controller.wordPair;
    if (pair == null) return const SizedBox.shrink();

    return GlassCard(
      padding: const EdgeInsets.all(AppDimens.paddingLG),
      child: Column(
        children: [
          Text(
            AppStrings.theWordPairWas,
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppDimens.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWordChip(pair.wordA, AppColors.citizenColor),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMD),
                child: Text(
                  '—',
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontLG,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              _buildWordChip(pair.wordB, AppColors.undercoverColor),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2);
  }

  Widget _buildWordChip(String word, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingSM,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        word,
        style: GoogleFonts.inter(
          fontSize: AppDimens.fontMD,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPlayerSummary() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: controller.allPlayers.map((player) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: PlayerAvatar(
              name: player.name,
              size: 36,
              isEliminated: player.isEliminated,
              color: player.isUndercover
                  ? AppColors.undercoverColor
                  : null,
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 1100.ms);
  }

  Widget _buildButtons() {
    return Column(
      children: [
        GradientButton(
          text: AppStrings.playAgain,
          icon: Icons.replay_rounded,
          onPressed: controller.playAgain,
        ),
        const SizedBox(height: AppDimens.paddingSM),
        TextButton(
          onPressed: controller.backToMenu,
          child: Text(
            AppStrings.backToMenu,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: AppDimens.fontMD,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1300.ms);
  }
}