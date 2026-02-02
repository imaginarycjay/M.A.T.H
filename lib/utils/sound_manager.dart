import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// A singleton class to manage sound effects throughout the app.
/// Prevents memory leaks by reusing audio players.
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  static SoundManager get instance => _instance;

  SoundManager._internal();

  // Audio players for different sound types (low latency)
  AudioPlayer? _clickPlayer;
  AudioPlayer? _correctPlayer;
  AudioPlayer? _wrongPlayer;
  AudioPlayer? _levelCompletePlayer;

  bool _initialized = false;
  bool _soundEnabled = true;

  /// Sound effect types
  static const String click = 'click';
  static const String correct = 'correct';
  static const String wrong = 'wrong';
  static const String levelComplete = 'level_complete';

  /// Asset paths for sounds
  static const Map<String, String> _soundPaths = {
    click: 'assets/sounds/click.mp3',
    correct: 'assets/sounds/correct.mp3',
    wrong: 'assets/sounds/wrong.mp3',
    levelComplete: 'assets/sounds/level_complete.mp3',
  };

  /// Initialize the sound manager and preload sounds
  Future<void> init() async {
    if (_initialized) return;

    try {
      _clickPlayer = AudioPlayer(playerId: 'click');
      _correctPlayer = AudioPlayer(playerId: 'correct');
      _wrongPlayer = AudioPlayer(playerId: 'wrong');
      _levelCompletePlayer = AudioPlayer(playerId: 'level_complete');

      // Configure all players for low latency
      await Future.wait([
        _preparePlayer(_clickPlayer, click),
        _preparePlayer(_correctPlayer, correct),
        _preparePlayer(_wrongPlayer, wrong),
        _preparePlayer(_levelCompletePlayer, levelComplete),
      ]);

      _initialized = true;
    } catch (e) {
      _soundEnabled = false;
      debugPrint('Sound init failed: $e');
    }
  }

  Future<void> _preparePlayer(AudioPlayer? player, String soundType) async {
    if (player == null) return;
    final path = _soundPaths[soundType];
    if (path == null) return;

    // Configure player settings
    await player.setVolume(soundType == levelComplete ? 0.8 : 0.6);
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setPlayerMode(PlayerMode.lowLatency);

    // Preload the audio source for instant playback
    await player.setSourceAsset(path.replaceFirst('assets/', ''));
  }

  /// Set whether sound is enabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Check if sound is enabled
  bool get isSoundEnabled => _soundEnabled;

  /// Play a click/tap sound
  Future<void> playClick() async {
    await _playSound(click, _clickPlayer);
  }

  /// Play the correct answer sound
  Future<void> playCorrect() async {
    await _playSound(correct, _correctPlayer);
  }

  /// Play the wrong answer sound
  Future<void> playWrong() async {
    await _playSound(wrong, _wrongPlayer);
  }

  /// Play the level complete fanfare
  Future<void> playLevelComplete() async {
    await _playSound(levelComplete, _levelCompletePlayer);
  }

  /// Internal method to play a sound
  Future<void> _playSound(String soundType, AudioPlayer? player) async {
    if (!_soundEnabled || !_initialized || player == null) return;

    try {
      // Seek to start and resume for near-instant playback
      await player.seek(Duration.zero);
      await player.resume();
    } catch (e) {
      debugPrint('Sound playback error: $e');
    }
  }

  /// Dispose all audio players
  Future<void> dispose() async {
    await _clickPlayer?.dispose();
    await _correctPlayer?.dispose();
    await _wrongPlayer?.dispose();
    await _levelCompletePlayer?.dispose();
    _initialized = false;
  }
}
