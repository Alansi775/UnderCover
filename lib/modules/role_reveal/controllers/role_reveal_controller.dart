import 'package:get/get.dart';
import '../../../core/services/game_controller.dart';
import '../../../data/models/player.dart';
import '../../../app/routes/app_routes.dart';

class RoleRevealController extends GetxController {
  late final GameController _gameCtrl;

  final currentIndex = 0.obs;
  final isRevealed = false.obs;
  final isPassPhoneMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    _gameCtrl = Get.find<GameController>();
  }

  List<Player> get players => _gameCtrl.allPlayers;
  Player get currentPlayer => players[currentIndex.value];
  bool get isLastPlayer => currentIndex.value >= players.length - 1;

  void revealRole() {
    isRevealed.value = true;
    isPassPhoneMode.value = false;
  }

  void hideRole() {
    isRevealed.value = false;
  }

  void nextPlayer() {
    if (isLastPlayer) {
      Get.offNamed(Routes.gameRound);
    } else {
      currentIndex.value++;
      isRevealed.value = false;
      isPassPhoneMode.value = true;
    }
  }

  void confirmAndNext() {
    hideRole();
    isPassPhoneMode.value = true;
    nextPlayer();
  }
}