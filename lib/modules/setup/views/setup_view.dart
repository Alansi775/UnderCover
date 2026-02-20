import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../controllers/setup_controller.dart';

class SetupView extends GetView<SetupController> {
  const SetupView({super.key});

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
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLG,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppDimens.paddingMD),
                          _buildPlayerCounter(),
                          const SizedBox(height: AppDimens.paddingXL),
                          _buildPlayerNamesList(),
                          const SizedBox(height: AppDimens.paddingXL),
                          Center(child: _buildStartButton()),
                          const SizedBox(height: AppDimens.paddingXL),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingSM,
        vertical: AppDimens.paddingSM,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: AppDimens.iconSM,
              color: AppColors.gray400,
            ),
          ),
          Expanded(
            child: Text(
              'New Game',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontLG,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPlayerCounter() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingLG,
        vertical: AppDimens.paddingXL,
      ),
      child: Column(
        children: [
          Text(
            'PLAYERS',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              color: AppColors.gray500,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimens.paddingLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                icon: Icons.remove_rounded,
                onPressed: controller.decrementPlayers,
              ),
              const SizedBox(width: AppDimens.paddingXL),
              Obx(() => Text(
                    '${controller.playerCount.value}',
                    style: GoogleFonts.inter(
                      fontSize: AppDimens.fontHero,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      height: 1,
                    ),
                  )),
              const SizedBox(width: AppDimens.paddingXL),
              _buildCounterButton(
                icon: Icons.add_rounded,
                onPressed: controller.incrementPlayers,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingSM),
          Text(
            '${SetupController.minPlayers}–${SetupController.maxPlayers} players',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              color: AppColors.gray600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.gray700,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.gray400,
          size: AppDimens.iconSM,
        ),
      ),
    );
  }

  Widget _buildPlayerNamesList() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PLAYER NAMES',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              fontWeight: FontWeight.w600,
              color: AppColors.gray500,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: AppDimens.paddingMD),
          ...List.generate(
            controller.playerCount.value,
            (index) => _buildPlayerNameField(index),
          ),
        ],
      );
    });
  }

  Widget _buildPlayerNameField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingSM),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontSM,
                fontWeight: FontWeight.w600,
                color: AppColors.gray600,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.paddingSM),
          Expanded(
            child: TextField(
              controller: controller.controllers[index],
              onChanged: (value) =>
                  controller.updatePlayerName(index, value),
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: AppDimens.fontMD,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Player ${index + 1}',
                suffixIcon: controller.playerCount.value >
                        SetupController.minPlayers
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.gray600,
                        ),
                        onPressed: () =>
                            controller.removePlayer(index),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: 40 * index),
          duration: 300.ms,
        );
  }

  Widget _buildStartButton() {
    return GradientButton(
      text: 'Start Game',
      icon: Icons.arrow_forward_rounded,
      onPressed: controller.startGame,
    ).animate().fadeIn(delay: 400.ms);
  }
}