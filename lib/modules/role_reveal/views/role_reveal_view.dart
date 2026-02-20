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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimens.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingLG,
                ),
                child: Obx(() => _buildContent()),
              ),
            ),
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
        const SizedBox(height: AppDimens.paddingMD),
        _buildProgress(),
        const Spacer(flex: 2),
        Icon(
          Icons.phone_android_rounded,
          size: 44,
          color: AppColors.gray700,
        ).animate().fadeIn().scale(
              begin: const Offset(0.9, 0.9),
              curve: Curves.easeOut,
              duration: 400.ms,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          'Pass the phone to',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.gray500,
            letterSpacing: 1,
          ),
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          player.name,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 250.ms),
        const Spacer(flex: 3),
        GradientButton(
          text: 'Reveal My Role',
          icon: Icons.visibility_rounded,
          onPressed: controller.revealRole,
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: AppDimens.paddingXL),
      ],
    );
  }

  Widget _buildRevealedScreen() {
    final player = controller.currentPlayer;
    final isUndercover = player.role == PlayerRole.undercover;

    return Column(
      children: [
        const SizedBox(height: AppDimens.paddingMD),
        _buildProgress(),
        const Spacer(flex: 2),
        // Role label
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingMD,
            vertical: AppDimens.paddingSM,
          ),
          decoration: BoxDecoration(
            color: isUndercover
                ? AppColors.danger.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            border: Border.all(
              color: isUndercover
                  ? AppColors.danger.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: Text(
            isUndercover ? 'UNDERCOVER' : 'CITIZEN',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              fontWeight: FontWeight.w700,
              color: isUndercover
                  ? AppColors.danger
                  : AppColors.primary,
              letterSpacing: 3,
            ),
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
        const SizedBox(height: AppDimens.paddingXL),
        // Word
        Text(
          'Your word',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXS,
            color: AppColors.gray600,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          player.secretWord,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontDisplay,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            letterSpacing: -1,
            height: 1,
          ),
        ).animate().fadeIn(delay: 350.ms).scale(
              begin: const Offset(0.95, 0.95),
              curve: Curves.easeOut,
            ),
        const SizedBox(height: AppDimens.paddingLG),
        Text(
          'Remember this word',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXS,
            color: AppColors.gray600,
          ),
        ).animate().fadeIn(delay: 500.ms),
        const Spacer(flex: 3),
        GradientButton(
          text: controller.isLastPlayer ? 'Start Game' : 'Got it',
          icon: controller.isLastPlayer
              ? Icons.arrow_forward_rounded
              : Icons.check_rounded,
          onPressed: controller.confirmAndNext,
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: AppDimens.paddingXL),
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
            '$current of $total',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              color: AppColors.gray600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppDimens.paddingSM),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: AppColors.gray800,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.white),
              minHeight: 2,
            ),
          ),
        ],
      );
    });
  }
}