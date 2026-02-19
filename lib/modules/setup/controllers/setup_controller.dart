import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/game_controller.dart';
import '../../../app/routes/app_routes.dart';

class SetupController extends GetxController {
  final playerCount = 3.obs;
  final playerNames = <String>[].obs;
  final controllers = <TextEditingController>[].obs;

  static const int minPlayers = 3;
  static const int maxPlayers = 12;

  @override
  void onInit() {
    super.onInit();
    _initializePlayerFields();
  }

  @override
  void onClose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.onClose();
  }

  void _initializePlayerFields() {
    controllers.clear();
    playerNames.clear();
    for (int i = 0; i < playerCount.value; i++) {
      controllers.add(TextEditingController());
      playerNames.add('');
    }
  }

  void incrementPlayers() {
    if (playerCount.value < maxPlayers) {
      playerCount.value++;
      controllers.add(TextEditingController());
      playerNames.add('');
    }
  }

  void decrementPlayers() {
    if (playerCount.value > minPlayers) {
      playerCount.value--;
      controllers.last.dispose();
      controllers.removeLast();
      playerNames.removeLast();
    }
  }

  void updatePlayerName(int index, String name) {
    if (index < playerNames.length) {
      playerNames[index] = name.trim();
    }
  }

  void removePlayer(int index) {
    if (playerCount.value > minPlayers) {
      playerCount.value--;
      controllers[index].dispose();
      controllers.removeAt(index);
      playerNames.removeAt(index);
    }
  }

  String? validateNames() {
    final names = playerNames.where((n) => n.trim().isNotEmpty).toList();
    if (names.length < playerCount.value) {
      return 'All players must have names';
    }
    if (names.toSet().length != names.length) {
      return 'Player names must be unique';
    }
    return null;
  }

  void startGame() {
    for (int i = 0; i < controllers.length; i++) {
      playerNames[i] = controllers[i].text.trim();
    }

    final error = validateNames();
    if (error != null) {
      Get.snackbar(
        'Oops',
        error,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (!Get.isRegistered<GameController>()) {
      Get.put(GameController(), permanent: true);
    }
    final gameCtrl = Get.find<GameController>();
    gameCtrl.createGame(playerNames.toList());

    Get.offNamed(Routes.roleReveal);
  }
}