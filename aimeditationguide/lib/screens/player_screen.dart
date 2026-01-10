import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import '/controller/player_controller.dart';

class PlayerScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String durationString;
  final String backgroundSound;
  final Source? voiceSource;

  const PlayerScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.durationString,
    required this.backgroundSound,
    this.voiceSource,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late PlayerController _logic;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _logic = PlayerController(
      initialBackgroundSound: widget.backgroundSound,
      voiceSource: widget.voiceSource,
      title: widget.title,
      imageUrl: widget.imageUrl,
      initialTotalSeconds: _parseDuration(widget.durationString),
    );
    _logic.addListener(() {
      if (mounted) setState(() {});
    });
    _resetHideTimer();
  }

  int _parseDuration(String duration) {
    try {
      final parts = duration.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } catch (_) { return 300; }
  }

  void _resetHideTimer() {
    _hideControlsTimer?.cancel();
    setState(() => _showControls = true);
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _logic.dispose();
    super.dispose();
  }

  String _formatTime(int s) => "${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";

  String _translateSoundName(String id, AppLocalizations l10n) {
    switch (id.toLowerCase()) {
      case 'none': return l10n.soundNone;
      case 'nature': return l10n.soundNature;
      case 'ambient music': return l10n.soundAmbient;
      case 'rain': return l10n.soundRain;
      default: return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final double sw = (size.width / 375).clamp(0.8, 1.2);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _resetHideTimer,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                widget.imageUrl, 
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
              ),
            ),
            Positioned.fill(child: Container(color: Colors.black38)),
            if (!_logic.isLoading) SafeArea(
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildTopActions(l10n),
                      const Spacer(),
                      _buildMediaControls(sw),
                      const Spacer(),
                      _buildProgressSlider(),
                      const SizedBox(height: 40),
                      _buildBottomBar(l10n, sw),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActions(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circleBtn(Icons.close, () => Navigator.pop(context, true)),
        _circleBtn(
          _logic.isFavorite ? Icons.favorite : Icons.favorite_border, 
          () async {
            final success = await _logic.addToHistory();
            if (success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.addedToHistory), 
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          iconColor: _logic.isFavorite ? Colors.red : Colors.white,
        ),
      ],
    );
  }

  Widget _buildMediaControls(double sw) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _logic.seekTo((_logic.elapsedSeconds - 10).clamp(0, _logic.totalSeconds)), 
          icon: Icon(Icons.replay_10, color: Colors.white, size: 30 * sw)
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: _logic.togglePlay,
          child: Container(
            width: 86 * sw, height: 86 * sw,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Icon(_logic.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black, size: 40 * sw),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () => _logic.seekTo((_logic.elapsedSeconds + 10).clamp(0, _logic.totalSeconds)), 
          icon: Icon(Icons.forward_10, color: Colors.white, size: 30 * sw)
        ),
      ],
    );
  }

  Widget _buildProgressSlider() {
    return Column(
      children: [
        Slider(
          value: _logic.elapsedSeconds.toDouble(), 
          max: _logic.totalSeconds.toDouble() > 0 ? _logic.totalSeconds.toDouble() : 100.0, 
          activeColor: Colors.white, 
          inactiveColor: Colors.white30,
          onChanged: (v) => _logic.seekTo(v.toInt()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatTime(_logic.elapsedSeconds), style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(_formatTime(_logic.totalSeconds), style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n, double sw) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showSoundPicker(l10n),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10, 
              borderRadius: BorderRadius.circular(24), 
              border: Border.all(color: Colors.white12)
            ),
            child: Row(
              children: [
                const Icon(Icons.library_music_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.backgroundSoundsLabel, style: const TextStyle(color: Colors.white38, fontSize: 9)),
                    Text(
                      _translateSoundName(_logic.selectedSoundId, l10n), 
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        _circleBtn(Icons.ios_share, () {}),
      ],
    );
  }

  void _showSoundPicker(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(color: Color(0xFFF7F8FA), borderRadius: BorderRadius.vertical(top: Radius.circular(44))),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              _buildModalHeader(context, l10n),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _soundCard("None", "assets/images/none.png", l10n),
                    _soundCard("Nature", "assets/images/nature.png", l10n),
                    _soundCard("Ambient music", "assets/images/ambient.png", l10n),
                    _soundCard("Rain", "assets/images/rain.png", l10n),
                  ],
                ),
              ),
              _buildVolumeSlider(l10n),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _soundCard(String id, String imgPath, AppLocalizations l10n) {
    bool isSelected = _logic.selectedSoundId == id;
    return GestureDetector(
      onTap: () => _logic.selectSound(id),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _translateSoundName(id, l10n), 
            style: GoogleFonts.inter(
              fontSize: 12, 
              fontWeight: FontWeight.w500, 
              color: isSelected ? Colors.black : Colors.black45
            )
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F6).withOpacity(0.5), 
        borderRadius: BorderRadius.circular(32)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.backgroundVolumeTitle, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
          Slider(
            value: _logic.backgroundVolume,
            activeColor: Colors.black,
            inactiveColor: Colors.black12,
            onChanged: (v) => _logic.setBackgroundVolume(v),
          ),
        ],
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleBtn(Icons.close, () => Navigator.pop(context), color: Colors.white, iconColor: Colors.black26),
          Text(
            l10n.backgroundSoundsHeader.toUpperCase(), 
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.5)
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData i, VoidCallback t, {Color color = Colors.white12, Color iconColor = Colors.white}) => 
      GestureDetector(
        onTap: t, 
        child: Container(
          padding: const EdgeInsets.all(10), 
          decoration: BoxDecoration(shape: BoxShape.circle, color: color), 
          child: Icon(i, color: iconColor, size: 22)
        )
      );
}