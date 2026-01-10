import 'dart:async';
import 'package:flutter/material.dart';
import '../models/breathing_card_model.dart';
import '/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum BreathingView { main, moodSelection, durationSelection, active, finished }

class BreathingController extends ChangeNotifier {
  BreathingView currentView = BreathingView.main;
  String? selectedMood;
  String? selectedDuration;
  late AnimationController animationController;
  
  Timer? _sessionTimer;

  void init(TickerProvider vsync, BasePracticeModel? initialCard) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    );

    if (initialCard != null) {
      selectedMood = initialCard.mood;

      selectedDuration = "${initialCard.durationMin} min"; 
    }
  }


  int _getDurationMinutes() {
    if (selectedDuration == null) return 1;
    return int.tryParse(selectedDuration!.split(' ')[0]) ?? 1;
  }

  void setView(BreathingView view) {
    currentView = view;
    if (view != BreathingView.active) {
      _sessionTimer?.cancel();
      animationController.stop();
    }
    notifyListeners();
  }

  void updateMood(String mood) {
    selectedMood = mood;
    currentView = BreathingView.main;
    notifyListeners();
  }

  void updateDuration(String duration) {
    selectedDuration = duration;
    currentView = BreathingView.main;
    notifyListeners();
  }

  // ЗАПУСК СЕССИИ
  void startBreathingSession() {
    currentView = BreathingView.active;
    
    // 1. Запускаем анимацию кругов (вдох-выдох)
    animationController.repeat(reverse: true);
    
    // 2. Сбрасываем старый таймер, если он был
    _sessionTimer?.cancel();
    
    // 3. Запускаем новый таймер на выбранное количество минут
    _sessionTimer = Timer(Duration(minutes: _getDurationMinutes()), () {
      finishSession();
    });
    
    notifyListeners();
  }

  // ОСТАНОВКА ПОЛЬЗОВАТЕЛЕМ 
  void stopSession() {
    _sessionTimer?.cancel();
    animationController.stop();
    currentView = BreathingView.main;
    notifyListeners();
  }

  // АВТОМАТИЧЕСКОЕ ЗАВЕРШЕНИЕ ПО ВРЕМЕНИ
  Future<void> finishSession() async {
    _sessionTimer?.cancel();
    animationController.stop();
    currentView = BreathingView.finished;
    
    // СОХРАНЕНИЕ В FIREBASE
    await _saveToFirebase();
    
    notifyListeners();
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('meditation_history').add({
        'userId': user.uid,
        'type': 'breathing',
        'title': selectedMood ?? 'Breathing Practice',
        'duration': selectedDuration,
        'date': FieldValue.serverTimestamp(),
        'mood': selectedMood,
      });
    } catch (e) {
      debugPrint("Error saving breathing session: $e");
    }
  }

  String getBreathingStatus(AppLocalizations l10n) {
    if (currentView != BreathingView.active) return "";
    
    if (animationController.status == AnimationStatus.forward) {
      return l10n.inhale;
    } else {
      return l10n.exhale;
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    animationController.dispose();
    super.dispose();
  }
}