import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerController extends ChangeNotifier {
  final String initialBackgroundSound; 
  final Source? voiceSource;
  final String title;
  final String imageUrl;

  PlayerController({
    required this.initialBackgroundSound,
    required this.voiceSource,
    required this.title,
    required this.imageUrl,
    required int initialTotalSeconds,
  }) {
    _totalSeconds = initialTotalSeconds;
    _selectedSoundId = initialBackgroundSound.toLowerCase();
    _init();
  }

  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _voicePlayer;
  
  int _totalSeconds = 0;
  int _elapsedSeconds = 0;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _isFavorite = false;
  String _selectedSoundId = "none"; 
  double _backgroundVolume = 0.4;
  Timer? _manualTimer;

  // Геттеры
  int get totalSeconds => _totalSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get isFavorite => _isFavorite;
  String get selectedSoundId => _selectedSoundId;
  double get backgroundVolume => _backgroundVolume;

  void _init() async {
    _backgroundPlayer = AudioPlayer();
    _voicePlayer = AudioPlayer();

    _voicePlayer.onPositionChanged.listen((p) {
      if (voiceSource != null) {
        _elapsedSeconds = p.inSeconds;
        notifyListeners();
      }
    });

    _voicePlayer.onDurationChanged.listen((d) {
      if (voiceSource != null) {
        _totalSeconds = d.inSeconds;
        notifyListeners();
      }
    });

    _voicePlayer.onPlayerComplete.listen((event) => stopAll());

    try {
      await updateBackgroundAudio();
      if (voiceSource != null) {
        await _voicePlayer.setSource(voiceSource!);
      }
      _isLoading = false;
      notifyListeners();
      togglePlay();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBackgroundAudio() async {
    if (_selectedSoundId == 'none') {
      await _backgroundPlayer.stop();
      return;
    }
    

    String fileName = _selectedSoundId.contains('rain') ? 'rain.mp3' : 'nature.mp3';
    
    await _backgroundPlayer.setSource(AssetSource('audio/$fileName'));
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(_backgroundVolume);
  }

  void togglePlay() async {
    if (_isPlaying) {
      await _backgroundPlayer.pause();
      await _voicePlayer.pause();
      _manualTimer?.cancel();
    } else {
      if (_selectedSoundId != 'none') await _backgroundPlayer.resume();
      if (voiceSource != null) {
        await _voicePlayer.resume();
      } else {
        _startManualTimer();
      }
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void _startManualTimer() {
    _manualTimer?.cancel();
    _manualTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && _elapsedSeconds < _totalSeconds) {
        _elapsedSeconds++;
        notifyListeners();
      } else if (_elapsedSeconds >= _totalSeconds) {
        stopAll();
      }
    });
  }

  void stopAll() {
    _manualTimer?.cancel();
    _isPlaying = false;
    _backgroundPlayer.stop();
    _voicePlayer.stop();
    notifyListeners();
  }

  void seekTo(int seconds) {
    if (voiceSource != null) {
      _voicePlayer.seek(Duration(seconds: seconds));
    } else {
      _elapsedSeconds = seconds;
    }
    if (_selectedSoundId != 'none') {
      _backgroundPlayer.seek(Duration(seconds: seconds % 30));
    }
    notifyListeners();
  }

  void setBackgroundVolume(double v) {
    _backgroundVolume = v;
    _backgroundPlayer.setVolume(v);
    notifyListeners();
  }

  void selectSound(String soundId) async {
    _selectedSoundId = soundId.toLowerCase();
    await updateBackgroundAudio();
    if (_isPlaying && _selectedSoundId != 'none') {
      _backgroundPlayer.resume();
    }
    notifyListeners();
  }

  Future<bool> addToHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('meditation_history') ?? [];
    Map<String, String> newItem = {
      'title': title,
      'image': imageUrl,
      'date': DateTime.now().toIso8601String(),
    };
    String encodedItem = jsonEncode(newItem);
    if (!history.contains(encodedItem)) {
      history.insert(0, encodedItem);
      await prefs.setStringList('meditation_history', history);
      _isFavorite = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _manualTimer?.cancel();
    _backgroundPlayer.dispose();
    _voicePlayer.dispose();
    super.dispose();
  }
}