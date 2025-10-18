import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AlarmAudioController {
  AlarmAudioController._();
  static final AlarmAudioController instance = AlarmAudioController._();

  final AudioPlayer _player = AudioPlayer();
  String? _currentAsset;
  bool _isPlaying = false;

  Future<void> start(String assetPath) async {
    if (_currentAsset != assetPath || !_isPlaying) {
      try {
        _currentAsset = assetPath;
        await _player.setLoopMode(LoopMode.one);
        await _player.setAsset(assetPath);
        await _player.play();
        _isPlaying = true;
      } catch (e, stack) {
        debugPrint('AlarmAudioController.start error: $e\n$stack');
      }
    } else if (_player.playing == false) {
      await _player.play();
      _isPlaying = true;
    }
  }

  Future<void> stop() async {
    if (!_isPlaying) return;
    try {
      await _player.stop();
    } catch (e, stack) {
      debugPrint('AlarmAudioController.stop error: $e\n$stack');
    } finally {
      _isPlaying = false;
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
