import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/player.dart';
import '../../../widgets/widgets.dart';
import '../controllers/role_reveal_controller.dart';

class RoleRevealView extends GetView<RoleRevealController> {
  const RoleRevealView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: ResponsiveBody(
            child: Obx(() => _buildContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isPassPhoneMode.value && !controller.isRevealed.value) {
      return _buildPassPhoneScreen();
    }
    if (controller.isRevealed.value) {
      return _buildRevealedScreen();
    }
    return _buildPassPhoneScreen();
  }

  Widget _buildPassPhoneScreen() {
    final player = controller.currentPlayer;
    return Column(
      children: [
        _buildProgress(),
        const Spacer(),
        Icon(
          Icons.phone_android_rounded,
          size: 64,
          color: AppColors.primary.withOpacity(0.6),
        ).animate().fadeIn().scale(
              begin: const Offset(0.8, 0.8),
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          AppStrings.passPhone,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontMD,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          player.name,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 300.ms),
        const Spacer(),
        GradientButton(
          text: AppStrings.tapToReveal,
          icon: Icons.visibility_rounded,
          onPressed: controller.revealRole,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
        const SizedBox(height: AppDimens.paddingLG),
      ],
    );
  }

  Widget _buildRevealedScreen() {
    final player = controller.currentPlayer;
    final isUndercover = player.role == PlayerRole.undercover;

    return Column(
      children: [
        _buildProgress(),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLG,
            vertical: AppDimens.paddingSM,
          ),
          decoration: BoxDecoration(
            color: isUndercover
                ? AppColors.undercoverColor.withOpacity(0.15)
                : AppColors.citizenColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            border: Border.all(
              color: isUndercover
                  ? AppColors.undercoverColor.withOpacity(0.3)
                  : AppColors.citizenColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            isUndercover ? AppStrings.undercover : AppStrings.citizen,
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontMD,
              fontWeight: FontWeight.w700,
              color: isUndercover
                  ? AppColors.undercoverColor
                  : AppColors.citizenColor,
              letterSpacing: 2,
            ),
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: AppDimens.paddingXL),
        Icon(
          isUndercover
              ? Icons.visibility_off_rounded
              : Icons.shield_rounded,
          size: 72,
          color: isUndercover
              ? AppColors.undercoverColor
              : AppColors.citizenColor,
        ).animate().fadeIn(delay: 200.ms).scale(
              begin: const Offset(0.5, 0.5),
              curve: Curves.elasticOut,
              duration: 800.ms,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          AppStrings.yourWord,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: AppDimens.paddingSM),
        GlassCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL,
            vertical: AppDimens.paddingLG,
          ),
          border: Border.all(
            color: (isUndercover
                    ? AppColors.undercoverColor
                    : AppColors.citizenColor)
                .withOpacity(0.3),
          ),
          child: Text(
            player.secretWord,
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXXL,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ).animate().fadeIn(delay: 500.ms).scale(
            begin: const Offset(0.9, 0.9)),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'Remember this word!',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXS,
            color: AppColors.textMuted,
          ),
        ).animate().fadeIn(delay: 700.ms),
        const Spacer(),
        GradientButton(
          text: controller.isLastPlayer ? 'Start Game' : AppStrings.gotIt,
          icon: controller.isLastPlayer
              ? Icons.play_arrow_rounded
              : Icons.check_rounded,
          onPressed: controller.confirmAndNext,
        ).animate().fadeIn(delay: 800.ms),
        const SizedBox(height: AppDimens.paddingLG),
      ],
    );
  }

  Widget _buildProgress() {
    return Obx(() {
      final total = controller.players.length;
      final current = controller.currentIndex.value + 1;
      return Column(
        children: [
          Text(
            'Player $current of $total',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontSM,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppDimens.paddingSM),
          LinearProgressIndicator(
            value: current / total,
            backgroundColor: AppColors.surfaceLight,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}