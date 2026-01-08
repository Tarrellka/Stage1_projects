import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '/l10n/app_localizations.dart'; 
import '../services/openai_generator.dart';

enum GeneratorView { main, goalSelection, durationSelection, voiceSelection, soundSelection, loading, finished }

class GeneratorController extends ChangeNotifier {
  GeneratorView currentView = GeneratorView.main;
  
  String? selectedGoal;
  String? selectedDuration;
  String? selectedVoice;
  String? selectedSound;

  String? aiImageUrl;
  String? aiTitle;
  Source? voiceSource;

  void setView(GeneratorView view) {
    currentView = view;
    notifyListeners();
  }

  void updateGoal(String val) { selectedGoal = val; currentView = GeneratorView.main; notifyListeners(); }
  void updateDuration(String val) { selectedDuration = val; currentView = GeneratorView.main; notifyListeners(); }
  void updateVoice(String val) { selectedVoice = val; currentView = GeneratorView.main; notifyListeners(); }
  void updateSound(String val) { selectedSound = val; currentView = GeneratorView.main; notifyListeners(); }

  Future<void> handleGenerate(BuildContext context) async {
    // Валидация перед отправкой
    if (!isReady) return;

    currentView = GeneratorView.loading;
    notifyListeners();
    
    final String languageCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    
    try {
      // Вызываем сервис, в котором уже настроены ретраи
      final result = await OpenAIGenerator.generateMeditation(
        goal: selectedGoal!, 
        duration: selectedDuration!, 
        voice: selectedVoice!, 
        languageCode: languageCode, 
        l10n: l10n,
      );

      aiTitle = result['title'];
      aiImageUrl = result['imageUrl'];
      voiceSource = result['voiceSource']; 
      
      currentView = GeneratorView.finished;
    } catch (e) {
      currentView = GeneratorView.main;
      debugPrint("Generation error: $e");
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${l10n.error}: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      notifyListeners();
    }
  }

  bool get isReady => selectedGoal != null && 
                      selectedDuration != null && 
                      selectedVoice != null && 
                      selectedSound != null;
}