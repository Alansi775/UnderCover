import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../controllers/game_round_controller.dart';

class GameRoundView extends GetView<GameRoundController> {
  const GameRoundView({super.key});

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
    if (controller.showPassPhone.value) {
      return _buildPassPhoneScreen();
    }
    return _buildDescriptionScreen();
  }

  Widget _buildPassPhoneScreen() {
    final player = controller.currentPlayer;
    return Column(
      children: [
        const SizedBox(height: AppDimens.paddingMD),
        _buildRoundBadge(),
        const Spacer(flex: 2),
        Icon(
          Icons.phone_android_rounded,
          size: 44,
          color: AppColors.gray700,
        ).animate().fadeIn().scale(
              begin: const Offset(0.9, 0.9),
              curve: Curves.easeOut,
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
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'Your turn to describe',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.gray600,
          ),
        ).animate().fadeIn(delay: 350.ms),
        const Spacer(flex: 3),
        GradientButton(
          text: "I'm Ready",
          icon: Icons.check_rounded,
          onPressed: controller.startDescribing,
        ).animate().fadeIn(delay: 450.ms),
        const SizedBox(height: AppDimens.paddingXL),
      ],
    );
  }

  Widget _buildDescriptionScreen() {
    final player = controller.currentPlayer;
    final turnProgress =
        '${controller.currentTurnIndex.value + 1} / ${controller.alivePlayers.length}';

    return Column(
      children: [
        const SizedBox(height: AppDimens.paddingMD),
        _buildRoundBadge(),
        const SizedBox(height: AppDimens.paddingXL),
        // Player info
        Row(
          children: [
            PlayerAvatar(name: player.name, size: 40),
            const SizedBox(width: AppDimens.paddingMD),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontLG,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Turn $turnProgress',
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontXS,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: AppDimens.paddingXL),
        // Instructions
        GlassCard(
          padding: const EdgeInsets.all(AppDimens.paddingLG),
          child: Column(
            children: [
              Icon(
                Icons.chat_outlined,
                size: 32,
                color: AppColors.gray500,
              ),
              const SizedBox(height: AppDimens.paddingMD),
              Text(
                'Describe Your Word',
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontLG,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppDimens.paddingSM),
              Text(
                'Describe your secret word without saying it. Be creative but not too obvious.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontSM,
                  color: AppColors.gray500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),
        const Spacer(),
        _buildPlayerOrder(),
        const SizedBox(height: AppDimens.paddingLG),
        GradientButton(
          text: controller.isLastTurn
              ? 'Start Voting'
              : 'Done — Next Player',
          icon: controller.isLastTurn
              ? Icons.how_to_vote_outlined
              : Icons.arrow_forward_rounded,
          onPressed: controller.finishTurn,
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: AppDimens.paddingXL),
      ],
    );
  }

  Widget _buildRoundBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingXS,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray800, width: 1),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        'Round ${controller.roundNumber}',
        style: GoogleFonts.inter(
          fontSize: AppDimens.fontXS,
          fontWeight: FontWeight.w600,
          color: AppColors.gray400,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPlayerOrder() {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.alivePlayers.length,
          (index) {
            final player = controller.alivePlayers[index];
            final isCurrent =
                index == controller.currentTurnIndex.value;
            final isDone =
                index < controller.currentTurnIndex.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: PlayerAvatar(
                name: player.name,
                size: isCurrent ? 38 : 30,
                isSelected: isCurrent,
                isEliminated: isDone,
              ),
            );
          },
        ),
      ),
    );
  }
}