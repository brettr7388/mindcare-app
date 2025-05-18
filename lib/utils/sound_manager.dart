import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isPlayingEffect = false;

  factory SoundManager() {
    return _instance;
  }

  SoundManager._internal();

  Future<void> _playSound(String soundPath) async {
    if (!_isMuted && !_isPlayingEffect) {
      try {
        _isPlayingEffect = true;
        await _audioPlayer.play(AssetSource(soundPath));
        // Wait for the sound to finish
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        print('Error playing sound $soundPath: $e');
      } finally {
        _isPlayingEffect = false;
      }
    }
  }

  Future<void> playButtonClick() async {
    await _playSound('sounds/click.mp3');
  }

  Future<void> playSuccess() async {
    await _playSound('sounds/success.mp3');
  }

  Future<void> playError() async {
    await _playSound('sounds/error.mp3');
  }

  Future<void> playGameOver() async {
    await _playSound('sounds/game_over.mp3');
  }

  Future<void> playJump() async {
    await _playSound('sounds/jump.mp3');
  }

  Future<void> playBubblePop() async {
    await _playSound('sounds/bubble_pop.mp3');
  }

  Future<void> playBubbleCreate() async {
    await _playSound('sounds/bubble_create.mp3');
  }

  Future<void> playColorMatch() async {
    await _playSound('sounds/color_match.mp3');
  }

  Future<void> playColorMismatch() async {
    await _playSound('sounds/color_mismatch.mp3');
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMuted) {
      try {
        await _backgroundMusicPlayer.play(AssetSource('sounds/relaxing_background.mp3'));
        await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
        // Set background music volume to 50% to not overpower effect sounds
        await _backgroundMusicPlayer.setVolume(0.5);
      } catch (e) {
        print('Error playing background music: $e');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.stop();
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _audioPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
} 