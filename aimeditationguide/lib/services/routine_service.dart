import 'dart:math';
import '../models/breathing_card_model.dart';
// Мы не импортируем l10n сюда, так как сервис должен возвращать данные, 
// а локализацию мы применим в UI слое (Widget).

class RoutineService {
  static List<BasePracticeModel> generateDailyPlan() {
    // 1. Получаем все доступные карточки из библиотеки
    List<BasePracticeModel> all = PracticeLibrary.getAllCards();
    
    if (all.isEmpty) return [];

    // 2. Узнаем текущий час
    int hour = DateTime.now().hour;
    List<BasePracticeModel> filtered = [];

    // 3. Логика фильтрации (оставляем системные ID "Calm", "Focus", "Relax")
    // Это важно: логика подбора не должна зависеть от перевода текста.
    if (hour >= 5 && hour < 12) {
      // УТРО: Calm (Спокойствие) и Focus (Фокус)
      filtered = all.where((c) => c.mood == "Calm" || c.mood == "Focus").toList();
    } else if (hour >= 12 && hour < 18) {
      // ДЕНЬ: Focus (Фокус)
      filtered = all.where((c) => c.mood == "Focus").toList();
    } else {
      // ВЕЧЕР: Relax (Релакс) и Calm (Спокойствие)
      filtered = all.where((c) => c.mood == "Relax" || c.mood == "Calm").toList();
    }

    // 4. Перемешиваем список
    final random = Random();
    filtered.shuffle(random);

    // 5. Формируем финальный список из 3 практик
    List<BasePracticeModel> result = filtered.take(3).toList();
    
    // Если подходящих по настроению карточек мало, добираем из общего списка
    if (result.length < 3) {
      List<BasePracticeModel> backup = List.from(all)..shuffle(random);
      for (var card in backup) {
        // Проверяем по уникальному свойству (например, title или id), чтобы не дублировать
        if (!result.any((r) => r.title == card.title) && result.length < 3) {
          result.add(card);
        }
      }
    }

    return result;
  }
}