import 'package:flutter/material.dart';
import '../models/breathing_card_model.dart';
import '../services/routine_service.dart';

class HomeController extends ChangeNotifier {
  int currentIndex = 0;
  List<BasePracticeModel> recommendedCards = [];

  void setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void loadRecommendations() {
    final rawPlan = RoutineService.generateDailyPlan();
    final seenTitles = <String>{};
    recommendedCards = rawPlan.where((card) => seenTitles.add(card.title)).toList();
    notifyListeners();
  }

  bool isMorning() {
    final hour = DateTime.now().hour;
    return hour >= 5 && hour < 18;
  }
}