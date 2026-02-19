import 'package:get/get.dart';
import '../../../core/services/game_controller.dart';
import '../../../data/models/player.dart';
import '../../../app/routes/app_routes.dart';

class GameRoundController extends GetxController {
  late final GameController _gameCtrl;

  final currentTurnIndex = 0.obs;
  final isDescribing = false.obs;
  final showPassPhone = true.obs;

  @override
  void onInit() {
    super.onInit();
    _gameCtrl = Get.find<GameController>();
  }

  List<Player> get alivePlayers => _gameCtrl.alivePlayers;
  int get roundNumber => _gameCtrl.currentRound;

  Player get currentPlayer {
    if (currentTurnIndex.value < alivePlayers.length) {
      return alivePlayers[currentTurnIndex.value];
    }
    return alivePlayers.first;
  }

  bool get isLastTurn => currentTurnIndex.value >= alivePlayers.length - 1;

  void startDescribing() {
    showPassPhone.value = false;
    isDescribing.value = true;
  }

  void finishTurn() {
    if (isLastTurn) {
      Get.offNamed(Routes.voting);
    } else {
      currentTurnIndex.value++;
      isDescribing.value = false;
      showPassPhone.value = true;
    }
  }
}