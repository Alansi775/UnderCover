import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import 'game_service.dart';

class GameController extends GetxController {
  final GameService _gameService = GameService();
  final GameRepository _gameRepo = GameRepository();

  final Rx<GameSession?> session = Rx<GameSession?>(null);

  GameSession? get currentSession => session.value;

  void createGame(List<String> playerNames) {
    final newSession = _gameService.createGame(playerNames);
    session.value = newSession;
    _gameRepo.saveSession(newSession);
    _gameRepo.saveSessionToFirestore(newSession);
  }

  Player? processVotes(Map<String, String> votes) {
    if (currentSession == null) return null;
    final eliminated = _gameService.processVotes(currentSession!, votes);
    session.refresh();
    return eliminated;
  }

  GameResult checkWinCondition() {
    if (currentSession == null) return GameResult.ongoing;
    final result = _gameService.checkWinCondition(currentSession!);
    currentSession!.result = result;
    session.refresh();
    return result;
  }

  void advanceRound() {
    if (currentSession == null) return;
    _gameService.advanceRound(currentSession!);
    session.refresh();
  }

  void resetGame() {
    session.value = null;
    _gameRepo.clearSession();
  }

  List<Player> get alivePlayers => currentSession?.alivePlayers ?? [];

  List<Player> get allPlayers => currentSession?.players ?? [];

  int get currentRound => currentSession?.currentRound ?? 1;

  WordPair? get wordPair => currentSession?.wordPair;
}