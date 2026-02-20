import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class MusicService extends GetxService {
  late final AudioPlayer _player;
  final isMuted = false.obs;
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

  /// Start playing background music
  Future<void> play() async {
    if (isPlaying.value) return;
    try{
      await _player.setSource(AssetSource('background_music.mp3'));
      await _player.setVolume(1.0);
      await _player.resume();
      isPlaying.value = true;

     // fade in
     await _fadeIn();
    } catch (e) {
      isPlaying.value = false;
    }
  }

  Future<void> _fadeIn() async {
    if (isMuted.value) return;
    double vol = 0;
    while (vol < 1.0) {
      vol += 0.02;
      if (vol > 1.0) vol = 1.0;
      try {
        await _player.setVolume(vol);
      } catch (_) {
        // Safari may not support smooth volume changes
        await _player.setVolume(1.0);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  /// Toggle mute/unmute
  void toggleMute() {
    isMuted.value = !isMuted.value;
    if (isMuted.value) {
      _player.pause();
    } else {
      _player.resume();
    }
  }

  /// Fade out and stop — used when game starts
  Future<void> fadeOutAndStop() async {
    if (!isPlaying.value) return;

    if (isMuted.value) {
      await _player.stop();
      isPlaying.value = false;
      return;
    }

    double vol = 1.0;
    while (vol > 0) {
      vol -= 0.05;
      if (vol < 0) vol = 0;
      try {
        await _player.setVolume(vol);
      } catch (_) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await _player.stop();
    isPlaying.value = false;
  }

  /// Resume music (e.g. back to home)
  Future<void> resumeMusic() async {
    isPlaying.value = false;
    isMuted.value = false;
    try {
      await play();
    } catch (_) {
      // Silently handle Safari audio restrictions
    }
  }
}