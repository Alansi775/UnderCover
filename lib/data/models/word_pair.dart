class WordPair {
  final String wordA;
  final String wordB;
  final String category;

  const WordPair({
    required this.wordA,
    required this.wordB,
    this.category = 'General',
  });

  Map<String, dynamic> toJson() => {
        'wordA': wordA,
        'wordB': wordB,
        'category': category,
      };

  factory WordPair.fromJson(Map<String, dynamic> json) => WordPair(
        wordA: json['wordA'] as String,
        wordB: json['wordB'] as String,
        category: json['category'] as String? ?? 'General',
      );

  @override
  String toString() => '$wordA / $wordB';
}