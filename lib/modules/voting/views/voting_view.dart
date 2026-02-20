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
    return _buildVotingScreen();
  }

  Widget _buildPassPhoneScreen() {
    final voter = controller.currentVoter;
    return Column(
      children: [
        const SizedBox(height: AppDimens.paddingMD),
        _buildVotingBadge(),
        const Spacer(flex: 2),
        Icon(
          Icons.how_to_vote_outlined,
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
          voter.name,
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontXXL,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: AppDimens.paddingSM),
        Text(
          'Time to vote',
          style: GoogleFonts.inter(
            fontSize: AppDimens.fontSM,
            color: AppColors.gray600,
          ),
        ).animate().fadeIn(delay: 350.ms),
        const Spacer(flex: 3),
        GradientButton(
          text: "I'm Ready to Vote",
          icon: Icons.check_rounded,
          onPressed: controller.startVoting,
        ).animate().fadeIn(delay: 450.ms),
        const SizedBox(height: AppDimens.paddingXL),
      ],
    );
  }

  Widget _buildVotingScreen() {
    final voter = controller.currentVoter;
    final votable = controller.votablePlayersForCurrentVoter;

    return Column(
      children: [
        const SizedBox(height: AppDimens.paddingMD),
        _buildVotingBadge(),
        const SizedBox(height: AppDimens.paddingLG),
        // Voter info
        Row(
          children: [
            PlayerAvatar(name: voter.name, size: 36),
            const SizedBox(width: AppDimens.paddingMD),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voter.name,
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontMD,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Who is the Undercover?',
                  style: GoogleFonts.inter(
                    fontSize: AppDimens.fontXS,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppDimens.paddingLG),
        // Vote options
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
              text: 'Confirm Vote',
              icon: Icons.check_rounded,
              onPressed: controller.selectedPlayerId.value.isNotEmpty
                  ? controller.confirmVote
                  : null,
            )),
        const SizedBox(height: AppDimens.paddingXL),
      ],
    );
  }

  Widget _buildVoteOption(player) {
    return Obx(() {
      final isSelected =
          controller.selectedPlayerId.value == player.id;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.paddingSM),
        child: GestureDetector(
          onTap: () => controller.selectPlayer(player.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppDimens.paddingMD),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.white.withOpacity(0.05)
                  : AppColors.darkCard,
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(
                color: isSelected
                    ? AppColors.white.withOpacity(0.3)
                    : AppColors.gray800,
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                PlayerAvatar(
                  name: player.name,
                  size: 40,
                  isSelected: isSelected,
                ),
                const SizedBox(width: AppDimens.paddingMD),
                Expanded(
                  child: Text(
                    player.name,
                    style: GoogleFonts.inter(
                      fontSize: AppDimens.fontMD,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.gray400,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.white
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.gray700,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.black,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      );
    }).animate().fadeIn(delay: 80.ms);
  }

  Widget _buildVotingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMD,
        vertical: AppDimens.paddingXS,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray800, width: 1),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.how_to_vote_outlined,
            size: 14,
            color: AppColors.gray400,
          ),
          const SizedBox(width: AppDimens.paddingSM),
          Text(
            'VOTING',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              fontWeight: FontWeight.w600,
              color: AppColors.gray400,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}