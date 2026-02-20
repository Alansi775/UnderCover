import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/constants.dart';
import '../../../core/services/music_service.dart';
import '../../../widgets/widgets.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/orb_widget.dart';
import '../widgets/ribbon_painter.dart';
import '../widgets/how_to_play_overlay.dart';
import 'home_welcome_overlay.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() => Stack(
            children: [
              // Ribbon background
              GetBuilder<HomeController>(
                builder: (_) => CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: RibbonPainter(
                    time: ctrl.elapsed,
                    centerY:
                        MediaQuery.of(context).size.height * 0.35,
                  ),
                ),
              ),
              // Mute button
              _buildMuteButton(context),
              // Main content
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppDimens.maxContentWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLG,
                      ),
                      child: Column(
                        children: [
                          const Spacer(flex: 3),
                          GetBuilder<HomeController>(
                            builder: (_) =>
                                OrbWidget(elapsed: ctrl.elapsed),
                          )
                              .animate()
                              .fadeIn(duration: 1500.ms)
                              .scale(
                                begin: const Offset(0.6, 0.6),
                                curve: Curves.easeOut,
                                duration: 1200.ms,
                              ),
                          const SizedBox(
                              height: AppDimens.paddingXXL),
                          _buildBrandName(),
                          const SizedBox(
                              height: AppDimens.paddingMD),
                          _buildTagline(),
                          const Spacer(flex: 4),
                          _buildButtons(ctrl),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Overlays
              if (ctrl.showHowToPlay.value)
                HowToPlayOverlay(
                    onClose: ctrl.toggleHowToPlay),
              if (ctrl.showWelcome.value)
                HomeWelcomeOverlay(
                    onEnter: ctrl.dismissWelcome),
            ],
          )),
    );
  }

  Widget _buildMuteButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 20,
      child: Obx(() {
        final music = Get.find<MusicService>();
        return GestureDetector(
          onTap: music.toggleMute,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.06),
              border: Border.all(
                  color: AppColors.white.withOpacity(0.08)),
            ),
            child: Icon(
              music.isMuted.value
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              size: 18,
              color: AppColors.gray400,
            ),
          ),
        );
      }),
    ).animate().fadeIn(delay: 2000.ms, duration: 500.ms);
  }

  Widget _buildBrandName() {
    return Text(
      'UNDERCOVER',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        letterSpacing: 10,
        height: 1,
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 800.ms)
        .blurXY(begin: 8, end: 0, delay: 600.ms, duration: 600.ms);
  }

  Widget _buildTagline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 24, height: 0.5, color: AppColors.gray800)
            .animate()
            .scaleX(begin: 0, delay: 1100.ms, duration: 500.ms),
        const SizedBox(width: AppDimens.paddingMD),
        Text(
          'UNMASK THE IMPOSTOR',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppColors.gray600,
            letterSpacing: 5,
          ),
        ).animate().fadeIn(delay: 1000.ms, duration: 700.ms),
        const SizedBox(width: AppDimens.paddingMD),
        Container(width: 24, height: 0.5, color: AppColors.gray800)
            .animate()
            .scaleX(begin: 0, delay: 1100.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildButtons(HomeController ctrl) {
    return Column(
      children: [
        GradientButton(
          text: 'New Game',
          icon: Icons.play_arrow_rounded,
          onPressed: () => Get.toNamed(Routes.setup),
        )
            .animate()
            .fadeIn(delay: 1400.ms, duration: 600.ms)
            .slideY(begin: 0.15)
            .then(delay: 1200.ms)
            .shimmer(
                duration: 2000.ms,
                color: AppColors.white.withOpacity(0.12)),
        const SizedBox(height: AppDimens.paddingMD),
        GradientButton(
          text: 'How to Play',
          icon: Icons.fingerprint_rounded,
          isOutlined: true,
          onPressed: ctrl.toggleHowToPlay,
        )
            .animate()
            .fadeIn(delay: 1600.ms, duration: 600.ms)
            .slideY(begin: 0.15),
      ],
    );
  }
}