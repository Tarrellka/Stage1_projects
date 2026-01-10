import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

abstract class BasePracticeModel {
  final String titleKey;    
  final int durationMin; 
  final String imagePath;
  final Color color;
  final String mood;        
  final String backgroundSound;

  String get title => titleKey; 
  String get duration => durationMin.toString();

  BasePracticeModel({
    required this.titleKey,
    required this.durationMin,
    required this.imagePath,
    required this.color,
    required this.mood,
    this.backgroundSound = "",
  });

  // --- МЕТОДЫ ДЛЯ UI ---


  String name(BuildContext context) => getLocalizedTitle(context);
  

  String durationText(BuildContext context) => getLocalizedDuration(context);

  String getLocalizedTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return titleKey;


    final map = {
      'calm_breath': l10n.calm_breath,
      'focus_breath': l10n.focus_breath,
      'relax_breath': l10n.relax_breath,
      'squareBreathing': l10n.squareBreathing,
      'boxBreathing': l10n.boxBreathing,
      'deepRelax': l10n.deepRelax,
    };

    return map[titleKey] ?? titleKey;
  }

  String getLocalizedDuration(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return "$durationMin min";


    String minutes = durationMin < 10 ? "0$durationMin" : "$durationMin";

    return "$minutes ${l10n.unit_min}";
  }
}

class BreathingPracticeModel extends BasePracticeModel {
  BreathingPracticeModel({
    required super.titleKey,
    required super.durationMin,
    required super.imagePath,
    required super.color,
    required super.mood,
  });
}

class PracticeLibrary {
  static List<BasePracticeModel> getAllCards() {
    return [
      BreathingPracticeModel(
        titleKey: "calm_breath",
        durationMin: 1,
        imagePath: "assets/images/breathing1.png",
        color: const Color(0xFF7ACBFF),
        mood: "Calm",
      ),
      BreathingPracticeModel(
        titleKey: "focus_breath",
        durationMin: 3,
        imagePath: "assets/images/breathing2.png",
        color: const Color(0xFFCBA7FF),
        mood: "Focus",
      ),
      BreathingPracticeModel(
        titleKey: "relax_breath",
        durationMin: 5,
        imagePath: "assets/images/breathing3.png",
        color: const Color(0xFF77C97E),
        mood: "Relax",
      ),
      BreathingPracticeModel(
        titleKey: "squareBreathing",
        durationMin: 4,
        imagePath: "assets/images/breathing2.png",
        color: const Color(0xFFFFB347),
        mood: "Focus",
      ),
      BreathingPracticeModel(
        titleKey: "deepRelax",
        durationMin: 10,
        imagePath: "assets/images/breathing3.png",
        color: const Color(0xFFB39DDB),
        mood: "Relax",
      ),
    ];
  }
}