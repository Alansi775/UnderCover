import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/music_service.dart';

class HomeController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController ticker;
  double elapsed = 0;
  final showHowToPlay = false.obs;
  final showWelcome = true.obs;

  @override
  void onInit() {
    super.onInit();
    ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick);
    ticker.repeat();
  }

  void _tick() {
    elapsed += 0.016;
    update();
  }

  void toggleHowToPlay() {
    showHowToPlay.value = !showHowToPlay.value;
  }

  void dismissWelcome() {
    Get.find<MusicService>().play();
    showWelcome.value = false;
  }

  @override
  void onClose() {
    ticker.dispose();
    super.onClose();
  }
}