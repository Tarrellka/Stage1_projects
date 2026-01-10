import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import '/controller/breathing_controller.dart';
import '../widgets/painter.dart';
import '../widgets/selector.dart';
import '../models/breathing_card_model.dart';
import '../widgets/breathing_card_widget.dart';
import '../services/routine_service.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final BasePracticeModel? initialCard;

  const BreathingExerciseScreen({super.key, this.initialCard});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late BreathingController _logic;
  late Animation<double> _breathAnimation;
  final List<BasePracticeModel> _recommendations = RoutineService.generateDailyPlan();

  @override
  void initState() {
    super.initState();
    _logic = BreathingController();
    _logic.init(this, widget.initialCard);

    _logic.addListener(() {
      if (mounted) setState(() {});
    });

    _breathAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logic.animationController, curve: Curves.easeInOut),
    );
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

    return Container(
      height: size.height * 0.88,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F9FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Stack(
        children: [
          _buildBackgroundBlur(sw, sh),
          SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(context, sw, sh, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, double sw, double sh, AppLocalizations l10n) {
    switch (_logic.currentView) {
      case BreathingView.moodSelection:
        return UniversalSelector(
          key: const ValueKey("mood"),
          title: l10n.moodCheckIn,
          items: [l10n.goalFocus, l10n.goalSleep, l10n.goalStress, l10n.goalAnxiety],
          sw: sw,
          onBack: () => _logic.setView(BreathingView.main),
          onSelect: (val) => _logic.updateMood(val),
        );
      case BreathingView.durationSelection:
        return UniversalSelector(
          key: const ValueKey("duration_b"),
          title: l10n.duration,
          items: [l10n.minutesDuration("1"), l10n.minutesDuration("3"), l10n.minutesDuration("5")],
          sw: sw,
          onBack: () => _logic.setView(BreathingView.main),
          onSelect: (val) => _logic.updateDuration(val),
        );
      case BreathingView.active:
        return _buildActiveView(sw, sh, l10n);
      case BreathingView.finished:
        return _buildFinishedView(sw, sh, l10n);
      default:
        return _buildMainView(context, sw, sh, l10n);
    }
  }

  // --- АКТИВНЫЙ ЭКРАН С ПУЛЬСАЦИЕЙ ---
  Widget _buildActiveView(double sw, double sh, AppLocalizations l10n) {
    final activeColor = widget.initialCard?.color ?? const Color(0xFF7ACBFF);
    return Stack(
      key: const ValueKey("active_b"),
      children: [
        Column(
          children: [
            const SizedBox(height: 12),
            _buildHandle(),
            const SizedBox(height: 20),
            _buildHeader(context, sw, l10n.breathingExercise.toUpperCase(), isClose: true, customPop: () => _logic.setView(BreathingView.main)),
            const Spacer(),
            AnimatedBuilder(
              animation: _breathAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _breathAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _staticLayer(280 * sw, 0.15, activeColor),
                      _staticLayer(230 * sw, 0.3, activeColor),
                      _staticLayer(180 * sw, 1.0, activeColor),
                      // Текст внутри круга 
                      Transform.scale(
                        scale: 1 / _breathAnimation.value,
                        child: Text(
                          _logic.getBreathingStatus(l10n).toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 22 * sw, color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
        // Кнопки управления внизу
        Positioned(
          left: 40 * sw,
          bottom: 40 * sh,
          child: _smallGreyButton(Icons.close, () => _logic.setView(BreathingView.main)),
        ),
        Positioned(
          right: 40 * sw,
          bottom: 40 * sh,
          child: _smallGreyButton(Icons.refresh, () {
            _logic.animationController.reset();
            _logic.startBreathingSession();
          }),
        ),
      ],
    );
  }

  Widget _smallGreyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)
        ]),
        child: Icon(icon, color: Colors.black54, size: 24),
      ),
    );
  }

  Widget _staticLayer(double size, double opacity, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity.clamp(0.0, 1.0))),
      );

  // --- ГЛАВНЫЙ ЭКРАН ВЫБОРА ---
  Widget _buildMainView(BuildContext context, double sw, double sh, AppLocalizations l10n) {
    return Stack(
      key: const ValueKey("main_b"),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * sw),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildHandle(),
              const SizedBox(height: 40),
              _buildTopVisual(sw, sh),
              Expanded(child: _buildForm(context, sw, sh, l10n)),
            ],
          ),
        ),
        Positioned(top: 26, left: 0, right: 0, child: _buildHeader(context, sw, l10n.breathingExercise.toUpperCase(), isClose: true)),
      ],
    );
  }

  // --- ЭКРАН ЗАВЕРШЕНИЯ ---
  Widget _buildFinishedView(double sw, double sh, AppLocalizations l10n) {
    return Stack(
      key: const ValueKey("finished_b"),
      children: [
        Column(
          children: [
            const SizedBox(height: 12),
            _buildHandle(),
            const SizedBox(height: 20),
            _buildHeader(context, sw, l10n.breathingExercise.toUpperCase(), isClose: true, customPop: () => _logic.setView(BreathingView.main)),
            const SizedBox(height: 30),
            Image.asset("assets/images/breathing.png", height: 140 * sh, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.air, size: 80, color: Colors.blue)),
            const SizedBox(height: 24),
            Text(l10n.congrats.toUpperCase(), style: GoogleFonts.inter(fontSize: 32 * sw, fontWeight: FontWeight.w800, color: Colors.black)),
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * sw),
              child: Align(alignment: Alignment.centerLeft, child: Text(l10n.recommendedSessions, style: GoogleFonts.inter(fontSize: 16 * sw, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200 * sh,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16 * sw),
                scrollDirection: Axis.horizontal,
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  final card = _recommendations[index];
                  return BreathingCardWidget(
                    card: card,
                    sw: sw,
                    sh: sh,
                    onTap: () {
                      _logic.selectedMood = card.mood;
                      _logic.selectedDuration = card.durationText(context);
                      _logic.setView(BreathingView.main);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopVisual(double sw, double sh) {
    return SizedBox(
      height: 340 * sh,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, -10 * sh),
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(
                size: const Size(300, 300),
                painter: BreathingSilhouettePainter(color: const Color(0xFF7ACBFF), strokeWidth: 8.0),
              ),
            ),
          ),
          Image.asset("assets/images/breathing.png", height: 160 * sh, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.air, size: 80, color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, double sw, double sh, AppLocalizations l10n) {
    bool isReady = _logic.selectedMood != null && _logic.selectedDuration != null;
    return Column(
      children: [
        const Spacer(flex: 1),
        Text(l10n.howAreYouFeelingShort, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 18 * sw, fontWeight: FontWeight.w700, color: Colors.black)),
        SizedBox(height: 15 * sh),
        _optionRowCustom(
          customIcon: CustomPaint(size: const Size(20, 20), painter: ArcherTargetPainter(color: _logic.selectedMood != null ? Colors.white : Colors.grey[400]!)),
          label: l10n.moodCheckIn,
          value: _logic.selectedMood,
          onTap: () => _logic.setView(BreathingView.moodSelection),
          sw: sw,
          sh: sh,
        ),
        _optionRow(Icons.timer_outlined, l10n.duration, _logic.selectedDuration, () => _logic.setView(BreathingView.durationSelection), sw, sh),
        const Spacer(flex: 3),
        _buildStartButton(sw, sh, l10n, active: isReady, onTap: isReady ? _logic.startBreathingSession : null),
        SizedBox(height: 20 * sh),
      ],
    );
  }

  Widget _optionRowCustom({required Widget customIcon, required String label, String? value, required VoidCallback onTap, required double sw, required double sh}) {
    bool hasVal = value != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6 * sh),
        padding: EdgeInsets.symmetric(horizontal: 16 * sw, vertical: 14 * sh),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20 * sw)),
        child: Row(children: [
          Container(width: 36 * sw, height: 36 * sw, decoration: BoxDecoration(color: hasVal ? Colors.black : Colors.grey[100], shape: BoxShape.circle), child: Center(child: customIcon)),
          SizedBox(width: 12 * sw),
          Expanded(child: Text(hasVal ? value! : label, style: GoogleFonts.inter(fontSize: 15 * sw, fontWeight: FontWeight.w600, color: hasVal ? Colors.black : Colors.black54))),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ]),
      ),
    );
  }

  Widget _optionRow(IconData icon, String label, String? value, VoidCallback onTap, double sw, double sh) {
    bool hasVal = value != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6 * sh),
        padding: EdgeInsets.symmetric(horizontal: 16 * sw, vertical: 14 * sh),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20 * sw)),
        child: Row(children: [
          Container(width: 36 * sw, height: 36 * sw, decoration: BoxDecoration(color: hasVal ? Colors.black : Colors.grey[100], shape: BoxShape.circle), child: Icon(icon, color: hasVal ? Colors.white : Colors.grey[400], size: 20 * sw)),
          SizedBox(width: 12 * sw),
          Expanded(child: Text(hasVal ? value! : label, style: GoogleFonts.inter(fontSize: 15 * sw, fontWeight: FontWeight.w600, color: hasVal ? Colors.black : Colors.black54))),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ]),
      ),
    );
  }

  Widget _buildStartButton(double sw, double sh, AppLocalizations l10n, {bool active = false, VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 60 * sh,
        decoration: BoxDecoration(color: active ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(30 * sh)),
        child: Center(child: Text(l10n.startSession.toUpperCase(), style: GoogleFonts.inter(color: active ? Colors.white : Colors.grey[400], fontSize: 16 * sw, fontWeight: FontWeight.w800))),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double sw, String title, {required bool isClose, VoidCallback? customPop}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20 * sw),
      child: Stack(alignment: Alignment.center, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: customPop ?? () => Navigator.pop(context),
                child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(isClose ? Icons.close : Icons.arrow_back_ios_new, color: Colors.black, size: 22 * sw)))),
        Text(title, style: GoogleFonts.inter(fontSize: 14 * sw, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _buildHandle() => Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)));

  Widget _buildBackgroundBlur(double sw, double sh) {
    return Stack(children: [
      Positioned(top: 71.7 * sh, left: -76.61 * sw, child: _blurSpot(315.2 * sw, 179.2 * sh, const Color(0xFF7ACBFF), 0.72)),
    ]);
  }

  Widget _blurSpot(double w, double h, Color color, double opacity) => Container(width: w, height: h, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(opacity), blurRadius: 100, spreadRadius: 20)]));
}


class ArcherTargetPainter extends CustomPainter {
  final Color color;
  ArcherTargetPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.4, paint);
    canvas.drawCircle(center, size.width * 0.2, paint);
    canvas.drawLine(Offset(size.width * 0.8, size.height * 0.2), Offset(size.width * 0.5, size.height * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}