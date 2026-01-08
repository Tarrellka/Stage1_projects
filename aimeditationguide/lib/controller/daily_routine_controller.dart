import 'package:flutter/material.dart';
import '../models/breathing_card_model.dart';
import '../screens/player_screen.dart';
import '../screens/breathing_screen.dart';
import '../services/routine_service.dart';

class DailyRoutineController extends ChangeNotifier {
  bool isShowingResult = false;
  List<BasePracticeModel> recommendedCards = [];
  int currentExerciseIndex = 0;
  List<bool> completedStatuses = [false, false, false];

  // ДОБАВЛЕНО: Поле для хранения последнего выполненного упражнения
  BasePracticeModel? lastCompletedExercise;

  static const String _defaultSoundId = "nature"; 

  void generateRoutine() {
    recommendedCards = RoutineService.generateDailyPlan();
    isShowingResult = true;
    currentExerciseIndex = 0;
    completedStatuses = [false, false, false];
    notifyListeners();
  }

  Future<void> runExercise(BuildContext context, int index) async {
    // Если index == -1, значит мы запускаем "последнее упражнение" с главного экрана
    final selectedModel = index == -1 ? lastCompletedExercise : recommendedCards[index];
    
    if (selectedModel == null) return;

    bool? isFinished;

    if (selectedModel is BreathingPracticeModel) {
      isFinished = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BreathingExerciseScreen(initialCard: selectedModel),
        ),
      );
    } else {
      isFinished = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerScreen(
            imageUrl: selectedModel.imagePath,
            title: selectedModel.titleKey, 
            durationString: selectedModel.durationMin.toString(),
            backgroundSound: selectedModel.backgroundSound.isNotEmpty 
                ? selectedModel.backgroundSound.toLowerCase() 
                : _defaultSoundId, 
          ),
        ),
      );
    }

    if (isFinished == true) {
      // СОХРАНЯЕМ: Теперь getter в HomeContentView найдет это поле
      lastCompletedExercise = selectedModel;
      
      if (index != -1) {
        completedStatuses[index] = true;
        if (index == currentExerciseIndex && currentExerciseIndex < recommendedCards.length - 1) {
          currentExerciseIndex++;
        }
      }
      notifyListeners();
    }
  }

  bool get allDone => !completedStatuses.contains(false) && recommendedCards.isNotEmpty;
}