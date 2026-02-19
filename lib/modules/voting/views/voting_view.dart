import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../controllers/voting_controller.dart';

class VotingView extends GetView<VotingController> {
  const VotingView({super.key});

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
    return _buildVotingScreen();
  }

  Widget _buildPassPhoneScreen() {
    final voter = controller.currentVoter;
    return Column(
      children: [
        _buildVotingHeader(),
        const Spacer(),
        const Icon(
          Icons.how_to_vote_rounded,
          size: 56,
          color: AppColors.accent,
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
          voter.name,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w800,
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'Time to vote!',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.textMuted,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const Spacer(),
        GradientButton(
          text: "I'm Ready to Vote",
          icon: Icons.check_circle_outline_rounded,
          gradient: AppColors.dangerGradient,
          onPressed: controller.startVoting,
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: AppDimens.paddingLG),
      ],
    );
  }

  Widget _buildVotingScreen() {
    final voter = controller.currentVoter;
    final votable = controller.votablePlayersForCurrentVoter;

    return Column(
      children: [
        _buildVotingHeader(),
        const SizedBox(height: AppDimens.paddingMD),
        Row(
          children: [
            PlayerAvatar(name: voter.name, size: 40),
            const SizedBox(width: AppDimens.paddingMD),
            Text(
              '${voter.name} ${AppStrings.votingFor}',
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontMD,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          AppStrings.voteInstruction,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimens.paddingLG),
        Expanded(
          child: ListView.builder(
            itemCount: votable.length,
            itemBuilder: (context, index) {
              final player = votable[index];
              return _buildVoteOption(player);
            },
          ),
        ),
        const SizedBox(height: AppDimens.paddingMD),
        Obx(() => GradientButton(
              text: AppStrings.confirmVote,
              icon: Icons.check_rounded,
              gradient: AppColors.dangerGradient,
              onPressed: controller.selectedPlayerId.value.isNotEmpty
                  ? controller.confirmVote
                  : null,
            )),
        const SizedBox(height: AppDimens.paddingLG),
      ],
    );
  }

  Widget _buildVoteOption(player) {
    return Obx(() {
      final isSelected =
          controller.selectedPlayerId.value == player.id;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.paddingSM),
        child: GlassCard(
          onTap: () => controller.selectPlayer(player.id),
          padding: const EdgeInsets.all(AppDimens.paddingMD),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : AppColors.surfaceLight.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.accent.withOpacity(0.1)
              : AppColors.surface.withOpacity(0.8),
          child: Row(
            children: [
              PlayerAvatar(
                name: player.name,
                size: 44,
                isSelected: isSelected,
              ),
              const SizedBox(width: AppDimens.paddingMD),
              Expanded(
                child: Text(
                  player.name,
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontMD,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accent,
                ),
            ],
          ),
        ),
      );
    }).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildVotingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.how_to_vote_rounded,
              size: 16, color: AppColors.accent),
          const SizedBox(width: AppDimens.paddingSM),
          Text(
            AppStrings.votingTitle,
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontSM,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}