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
          child: ResponsiveBody(
            child: Obx(() {
              final eliminated = controller.eliminatedPlayer.value;
              final isTie = controller.isTie.value;

              return Column(
                children: [
                  const Spacer(),
                  if (isTie)
                    _buildTieScreen()
                  else
                    _buildEliminationScreen(eliminated!),
                  const Spacer(),
                  GradientButton(
                    text: AppStrings.continueGame,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: controller.continueAfterElimination,
                  ).animate().fadeIn(delay: 1200.ms),
                  const SizedBox(height: AppDimens.paddingLG),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTieScreen() {
    return Column(
      children: [
        const Icon(
          Icons.balance_rounded,
          size: 80,
          color: AppColors.warning,
        ).animate().fadeIn().scale(
              begin: const Offset(0.5, 0.5),
              curve: Curves.elasticOut,
              duration: 800.ms,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          AppStrings.noElimination,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w800,
            color: AppColors.warning,
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: AppDimens.paddingMD),
        Text(
          AppStrings.noEliminationDesc,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontMD,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildEliminationScreen(player) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.danger.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.danger.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: PlayerAvatar(
              name: player.name,
              size: 70,
              isEliminated: true,
            ),
          ),
        ).animate().fadeIn().scale(
              begin: const Offset(0.5, 0.5),
              curve: Curves.elasticOut,
              duration: 800.ms,
            ),
        const SizedBox(height: AppDimens.paddingXL),
        Text(
          player.name,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w800,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'has been eliminated!',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontLG,
            color: AppColors.danger,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: AppDimens.paddingXL),
        GlassCard(
          padding: const EdgeInsets.all(AppDimens.paddingMD),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.how_to_vote_rounded,
                  color: AppColors.textMuted, size: 20),
              const SizedBox(width: AppDimens.paddingSM),
              Text(
                '${player.votesReceived} votes',
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontMD,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }
}