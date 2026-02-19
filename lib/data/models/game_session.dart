import 'player.dart';
import 'word_pair.dart';

enum GameStatus { setup, roleReveal, playing, voting, elimination, finished }

enum GameResult { citizensWin, undercoverWins, ongoing }

class GameSession {
  final String id;
  final List<Player> players;
  final WordPair wordPair;
  int currentRound;
  int currentPlayerIndex;
  GameStatus status;
  GameResult result;
  final DateTime createdAt;

  GameSession({
    required this.id,
    required this.players,
    required this.wordPair,
    this.currentRound = 1,
    this.currentPlayerIndex = 0,
    this.status = GameStatus.setup,
    this.result = GameResult.ongoing,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  List<Player> get alivePlayers =>
      players.where((p) => p.isAlive).toList();

  Player? get undercoverPlayer =>
      players.where((p) => p.isUndercover).firstOrNull;

  bool get isUndercoverAlive =>
      undercoverPlayer != null && undercoverPlayer!.isAlive;

  Player? get currentPlayer {
    final alive = alivePlayers;
    if (currentPlayerIndex >= 0 && currentPlayerIndex < alive.length) {
      return alive[currentPlayerIndex];
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'players': players.map((p) => p.toJson()).toList(),
        'wordPair': wordPair.toJson(),
        'currentRound': currentRound,
        'status': status.name,
        'result': result.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        id: json['id'] as String,
        players: (json['players'] as List)
            .map((p) => Player.fromJson(p as Map<String, dynamic>))
            .toList(),
        wordPair:
            WordPair.fromJson(json['wordPair'] as Map<String, dynamic>),
        currentRound: json['currentRound'] as int? ?? 1,
        status: GameStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => GameStatus.setup,
        ),
        result: GameResult.values.firstWhere(
          (r) => r.name == json['result'],
          orElse: () => GameResult.ongoing,
        ),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}