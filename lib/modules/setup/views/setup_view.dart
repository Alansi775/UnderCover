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
          child: ResponsiveBody(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlayerCounter(),
                        const SizedBox(height: AppDimens.paddingLG),
                        _buildPlayerNamesList(),
                        const SizedBox(height: AppDimens.paddingXL),
                        _buildStartButton(),
                        const SizedBox(height: AppDimens.paddingLG),
                      ],
                    ),
                  ),
                ),
              ],
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
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          Expanded(
            child: Text(
              AppStrings.setupTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontLG,
                fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.all(AppDimens.paddingLG),
      child: Column(
        children: [
          Text(
            AppStrings.numberOfPlayers,
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontSM,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppDimens.paddingMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                icon: Icons.remove_rounded,
                onPressed: controller.decrementPlayers,
              ),
              const SizedBox(width: AppDimens.paddingLG),
              Obx(() => Text(
                    '${controller.playerCount.value}',
                    style: GoogleFonts.inter(
                      fontSize: AppDimens.fontDisplay,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  )),
              const SizedBox(width: AppDimens.paddingLG),
              _buildCounterButton(
                icon: Icons.add_rounded,
                onPressed: controller.incrementPlayers,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingXS),
          Text(
            '${SetupController.minPlayers}–${SetupController.maxPlayers} players',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontXS,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildPlayerNamesList() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Player Names',
            style: GoogleFonts.inter(
              fontSize: AppDimens.fontSM,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 1,
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
          PlayerAvatar(
            name: controller.controllers.length > index
                ? (controller.controllers[index].text.isNotEmpty
                    ? controller.controllers[index].text
                    : '${index + 1}')
                : '${index + 1}',
            size: 40,
          ),
          const SizedBox(width: AppDimens.paddingMD),
          Expanded(
            child: TextField(
              controller: controller.controllers[index],
              onChanged: (value) =>
                  controller.updatePlayerName(index, value),
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: AppDimens.fontMD,
              ),
              decoration: InputDecoration(
                hintText: 'Player ${index + 1}',
                suffixIcon: controller.playerCount.value >
                        SetupController.minPlayers
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppColors.textMuted),
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
          delay: Duration(milliseconds: 50 * index),
          duration: 300.ms,
        );
  }

  Widget _buildStartButton() {
    return GradientButton(
      text: AppStrings.startGame,
      icon: Icons.rocket_launch_rounded,
      onPressed: controller.startGame,
    ).animate().fadeIn(delay: 400.ms);
  }
}