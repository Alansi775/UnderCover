import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

class GameService {
  final WordPairRepository _wordPairRepo;
  final _uuid = const Uuid();
  final _random = Random();

  GameService({WordPairRepository? wordPairRepo})
      : _wordPairRepo = wordPairRepo ?? WordPairRepository();

  GameSession createGame(List<String> playerNames) {
    final wordPair = _wordPairRepo.getRandomPair();
    final players = playerNames
        .map((name) => Player(id: _uuid.v4(), name: name))
        .toList();

    _assignRoles(players, wordPair);

    return GameSession(
      id: _uuid.v4(),
      players: players,
      wordPair: wordPair,
      status: GameStatus.roleReveal,
    );
  }

  void _assignRoles(List<Player> players, WordPair wordPair) {
    // Pick a random player index to be the Undercover.
    final undercoverIndex = _random.nextInt(players.length);
    final citizensGetWordA = _random.nextBool();

    for (int i = 0; i < players.length; i++) {
      if (i == undercoverIndex) {
        players[i].role = PlayerRole.undercover;
        players[i].secretWord =
            citizensGetWordA ? wordPair.wordB : wordPair.wordA;
      } else {
        players[i].role = PlayerRole.citizen;
        players[i].secretWord =
            citizensGetWordA ? wordPair.wordA : wordPair.wordB;
      }
    }
  }

  Player? processVotes(GameSession session, Map<String, String> votes) {
    for (final player in session.alivePlayers) {
      player.resetVotes();
    }

    for (final votedForId in votes.values) {
      final target =
          session.players.where((p) => p.id == votedForId).firstOrNull;
      if (target != null) {
        target.votesReceived++;
      }
    }

    final alivePlayers = session.alivePlayers;
    if (alivePlayers.isEmpty) return null;

    final maxVotes = alivePlayers
        .map((p) => p.votesReceived)
        .reduce((a, b) => a > b ? a : b);

    final topVoted =
        alivePlayers.where((p) => p.votesReceived == maxVotes).toList();

    if (topVoted.length > 1) {
      return null;
    }

    final eliminated = topVoted.first;
    eliminated.isEliminated = true;
    return eliminated;
  }

  GameResult checkWinCondition(GameSession session) {
    final alive = session.alivePlayers;
    final undercover = session.undercoverPlayer;

    if (undercover != null && undercover.isEliminated) {
      return GameResult.citizensWin;
    }

    if (alive.length <= 2 && session.isUndercoverAlive) {
      return GameResult.undercoverWins;
    }

    return GameResult.ongoing;
  }

  void advanceRound(GameSession session) {
    session.currentRound++;
    session.currentPlayerIndex = 0;
    for (final player in session.alivePlayers) {
      player.resetVotes();
    }
  }
}