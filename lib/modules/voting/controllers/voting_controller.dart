import 'package:get/get.dart';
import '../../../core/services/game_controller.dart';
import '../../../data/models/models.dart';
import '../../../app/routes/app_routes.dart';

class VotingController extends GetxController {
  late final GameController _gameCtrl;

  final currentVoterIndex = 0.obs;
  final selectedPlayerId = ''.obs;
  final votes = <String, String>{}.obs;
  final showPassPhone = true.obs;
  final eliminatedPlayer = Rx<Player?>(null);
  final isTie = false.obs;

  @override
  void onInit() {
    super.onInit();
    _gameCtrl = Get.find<GameController>();
  }

  List<Player> get alivePlayers => _gameCtrl.alivePlayers;

  Player get currentVoter {
    if (currentVoterIndex.value < alivePlayers.length) {
      return alivePlayers[currentVoterIndex.value];
    }
    return alivePlayers.first;
  }

  bool get isLastVoter =>
      currentVoterIndex.value >= alivePlayers.length - 1;

  List<Player> get votablePlayersForCurrentVoter {
    return alivePlayers
        .where((p) => p.id != currentVoter.id)
        .toList();
  }

  void selectPlayer(String playerId) {
    selectedPlayerId.value = playerId;
  }

  void startVoting() {
    showPassPhone.value = false;
  }

  void confirmVote() {
    if (selectedPlayerId.value.isEmpty) return;

    votes[currentVoter.id] = selectedPlayerId.value;

    if (isLastVoter) {
      _processResults();
    } else {
      currentVoterIndex.value++;
      selectedPlayerId.value = '';
      showPassPhone.value = true;
    }
  }

  void _processResults() {
    final eliminated = _gameCtrl.processVotes(votes);
    eliminatedPlayer.value = eliminated;
    isTie.value = eliminated == null;

    Get.offNamed(Routes.elimination);
  }

  void continueAfterElimination() {
    final result = _gameCtrl.checkWinCondition();

    if (result != GameResult.ongoing) {
      Get.offNamed(Routes.result);
    } else {
      _gameCtrl.advanceRound();
      Get.offNamed(Routes.gameRound);
    }
  }
}