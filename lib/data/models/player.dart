enum PlayerRole { citizen, undercover }

class Player {
  final String id;
  final String name;
  PlayerRole role;
  String secretWord;
  bool isEliminated;
  int votesReceived;

  Player({
    required this.id,
    required this.name,
    this.role = PlayerRole.citizen,
    this.secretWord = '',
    this.isEliminated = false,
    this.votesReceived = 0,
  });

  bool get isUndercover => role == PlayerRole.undercover;
  bool get isAlive => !isEliminated;

  void resetVotes() => votesReceived = 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'secretWord': secretWord,
        'isEliminated': isEliminated,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        role: json['role'] == 'undercover'
            ? PlayerRole.undercover
            : PlayerRole.citizen,
        secretWord: json['secretWord'] as String? ?? '',
        isEliminated: json['isEliminated'] as bool? ?? false,
      );

  @override
  String toString() => 'Player($name, $role)';
}