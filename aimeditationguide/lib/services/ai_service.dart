import 'dart:math';
import '/l10n/app_localizations.dart';

class AISession {
  final String title;
  final String description;
  final String imageUrl;
  final String audioUrl;

  AISession({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.audioUrl,
  });
}

class AIService {
  static Future<AISession> generateMeditation({
    required String goal,
    required String duration,
    required String voice,
    required String sound,
    required AppLocalizations l10n, 
  }) async {

    await Future.delayed(const Duration(seconds: 4));

    final String promptId = Random().nextInt(10000).toString();
    

    final String imagePrompt = "serene_meditation_visual_${goal.replaceAll(' ', '_')}_style_cinematic_high_quality";
    final String generatedImage = "https://image.pollinations.ai/prompt/$imagePrompt?width=800&height=1200&seed=$promptId";


    return AISession(
      title: l10n.sessionTitle(goal),
      description: l10n.sessionDescription(voice, sound),
      imageUrl: generatedImage,
      audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    );
  }
}