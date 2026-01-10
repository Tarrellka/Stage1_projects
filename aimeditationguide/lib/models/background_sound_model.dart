import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class BackgroundSound {
  final String id;      
  final String path;    
  final String imagePath; 

  BackgroundSound({
    required this.id,
    required this.path,
    required this.imagePath,
  });


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


final List<BackgroundSound> backgroundSounds = [
  BackgroundSound(id: "none", path: "", imagePath: "none.png"),
  BackgroundSound(id: "nature", path: "nature.mp3", imagePath: "nature.png"),
  BackgroundSound(id: "ambient", path: "ambient.mp3", imagePath: "ambient.png"),
  BackgroundSound(id: "rain", path: "rain.mp3", imagePath: "rain.png"),
];