import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../controllers/voting_controller.dart';

class EliminationView extends StatelessWidget {
  const EliminationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VotingController>();

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
                child: Obx(() {
                  final eliminated = controller.eliminatedPlayer.value;
                  final isTie = controller.isTie.value;

                  return Column(
                    children: [
                      const Spacer(flex: 2),
                      if (isTie)
                        _buildTieScreen()
                      else
                        _buildEliminationScreen(eliminated!),
                      const Spacer(flex: 3),
                      GradientButton(
                        text: 'Continue',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: controller.continueAfterElimination,
                      ).animate().fadeIn(delay: 1000.ms),
                      const SizedBox(height: AppDimens.paddingXL),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTieScreen() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gray700,
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.balance_rounded,
            size: 32,
            color: AppColors.gray400,
          ),
        ).animate().fadeIn().scale(
              begin: const Offset(0.8, 0.8),
              curve: Curves.easeOut,
              duration: 500.ms,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          "It's a Tie",
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'No one is eliminated.\nProceeding to next round.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.gray500,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildEliminationScreen(player) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.danger.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: PlayerAvatar(
              name: player.name,
              size: 64,
              isEliminated: true,
            ),
          ),
        ).animate().fadeIn().scale(
              begin: const Offset(0.8, 0.8),
              curve: Curves.easeOut,
              duration: 500.ms,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          player.name,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'has been eliminated',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontMD,
            color: AppColors.danger,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 450.ms),
        const SizedBox(height: AppDimens.paddingLG),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingMD,
            vertical: AppDimens.paddingSM,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.gray800,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
          child: Text(
            '${player.votesReceived} votes',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontSM,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}