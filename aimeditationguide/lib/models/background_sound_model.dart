import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class BackgroundSound {
  final String id;        // Системный ID (не меняется)
  final String path;      // Путь к файлу
  final String imagePath; // Путь к иконке

  BackgroundSound({
    required this.id,
    required this.path,
    required this.imagePath,
  });

  // Метод для получения переведенного названия
  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'none': return l10n.sound_none;
      case 'nature': return l10n.sound_nature;
      case 'ambient': return l10n.sound_ambient;
      case 'rain': return l10n.sound_rain;
      default: return id;
    }
  }
}

// Список звуков теперь использует константные ID
final List<BackgroundSound> backgroundSounds = [
  BackgroundSound(id: "none", path: "", imagePath: "none.png"),
  BackgroundSound(id: "nature", path: "nature.mp3", imagePath: "nature.png"),
  BackgroundSound(id: "ambient", path: "ambient.mp3", imagePath: "ambient.png"),
  BackgroundSound(id: "rain", path: "rain.mp3", imagePath: "rain.png"),
];