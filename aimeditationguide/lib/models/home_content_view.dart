import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import '/l10n/app_localizations.dart'; 
import '/controller/home_controller.dart';
import '/controller/daily_routine_controller.dart'; 
import '/screens/generator_screen.dart';
import '/screens/breathing_screen.dart';
import '/screens/daily_screen.dart';
import '../widgets/painter.dart';
import '../widgets/breathing_card_widget.dart';

class HomeContentView extends StatefulWidget {
  const HomeContentView({super.key});

  @override
  State<HomeContentView> createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  late HomeController _logic;

  @override
  void initState() {
    super.initState();
    _logic = HomeController();
    _logic.loadRecommendations();
    _logic.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _showModal(BuildContext context, Widget screen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => screen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final double sw = (size.width / 375).clamp(0.8, 1.2);
    final double sh = (size.height / 812).clamp(0.8, 1.1);
    final bool isMorning = _logic.isMorning();

    return Stack(
      children: [
        _buildHomeBackground(context, isMorning),
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildHeader(l10n),
                const SizedBox(height: 30),
                _buildMainActions(context, sw, l10n),
                const SizedBox(height: 40),
                _buildContinueSection(context, sw, sh, l10n),
                const SizedBox(height: 40),
                _buildSectionTitle(l10n.recommendedSessions, ""),
                const SizedBox(height: 15),
                _buildRecommendedList(context, sw, sh),
                const SizedBox(height: 130),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.playfairDisplay(fontSize: 24, fontStyle: FontStyle.italic, color: const Color(0xFF1E1E1E)),
          children: [
            TextSpan(text: "${l10n.hello}, "),
            const TextSpan(text: "Vitalii", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal)),
            TextSpan(
              text: "\n${l10n.howAreYouFeeling}",
              style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w900, height: 1.1, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActions(BuildContext context, double sw, AppLocalizations l10n) {
    return Column(
      children: [
        _actionButton(text: l10n.generateMeditation, color: const Color(0xFFCBA7FF), painter: LotusIconPainter(color: const Color(0xFFCBA7FF)), onTap: () => _showModal(context, const GeneratorScreen())),
        const SizedBox(height: 12),
        _actionButton(text: l10n.breathingExercise, color: const Color(0xFF7ACBFF), painter: BreathingIconPainter(color: const Color(0xFF7ACBFF)), onTap: () => _showModal(context, const BreathingExerciseScreen())),
        const SizedBox(height: 12),
        _actionButton(text: l10n.dailyRoutine, color: const Color(0xFF77C97E), painter: RoutineIconPainter(color: const Color(0xFF77C97E)), onTap: () => _showModal(context, const DailyRoutineScreen())),
      ],
    );
  }

  Widget _actionButton({required String text, required Color color, required CustomPainter painter, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 72,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))]),
        child: Row(
          children: [
            const SizedBox(width: 20),
            SizedBox(width: 28, height: 28, child: CustomPaint(painter: painter)),
            const SizedBox(width: 15),
            Text(text.toUpperCase(), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }


  Widget _buildContinueSection(BuildContext context, double sw, double sh, AppLocalizations l10n) {
 
    final routineController = Provider.of<DailyRoutineController>(context);
    

    if (routineController.lastCompletedExercise == null) {
      return const SizedBox.shrink();
    }

    final lastCard = routineController.lastCompletedExercise!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.continueLastSession, ""),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => _showModal(context, BreathingExerciseScreen(initialCard: lastCard)),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(28), 
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))], 
              border: Border.all(color: lastCard.color.withOpacity(0.1))
            ),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60, 
                  decoration: BoxDecoration(color: lastCard.color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), 
                  child: Icon(Icons.play_arrow_rounded, color: lastCard.color, size: 35)
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(lastCard.getLocalizedTitle(context), style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 18)), 
                    Text("${l10n.continueWith} ${lastCard.getLocalizedDuration(context)}", style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13))
                  ]),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedList(BuildContext context, double sw, double sh) {
    return SizedBox(
      height: 210 * sh,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _logic.recommendedCards.length,
        itemBuilder: (context, index) {
          final cardData = _logic.recommendedCards[index];
          return BreathingCardWidget(card: cardData, sw: sw, sh: sh, onTap: () => _showModal(context, BreathingExerciseScreen(initialCard: cardData)));
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, String date) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800)), if (date.isNotEmpty) Text(date, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[400]))]);

  Widget _buildHomeBackground(BuildContext context, bool isMorning) {
    final Size size = MediaQuery.of(context).size;
    final double sw = size.width / 375;
    final double sh = size.height / 1133;
    final Color primarySpot = isMorning ? const Color(0xFFFFD1A3) : const Color(0xFF4A55A2);
    final Color secondarySpot = isMorning ? const Color(0xFFCBA7FF) : const Color(0xFF1E1E1E);

    return Stack(
      children: [
        Positioned(top: 164.75 * sh, left: -39.5 * sw, child: _blurSpot(241 * sw, 137 * sh, primarySpot)),
        Positioned(top: 313.83 * sh, left: -42.92 * sw, child: _blurSpot(241 * sw, 137 * sh, secondarySpot)),
        Positioned(top: 233.25 * sh, left: 186.5 * sw, child: _blurSpot(235 * sw, 133 * sh, const Color(0xFF77C97E))),
        Positioned(top: 578.98 * sh, left: 216.93 * sw, child: _blurSpot(235 * sw, 133 * sh, const Color(0xFF7ACBFF))),
      ],
    );
  }

  Widget _blurSpot(double w, double h, Color color) => Container(width: w, height: h, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.72), blurRadius: 230, spreadRadius: 40)]));
}