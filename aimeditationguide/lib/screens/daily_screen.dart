import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import '/controller/daily_routine_controller.dart';

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  late DailyRoutineController _logic;

  @override
  void initState() {
    super.initState();
    _logic = DailyRoutineController();
    _logic.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final double sw = (size.width / 375).clamp(0.8, 1.2);
    final double sh = (size.height / 812).clamp(0.8, 1.1);

    return Material(
      color: Colors.transparent,
      child: Container(
        height: size.height * 0.88,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Stack(
          children: [
            if (!_logic.isShowingResult) ..._buildTripleBackgroundBlur(sw, sh),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildHandle(),
                  const SizedBox(height: 8),
                  _buildHeader(context, sw, _logic.isShowingResult ? l10n.routine : l10n.dailyRoutine),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _logic.isShowingResult 
                        ? _buildRoutineList(sw, sh, l10n) 
                        : _buildWelcomeView(sw, sh, l10n),
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

  Widget _buildWelcomeView(double sw, double sh, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40 * sw),
      child: Column(
        key: const ValueKey(1),
        children: [
          const Spacer(flex: 2),
          Image.asset("assets/images/routine.png", height: 180 * sh, fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Icon(Icons.auto_awesome, size: 100 * sh, color: Colors.green[200])),
          const Spacer(),
          Text(
            l10n.routineWelcomeMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16 * sw, fontWeight: FontWeight.w500, height: 1.5, color: Colors.black),
          ),
          const Spacer(flex: 3),
          _buildActionButton(l10n.startSession, _logic.generateRoutine, sw, sh, active: true),
          SizedBox(height: 20 * sh),
        ],
      ),
    );
  }

  Widget _buildRoutineList(double sw, double sh, AppLocalizations l10n) {

    final List<String> slots = [
      l10n.morningPractice,
      l10n.afternoonPractice,
      l10n.eveningPractice
    ];

    return ListView(
      key: const ValueKey(2),
      padding: EdgeInsets.symmetric(horizontal: 24 * sw, vertical: 20 * sh),
      children: [
        for (int i = 0; i < _logic.recommendedCards.length; i++)
          _buildRoutineCard(i, slots[i], sw, sh, l10n),
        
        SizedBox(height: 40 * sh),
        _buildActionButton(
          _logic.allDone ? l10n.allCompleted : l10n.startNext, 
          () => _logic.runExercise(context, _logic.currentExerciseIndex), 
          sw, sh, 
          active: !_logic.allDone
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close, style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14 * sw)),
          ),
        ),
        SizedBox(height: 20 * sh),
      ],
    );
  }

  Widget _buildRoutineCard(int index, String timeSlot, double sw, double sh, AppLocalizations l10n) {
    if (_logic.recommendedCards.isEmpty) return const SizedBox.shrink();
    final model = _logic.recommendedCards[index];
    final bool isCompleted = _logic.completedStatuses[index];
    final bool isCurrent = _logic.currentExerciseIndex == index && !isCompleted;

    return GestureDetector(
      onTap: () => _logic.runExercise(context, index),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: (isCurrent || isCompleted) ? 1.0 : 0.5,
        child: Container(
          margin: EdgeInsets.only(bottom: 16 * sh),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isCurrent ? Border.all(color: model.color, width: 2) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 70 * sw, height: 70 * sh, 
                      color: model.color.withOpacity(0.1),
                      child: Image.asset(model.imagePath, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Icon(Icons.spa, color: model.color)),
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      width: 70 * sw, height: 70 * sh,
                      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.check_circle, color: Colors.white, size: 30),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timeSlot, style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12 * sw, color: Colors.black38)),
                    Text(model.getLocalizedTitle(context), style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16 * sw, color: Colors.black)),
                    Text(
                      model.mood, 
                      style: GoogleFonts.inter(fontSize: 11 * sw, fontWeight: FontWeight.w600, color: model.color)
                    ),
                  ],
                ),
              ),
              if (isCurrent) const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 30),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActionButton(String text, VoidCallback onTap, double sw, double sh, {bool active = false}) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        height: 60 * sh,
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(30 * sh),
        ),
        child: Row(
          children: [
            const Spacer(flex: 3),
            Text(text.toUpperCase(), style: GoogleFonts.inter(color: active ? Colors.white : Colors.black26, fontSize: 16 * sw, fontWeight: FontWeight.w800)),
            const Spacer(flex: 2),
            if (active)
            Container(
              margin: EdgeInsets.only(right: 6 * sw),
              width: 48 * sh, height: 48 * sh,
              decoration: const BoxDecoration(color: Color(0xFF2D2D2D), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательные методы
  Widget _buildHeader(BuildContext context, double sw, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20 * sw),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.close, color: Colors.black, size: 20)),
            ),
          ),
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 14 * sw, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildHandle() => Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)));

  List<Widget> _buildTripleBackgroundBlur(double sw, double sh) {
    return [
      _blurSpot(315 * sw, 180 * sh, 70 * sh, -70 * sw, 150),
      _blurSpot(235 * sw, 130 * sh, 100 * sh, 80 * sw, 100),
    ];
  }

  Widget _blurSpot(double w, double h, double top, double left, double blur) {
    return Positioned(
      top: top, left: left,
      child: Container(
        width: w, height: h,
        decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF77C97E).withOpacity(0.4)),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: Container(color: Colors.transparent)),
      ),
    );
  }
}