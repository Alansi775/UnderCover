import 'package:get/get.dart';
import '../../../core/services/game_controller.dart';
import '../../../data/models/models.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/music_service.dart';

class ResultController extends GetxController {
  late final GameController _gameCtrl;

  @override
  void onInit() {
    super.onInit();
    _gameCtrl = Get.find<GameController>();
  }

  GameResult get result =>
      _gameCtrl.currentSession?.result ?? GameResult.ongoing;
  bool get citizensWon => result == GameResult.citizensWin;

  Player? get undercoverPlayer =>
      _gameCtrl.currentSession?.undercoverPlayer;
  WordPair? get wordPair => _gameCtrl.wordPair;
  List<Player> get allPlayers => _gameCtrl.allPlayers;

  void playAgain() {
    _gameCtrl.resetGame();
    Get.offAllNamed(Routes.setup);
  }

  void backToMenu() {
    _gameCtrl.resetGame();
    Get.find<MusicService>().resumeMusic();
    Get.offAllNamed(Routes.home);
  }
}