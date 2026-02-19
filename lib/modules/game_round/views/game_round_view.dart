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
          child: ResponsiveBody(
            child: Obx(() => _buildContent()),
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
        _buildRoundHeader(),
        const Spacer(),
        Icon(
          Icons.phone_android_rounded,
          size: 56,
          color: AppColors.primary.withOpacity(0.6),
        ).animate().fadeIn().scale(
              begin: const Offset(0.8, 0.8),
              curve: Curves.elasticOut,
            ),
        const SizedBox(height: AppDimens.paddingLG),
        Text(
          'Pass the phone to',
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
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          "It's your turn to describe",
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.textMuted,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const Spacer(),
        GradientButton(
          text: "I'm Ready",
          icon: Icons.check_circle_outline_rounded,
          onPressed: controller.startDescribing,
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: AppDimens.paddingLG),
      ],
    );
  }

  Widget _buildDescriptionScreen() {
    final player = controller.currentPlayer;
    final turnProgress =
        '${controller.currentTurnIndex.value + 1} / ${controller.alivePlayers.length}';

    return Column(
      children: [
        _buildRoundHeader(),
        const SizedBox(height: AppDimens.paddingLG),
        Row(
          children: [
            PlayerAvatar(name: player.name, size: 48),
            const SizedBox(width: AppDimens.paddingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: GoogleFonts.inter(
                      fontSize: AppDimens.fontLG,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Turn $turnProgress',
                    style: GoogleFonts.inter(
                      fontSize: AppDimens.fontSM,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: AppDimens.paddingXL),
        GlassCard(
          padding: const EdgeInsets.all(AppDimens.paddingLG),
          child: Column(
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppDimens.paddingMD),
              Text(
                'Describe Your Word',
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontLG,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimens.paddingSM),
              Text(
                'Describe your secret word to the other players without saying the word itself. Be creative but not too obvious!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: AppDimens.fontSM,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        const Spacer(),
        _buildPlayerOrder(),
        const SizedBox(height: AppDimens.paddingLG),
        GradientButton(
          text: controller.isLastTurn
              ? 'Start Voting'
              : 'Done — Next Player',
          icon: controller.isLastTurn
              ? Icons.how_to_vote_rounded
              : Icons.arrow_forward_rounded,
          onPressed: controller.finishTurn,
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: AppDimens.paddingLG),
      ],
    );
  }

  Widget _buildRoundHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingMD,
            vertical: AppDimens.paddingSM,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
          child: Text(
            '${AppStrings.roundTitle} ${controller.roundNumber}',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontSM,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerOrder() {
    return SizedBox(
      height: 48,
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
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: PlayerAvatar(
                  name: player.name,
                  size: isCurrent ? 40 : 32,
                  isSelected: isCurrent,
                  isEliminated: isDone,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}