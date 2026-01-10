import 'dart:math';
import '../models/breathing_card_model.dart';


class RoutineService {
  static List<BasePracticeModel> generateDailyPlan() {

    List<BasePracticeModel> all = PracticeLibrary.getAllCards();
    
    if (all.isEmpty) return [];


    int hour = DateTime.now().hour;
    List<BasePracticeModel> filtered = [];


    if (hour >= 5 && hour < 12) {

      filtered = all.where((c) => c.mood == "Calm" || c.mood == "Focus").toList();
    } else if (hour >= 12 && hour < 18) {

      filtered = all.where((c) => c.mood == "Focus").toList();
    } else {

      filtered = all.where((c) => c.mood == "Relax" || c.mood == "Calm").toList();
    }


    final random = Random();
    filtered.shuffle(random);


    List<BasePracticeModel> result = filtered.take(3).toList();
    

    if (result.length < 3) {
      List<BasePracticeModel> backup = List.from(all)..shuffle(random);
      for (var card in backup) {
        if (!result.any((r) => r.title == card.title) && result.length < 3) {
          result.add(card);
        }
      }
    }

    return result;
  }
}