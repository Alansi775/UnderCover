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
    double vol = 0;
    final target = isMuted.value ? 0.0 : 1.0;
    while (vol < target) {
        vol += 0.02;
        if (vol > target) vol = target;
        await _player.setVolume(vol);
        await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  /// Toggle mute/unmute
  void toggleMute() {
    isMuted.value = !isMuted.value;
    if (isMuted.value) {
      _player.setVolume(0);
    } else {
      _player.setVolume(1.0);
    }
  }

  /// Fade out and stop — used when game starts
  Future<void> fadeOutAndStop() async {
    if (!isPlaying.value) return;

    // Fade from current volume to 0
    double vol = isMuted.value ? 0 : 1.0;
    while (vol > 0) {
      vol -= 0.05;
      if (vol < 0) vol = 0;
      await _player.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await _player.stop();
    isPlaying.value = false;
  }

  /// Resume music (e.g. back to home)
  Future<void> resumeMusic() async {
    isPlaying.value = false;
    isMuted.value = false;
    await play();
  }
}