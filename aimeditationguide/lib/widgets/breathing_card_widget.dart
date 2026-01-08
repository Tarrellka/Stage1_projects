import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import '../models/breathing_card_model.dart';

class BreathingCardWidget extends StatelessWidget {
  final BasePracticeModel card;
  final VoidCallback onTap;
  final double sw;
  final double sh;

  const BreathingCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    required this.sw,
    required this.sh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160 * sw,
        margin: EdgeInsets.only(right: 12 * sw),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28 * sw),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Фоновое изображение
            Image.asset(
              card.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.blueGrey),
            ),
            
            // Затемнение
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Плашка типа практики
            Positioned(
              top: 12 * sh,
              left: 12 * sw,
              right: 12 * sw,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6 * sh),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.self_improvement, color: Colors.white, size: 16 * sw),
                        SizedBox(width: 4 * sw),
                        Text(
                          l10n.breathingLabel.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10 * sw,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Текст внизу (Длительность и Название)
            Positioned(
              bottom: 20 * sh,
              left: 16 * sw,
              right: 16 * sw, // Добавлено для предотвращения переполнения
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // ИСПОЛЬЗУЕМ МЕТОД МОДЕЛИ ДЛЯ ДЛИТЕЛЬНОСТИ
                    card.getLocalizedDuration(context).toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12 * sw,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // ИСПОЛЬЗУЕМ МЕТОД МОДЕЛИ ДЛЯ ЗАГОЛОВКА
                    card.getLocalizedTitle(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 18 * sw,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}