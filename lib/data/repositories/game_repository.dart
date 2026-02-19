import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_session.dart';

class GameRepository {
  static const String _sessionKey = 'last_game_session';

  // ─── Local Storage ───
  Future<void> saveSession(GameSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  Future<GameSession?> loadLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_sessionKey);
    if (data == null) return null;
    try {
      return GameSession.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  // ─── Firebase Firestore ───
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveSessionToFirestore(GameSession session) async {
    await _firestore
        .collection('games')
        .doc(session.id)
        .set(session.toJson());
  }

  Future<GameSession?> loadSessionFromFirestore(String sessionId) async {
    final doc = await _firestore.collection('games').doc(sessionId).get();
    if (!doc.exists || doc.data() == null) return null;
    return GameSession.fromJson(doc.data()!);
  }

  Stream<GameSession?> watchSession(String sessionId) {
    return _firestore
        .collection('games')
        .doc(sessionId)
        .snapshots()
        .map((snap) =>
            snap.exists ? GameSession.fromJson(snap.data()!) : null);
  }
}