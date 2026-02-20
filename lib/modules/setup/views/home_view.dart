import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../../core/constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../../app/routes/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  bool _showHowToPlay = false;
  late AnimationController _controller;
  double _elapsed = 0;

  @override
  void initState() {
    super.initState();
    // Single controller, we use raw elapsed time for non-repeating feel
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          // Accumulate time continuously — never resets
          _elapsed += 0.016; // ~60fps
        });
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _RibbonPainter(
              time: _elapsed,
              centerY: MediaQuery.of(context).size.height * 0.35,
            ),
          ),
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
                      _buildOrb(),
                      const SizedBox(height: AppDimens.paddingXXL),
                      _buildBrandName(),
                      const SizedBox(height: AppDimens.paddingMD),
                      _buildTagline(),
                      const Spacer(flex: 4),
                      _buildButtons(),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showHowToPlay) _buildHowToPlayOverlay(),
        ],
      ),
    );
  }

  Widget _buildOrb() {
    final float = math.sin(_elapsed * 0.4) * 4;

    return Transform.translate(
      offset: Offset(0, float),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.35),
            radius: 0.85,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.7),
              Colors.white.withOpacity(0.4),
              const Color(0xFFb0b0b0),
            ],
            stops: const [0.0, 0.25, 0.55, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 60,
              spreadRadius: 20,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.04),
              blurRadius: 100,
              spreadRadius: 40,
            ),
          ],
        ),
        child: ClipOval(
          child: CustomPaint(
            size: const Size(110, 110),
            painter: _SmokePainter(time: _elapsed),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 1500.ms)
        .scale(
          begin: const Offset(0.6, 0.6),
          curve: Curves.easeOut,
          duration: 1200.ms,
        );
  }

  Widget _buildBrandName() {
    return Text(
      'UNDERCOVER',
      style: GoogleFonts.inter(
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
          style: GoogleFonts.inter(
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

  Widget _buildButtons() {
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
          onPressed: () => setState(() => _showHowToPlay = true),
        )
            .animate()
            .fadeIn(delay: 1600.ms, duration: 600.ms)
            .slideY(begin: 0.15),
      ],
    );
  }

  Widget _buildHowToPlayOverlay() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showHowToPlay = false),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: AppColors.black.withOpacity(0.5)),
          ),
        ).animate().fadeIn(duration: 300.ms),
        Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(AppDimens.paddingLG),
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(AppDimens.paddingXL),
              decoration: BoxDecoration(
                color: const Color(0xFF0d0d0d).withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                    color: AppColors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.8),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('RULES',
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gray600,
                                  letterSpacing: 3)),
                          const SizedBox(height: 4),
                          Text('How to Play',
                              style: GoogleFonts.inter(
                                  fontSize: AppDimens.fontXL,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => setState(
                            () => _showHowToPlay = false),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                AppColors.white.withOpacity(0.06),
                          ),
                          child: const Icon(Icons.close_rounded,
                              size: 16,
                              color: AppColors.gray400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.paddingXL),
                  ..._steps.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimens.paddingMD),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.only(
                                  right: AppDimens.paddingMD),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8),
                                color: AppColors.white
                                    .withOpacity(0.04),
                                border: Border.all(
                                    color: AppColors.white
                                        .withOpacity(0.06)),
                              ),
                              child: Center(
                                child: Text('${e.key + 1}',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w700,
                                        color:
                                            AppColors.gray400)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4),
                                child: Text(e.value,
                                    style: GoogleFonts.inter(
                                        fontSize:
                                            AppDimens.fontSM,
                                        color:
                                            AppColors.gray400,
                                        height: 1.5)),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(
                              delay: (150 + e.key * 80).ms,
                              duration: 400.ms)
                          .slideX(
                              begin: 0.05,
                              delay: (150 + e.key * 80).ms,
                              duration: 400.ms)),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(
                    begin: const Offset(0.95, 0.95),
                    curve: Curves.easeOut,
                    duration: 300.ms),
          ),
        ),
      ],
    );
  }

  static const _steps = [
    'Add 3–12 players and start the game.',
    'Each player privately sees their role and word. One is the Undercover.',
    'Take turns describing your word without saying it.',
    'After each round, vote for who you think is the Undercover.',
    'Citizens win if Undercover is eliminated. Undercover wins if only 2 remain.',
  ];
}

/// Smoke painter — wispy dark smoke shadows drifting inside the orb
class _SmokePainter extends CustomPainter {
  final double time;
  _SmokePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Use irrational-ratio speeds so blobs never sync up
    final speeds = [0.13, 0.091, 0.077, 0.053, 0.117, 0.069];
    final sizes = [20.0, 16.0, 22.0, 14.0, 18.0, 12.0];
    final opacities = [0.2, 0.15, 0.12, 0.18, 0.1, 0.14];
    final orbits = [18.0, 14.0, 20.0, 12.0, 16.0, 10.0];
    final phases = [0.0, 1.3, 2.7, 4.1, 5.3, 0.8];

    for (int i = 0; i < speeds.length; i++) {
      final angle = time * speeds[i] * 2 * math.pi + phases[i];
      final bx = cx + math.cos(angle) * orbits[i];
      final by = cy + math.sin(angle * 0.7 + phases[i]) * orbits[i] * 0.8;

      // Elongated smoke blob
      final rect = Rect.fromCenter(
        center: Offset(bx, by),
        width: sizes[i] * 1.4,
        height: sizes[i],
      );

      final paint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(bx, by),
          sizes[i] * 0.9,
          [
            Colors.black.withOpacity(opacities[i]),
            Colors.black.withOpacity(opacities[i] * 0.4),
            Colors.black.withOpacity(opacities[i] * 0.1),
            Colors.transparent,
          ],
          [0.0, 0.3, 0.6, 1.0],
        );

      // Rotate each blob differently
      canvas.save();
      canvas.translate(bx, by);
      canvas.rotate(angle * 0.3);
      canvas.translate(-bx, -by);
      canvas.drawOval(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SmokePainter old) => true;
}

/// 3 flowing ribbon strands with irrational speeds
class _RibbonPainter extends CustomPainter {
  final double time;
  final double centerY;
  _RibbonPainter({required this.time, required this.centerY});

  @override
  void paint(Canvas canvas, Size size) {
    // 3 strands with different irrational-ratio speeds
    _paintStrand(canvas, size, 0.17, 0.0, 20, 0.065);
    _paintStrand(canvas, size, 0.11, 1.9, 14, 0.04);
    _paintStrand(canvas, size, 0.07, 3.7, 10, 0.022);
  }

  void _paintStrand(Canvas canvas, Size size, double speed,
      double phase, double thick, double opacity) {
    final t = time * speed * 2 * math.pi;
    final topPts = <Offset>[];
    final botPts = <Offset>[];

    for (double x = 0; x <= size.width; x += 3) {
      final nx = x / size.width;

      // Use prime-ish multipliers so waves don't sync
      final w1 = math.sin(nx * 3.7 + t + phase) * 30;
      final w2 = math.sin(nx * 6.3 + t * 1.3 + phase * 1.7) * 16;
      final w3 = math.cos(nx * 2.1 + t * 0.7 + phase * 2.3) * 10;

      // Twist near orb center
      final cd = (nx - 0.5);
      final twist =
          math.exp(-cd * cd * 10) * 22 * math.sin(t * 0.4 + phase);

      final y = centerY + w1 + w2 + w3 + twist;
      topPts.add(Offset(x, y - thick / 2));
      botPts.add(Offset(x, y + thick / 2));
    }

    final path = Path();
    path.moveTo(topPts.first.dx, topPts.first.dy);
    for (final p in topPts) {
      path.lineTo(p.dx, p.dy);
    }
    for (final p in botPts.reversed) {
      path.lineTo(p.dx, p.dy);
    }
    path.close();

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, centerY),
        Offset(size.width, centerY),
        [
          Colors.transparent,
          Colors.white.withOpacity(opacity * 0.3),
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.3),
          Colors.transparent,
        ],
        const [0.0, 0.1, 0.3, 0.7, 0.9, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter old) => true;
}