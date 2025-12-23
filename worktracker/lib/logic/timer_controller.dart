import 'dart:async';
import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'notification_service.dart';

class TimerController extends ChangeNotifier {
  // Контроллеры для ввода времени пользователем
  final TextEditingController focusController = TextEditingController(text: "25");
  final TextEditingController breakController = TextEditingController(text: "5");

  int secondsLeft = 25 * 60; // Текущее время в секундах
  Timer? _timer;
  bool isRunning = false;
  bool isFocusMode = true;

  // Запуск или остановка таймера
  void toggleTimer() {
    if (isRunning) {
      _stopInternalTimer();
    } else {
      isRunning = true;
      _startInternalTimer();
    }
    notifyListeners();
  }

  // Внутренняя функция запуска тиков
  void _startInternalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        secondsLeft--;
        notifyListeners();
      } else {
        onTimerComplete();
      }
    });
  }

  void _stopInternalTimer() {
    _timer?.cancel();
    isRunning = false;
  }

  // Логика по завершении времени
  void onTimerComplete() async {
    // 1. Отправляем уведомление (без await, чтобы не ждать ответа системы)
    NotificationService.showNotification(
      title: isFocusMode ? "Время вышло!" : "Отдых окончен!",
      body: isFocusMode ? "Пора немного отдохнуть." : "Возвращаемся к задачам!",
    ).catchError((e) => debugPrint("Ошибка уведомлений: $e"));

    // 2. Сохраняем статистику, если это был рабочий сеанс
    if (isFocusMode) {
      try {
        int mins = int.tryParse(focusController.text) ?? 25;
        await StorageService.addFocusTime(mins);
      } catch (e) {
        debugPrint("Ошибка сохранения статистики: $e");
      }
    }

    // 3. АВТОМАТИЧЕСКАЯ СМЕНА РЕЖИМА
    isFocusMode = !isFocusMode;
    
    // Берем новые настройки времени
    int nextMins = isFocusMode 
        ? (int.tryParse(focusController.text) ?? 25) 
        : (int.tryParse(breakController.text) ?? 5);
    
    secondsLeft = nextMins * 60;

    // Важно: мы НЕ вызываем _stopInternalTimer(), 
    // поэтому цикл продолжается автоматически.
    notifyListeners();
  }

  // Вызывается при ручном изменении минут в текстовых полях
  void applyNewTime() {
    _stopInternalTimer();
    int mins = isFocusMode 
        ? (int.tryParse(focusController.text) ?? 25) 
        : (int.tryParse(breakController.text) ?? 5);
    secondsLeft = mins * 60;
    notifyListeners();
  }

  // Геттер для красивого отображения времени 00:00
  String get formatTime {
    final mins = (secondsLeft / 60).floor().toString().padLeft(2, '0');
    final secs = (secondsLeft % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    focusController.dispose();
    breakController.dispose();
    super.dispose();
  }
}