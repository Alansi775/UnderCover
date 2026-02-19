import 'dart:math';
import '../models/word_pair.dart';

class WordPairRepository {
  static final WordPairRepository _instance = WordPairRepository._internal();
  factory WordPairRepository() => _instance;
  WordPairRepository._internal();

  final _random = Random();

  static const List<WordPair> _wordPairs = [
    // Animals
    WordPair(wordA: 'Cat', wordB: 'Tiger', category: 'Animals'),
    WordPair(wordA: 'Dog', wordB: 'Wolf', category: 'Animals'),
    WordPair(wordA: 'Dolphin', wordB: 'Shark', category: 'Animals'),
    WordPair(wordA: 'Butterfly', wordB: 'Moth', category: 'Animals'),
    WordPair(wordA: 'Frog', wordB: 'Toad', category: 'Animals'),
    WordPair(wordA: 'Rabbit', wordB: 'Hare', category: 'Animals'),
    WordPair(wordA: 'Alligator', wordB: 'Crocodile', category: 'Animals'),

    // Food & Drinks
    WordPair(wordA: 'Coffee', wordB: 'Tea', category: 'Food & Drinks'),
    WordPair(wordA: 'Butter', wordB: 'Margarine', category: 'Food & Drinks'),
    WordPair(wordA: 'Pizza', wordB: 'Flatbread', category: 'Food & Drinks'),
    WordPair(wordA: 'Ice Cream', wordB: 'Gelato', category: 'Food & Drinks'),
    WordPair(wordA: 'Sushi', wordB: 'Sashimi', category: 'Food & Drinks'),
    WordPair(wordA: 'Pancake', wordB: 'Waffle', category: 'Food & Drinks'),
    WordPair(wordA: 'Ketchup', wordB: 'Tomato Sauce', category: 'Food & Drinks'),

    // Transport
    WordPair(wordA: 'Ship', wordB: 'Boat', category: 'Transport'),
    WordPair(wordA: 'Car', wordB: 'Taxi', category: 'Transport'),
    WordPair(wordA: 'Train', wordB: 'Metro', category: 'Transport'),
    WordPair(wordA: 'Bicycle', wordB: 'Motorcycle', category: 'Transport'),
    WordPair(wordA: 'Airplane', wordB: 'Helicopter', category: 'Transport'),

    // Places
    WordPair(wordA: 'Beach', wordB: 'Desert', category: 'Places'),
    WordPair(wordA: 'Library', wordB: 'Bookstore', category: 'Places'),
    WordPair(wordA: 'Hospital', wordB: 'Clinic', category: 'Places'),
    WordPair(wordA: 'Museum', wordB: 'Gallery', category: 'Places'),
    WordPair(wordA: 'Mountain', wordB: 'Hill', category: 'Places'),

    // Objects
    WordPair(wordA: 'Pen', wordB: 'Pencil', category: 'Objects'),
    WordPair(wordA: 'Watch', wordB: 'Clock', category: 'Objects'),
    WordPair(wordA: 'Sofa', wordB: 'Chair', category: 'Objects'),
    WordPair(wordA: 'Mirror', wordB: 'Window', category: 'Objects'),
    WordPair(wordA: 'Pillow', wordB: 'Cushion', category: 'Objects'),

    // Concepts
    WordPair(wordA: 'Dream', wordB: 'Nightmare', category: 'Concepts'),
    WordPair(wordA: 'King', wordB: 'Emperor', category: 'Concepts'),
    WordPair(wordA: 'Movie', wordB: 'TV Show', category: 'Concepts'),
    WordPair(wordA: 'Song', wordB: 'Poem', category: 'Concepts'),
    WordPair(wordA: 'Photo', wordB: 'Painting', category: 'Concepts'),
  ];

  List<WordPair> get allPairs => List.unmodifiable(_wordPairs);

  WordPair getRandomPair() {
    return _wordPairs[_random.nextInt(_wordPairs.length)];
  }

  WordPair getRandomPairExcluding(List<String> excludeCategories) {
    final filtered = _wordPairs
        .where((p) => !excludeCategories.contains(p.category))
        .toList();
    if (filtered.isEmpty) return getRandomPair();
    return filtered[_random.nextInt(filtered.length)];
  }

  List<String> get categories =>
      _wordPairs.map((p) => p.category).toSet().toList();
}