import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import '/controller/generator_controller.dart';
import 'player_screen.dart';
import '../widgets/painter.dart';
import '../widgets/selector.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  late GeneratorController _logic;

  @override
  void initState() {
    super.initState();
    _logic = GeneratorController();
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

    return Container(
      height: size.height * 0.88,
      clipBehavior: Clip.hardEdge, 
      decoration: const BoxDecoration(
        color: Color(0xFFF7F4FF),
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
      case GeneratorView.goalSelection:
        return UniversalSelector(
          key: const ValueKey("goals"),
          title: l10n.meditationGoal,
          items: [l10n.goalStress, l10n.goalSleep, l10n.goalFocus, l10n.goalEnergy, l10n.goalAnxiety],
          sw: sw,
          onBack: () => _logic.setView(GeneratorView.main),
          onSelect: _logic.updateGoal,
        );
      case GeneratorView.durationSelection:
        return UniversalSelector(
          key: const ValueKey("duration"),
          title: l10n.duration,
          items: const ["5 min", "10 min", "15 min"], // Можно оставить так или локализовать
          sw: sw,
          onBack: () => _logic.setView(GeneratorView.main),
          onSelect: _logic.updateDuration,
        );
      case GeneratorView.voiceSelection:
        return UniversalSelector(
          key: const ValueKey("voice"),
          title: l10n.voiceStyle,
          items: [l10n.voiceSoft, l10n.voiceNeutral, l10n.voiceDeep],
          sw: sw,
          onBack: () => _logic.setView(GeneratorView.main),
          onSelect: _logic.updateVoice,
        );
      case GeneratorView.soundSelection:
        return UniversalSelector(
          key: const ValueKey("sound"),
          title: l10n.backgroundSound,
          items: [l10n.soundNature, l10n.soundAmbient, l10n.soundRain, l10n.soundNone],
          sw: sw,
          onBack: () => _logic.setView(GeneratorView.main),
          onSelect: _logic.updateSound,
        );
      case GeneratorView.loading:
        return _buildLoadingView(sw, sh, l10n);
      case GeneratorView.finished:
        return _buildFinishedView(context, sw, sh, l10n);
      default:
        return _buildMainView(context, sw, sh, l10n);
    }
  }

  Widget _buildMainView(BuildContext context, double sw, double sh, AppLocalizations l10n) {
    return Stack(
      key: const ValueKey("main"),
      children: [
        Column(
          children: [
            const SizedBox(height: 12),
            _buildHandle(),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * sw),
                child: Column(
                  children: [
                    _buildTopVisual(sw, sh),
                    Transform.translate(
                      offset: Offset(0, -40 * sh),
                      child: _buildForm(context, sw, sh, l10n),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 26, left: 0, right: 0,
          child: _buildHeader(context, sw, l10n.generateMeditation.toUpperCase(), isClose: true),
        ),
      ],
    );
  }

  Widget _buildTopVisual(double sw, double sh) {
    return Expanded(
      flex: 12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 1.4, 
            child: CustomPaint(
              size: Size(359 * sw, 299 * sh),
              painter: SilhouettePainter(
                color: const Color.fromARGB(255, 255, 244, 254).withOpacity(0.8), 
                strokeWidth: 10.0, 
              ),
            ),
          ),
          Image.asset(
            "assets/images/generate.png", 
            height: 180 * sh, 
            fit: BoxFit.contain, 
            errorBuilder: (c,e,s) => const Icon(Icons.psychology, size: 100, color: Colors.black26)
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, double sw, double sh, AppLocalizations l10n) {
    return Column(
      children: [
        Text(l10n.generatorFillDetails, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 18 * sw, fontWeight: FontWeight.w700, height: 1.2)),
        SizedBox(height: 20 * sh),
        _optionRow(Icons.track_changes_outlined, l10n.meditationGoal, _logic.selectedGoal, () => _logic.setView(GeneratorView.goalSelection), sw, sh),
        _optionRow(Icons.history, l10n.duration, _logic.selectedDuration, () => _logic.setView(GeneratorView.durationSelection), sw, sh),
        _optionRow(Icons.graphic_eq, l10n.voiceStyle, _logic.selectedVoice, () => _logic.setView(GeneratorView.voiceSelection), sw, sh),
        _optionRow(Icons.music_note_outlined, l10n.backgroundSound, _logic.selectedSound, () => _logic.setView(GeneratorView.soundSelection), sw, sh),
        const SizedBox(height: 20),
        _buildGenerateButton(sw, sh, active: _logic.isReady, label: l10n.generate.toUpperCase(), onTap: _logic.isReady ? () => _logic.handleGenerate(context) : null),
        SizedBox(height: 10 * sh),
      ],
    );
  }

  Widget _buildLoadingView(double sw, double sh, AppLocalizations l10n) {
    return Center(
      key: const ValueKey("loading"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
          SizedBox(height: 32 * sh),
          Text(l10n.generating.toUpperCase(), style: GoogleFonts.inter(fontSize: 14 * sw, fontWeight: FontWeight.w800, letterSpacing: 2)),
          SizedBox(height: 12 * sh),
          Text(l10n.aiPreparing, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 16 * sw, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFinishedView(BuildContext context, double sw, double sh, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24 * sw),
      child: Column(
        key: const ValueKey("finished"),
        children: [
          const SizedBox(height: 12),
          _buildHandle(),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _circleBtn(Icons.close, () => _logic.setView(GeneratorView.main), isSmall: true),
              ),
              Text(l10n.meditation.toUpperCase(), style: GoogleFonts.inter(fontSize: 14 * sw, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: _logic.aiImageUrl != null 
              ? Image.network(_logic.aiImageUrl!, height: 200 * sh, width: double.infinity, fit: BoxFit.cover)
              : Container(height: 200 * sh, color: Colors.grey[300], child: const Icon(Icons.image_outlined)),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_logic.aiTitle?.toUpperCase() ?? l10n.ready.toUpperCase(), style: GoogleFonts.inter(fontSize: 20 * sw, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(l10n.personalizedReady, style: GoogleFonts.inter(fontSize: 16 * sw, color: Colors.black45)),
                const SizedBox(height: 4),
                Text(_logic.selectedDuration?.toLowerCase() ?? "", style: GoogleFonts.inter(fontSize: 14 * sw, color: Colors.black38)),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    imageUrl: _logic.aiImageUrl ?? "",
                    title: _logic.aiTitle ?? _logic.selectedGoal ?? l10n.meditation,
                    durationString: _logic.selectedDuration ?? "5 min",
                    backgroundSound: _logic.selectedSound ?? l10n.soundNone,
                    voiceSource: _logic.voiceSource,
                  ),
                ),
              );
            },
            child: Container(
              height: 70 * sh, width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(35 * sh)),
              child: Stack(
                children: [
                  Center(child: Text(l10n.start.toUpperCase(), style: GoogleFonts.inter(color: Colors.white, fontSize: 16 * sw, fontWeight: FontWeight.w800, letterSpacing: 1))),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 58 * sh, height: 58 * sh,
                        decoration: const BoxDecoration(color: Color(0xFF2D2D2D), shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40 * sh),
        ],
      ),
    );
  }

  // Вспомогательные методы
  Widget _circleBtn(IconData i, VoidCallback t, {bool isSmall = false}) => GestureDetector(onTap: t, child: Container(padding: EdgeInsets.all(isSmall ? 8 : 12), decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black12), child: Icon(i, color: Colors.black, size: isSmall ? 18 : 22)));

  Widget _buildBackgroundBlur(double sw, double sh) {
    return Stack(
      children: [
        Positioned(top: 70 * sh, left: -80 * sw, child: _blurSpot(320 * sw, 180 * sh, const Color(0xFFE5D9FF), 0.6)),
        Positioned(top: 100 * sh, left: 80 * sw, child: _blurSpot(240 * sw, 140 * sh, const Color(0xFFD9E5FF), 0.5)),
      ],
    );
  }

  Widget _blurSpot(double w, double h, Color color, double opacity) => Container(width: w, height: h, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(opacity), blurRadius: 100, spreadRadius: 20)]));

  Widget _optionRow(IconData icon, String label, String? value, VoidCallback onTap, double sw, double sh) {
    bool hasVal = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4 * sh),
        constraints: BoxConstraints(minHeight: 64 * sh),
        padding: EdgeInsets.symmetric(horizontal: 16 * sw, vertical: 8 * sh),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20 * sw)),
        child: Row(
          children: [
            Container(padding: EdgeInsets.all(hasVal ? 8 * sw : 0), decoration: BoxDecoration(color: hasVal ? const Color(0xFF2D2D2D) : Colors.transparent, shape: BoxShape.circle), child: Icon(icon, color: hasVal ? Colors.white : Colors.grey[400], size: 20 * sw)),
            SizedBox(width: 12 * sw),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [if (hasVal) Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 10 * sw, fontWeight: FontWeight.w500, color: Colors.black38, height: 1.0)), Text(hasVal ? value : label, style: GoogleFonts.inter(fontSize: 15 * sw, fontWeight: FontWeight.w600, color: hasVal ? Colors.black : Colors.black54, height: 1.2))])),
            Icon(Icons.arrow_forward_ios, size: 12, color: hasVal ? Colors.black : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() => Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)));

  Widget _buildHeader(BuildContext context, double sw, String title, {required bool isClose, VoidCallback? customPop}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20 * sw),
      child: Stack(alignment: Alignment.center, children: [
        Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: customPop ?? () => Navigator.pop(context), child: Icon(isClose ? Icons.close : Icons.arrow_back_ios_new, color: Colors.black, size: 22 * sw))),
        Text(title, style: GoogleFonts.inter(fontSize: 14 * sw, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _buildGenerateButton(double sw, double sh, {bool active = false, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60 * sh,
        decoration: BoxDecoration(color: active ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(30 * sh)),
        child: Center(child: Text(label, style: GoogleFonts.inter(color: active ? Colors.white : Colors.grey[400], fontSize: 16 * sw, fontWeight: FontWeight.w800))),
      ),
    );
  }
}