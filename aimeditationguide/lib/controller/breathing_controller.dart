import 'dart:async';
import 'package:flutter/material.dart';
import '../models/breathing_card_model.dart';
import '/l10n/app_localizations.dart';

enum BreathingView { main, moodSelection, durationSelection, active, finished }

class BreathingController extends ChangeNotifier {
  BreathingView currentView = BreathingView.main;
  String? selectedMood;
  String? selectedDuration;
  late AnimationController animationController;
  
  Timer? _sessionTimer; // Таймер для автоматического завершения

  void init(TickerProvider vsync, BasePracticeModel? initialCard) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    );

    if (initialCard != null) {
      selectedMood = initialCard.mood;
      // Устанавливаем длительность из модели (например, "5 min")
      selectedDuration = "${initialCard.durationMin} min"; 
    }
  }

  // Вспомогательный метод для извлечения числа минут из строки "5 min"
  int _getDurationMinutes() {
    if (selectedDuration == null) return 1;
    // Берем первую часть строки до пробела и превращаем в число
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

  // ОСТАНОВКА ПОЛЬЗОВАТЕЛЕМ (кнопка "назад" или "закрыть")
  void stopSession() {
    _sessionTimer?.cancel();
    animationController.stop();
    currentView = BreathingView.main;
    notifyListeners();
  }

  // АВТОМАТИЧЕСКОЕ ЗАВЕРШЕНИЕ ПО ВРЕМЕНИ
  void finishSession() {
    _sessionTimer?.cancel();
    animationController.stop();
    currentView = BreathingView.finished;
    notifyListeners();
  }

  // Получение текста для UI (Вдох / Выдох)
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