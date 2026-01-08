import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import '/controller/home_controller.dart';
import 'history_screen.dart';
import '/models/home_content_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const HomeContentView(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final double sw = (size.width / 375).clamp(0.8, 1.2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          IndexedStack(
            index: _controller.currentIndex,
            children: _pages,
          ),
          _buildBottomNavBar(l10n, sw),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(AppLocalizations l10n, double sw) {
    return Positioned(
      bottom: 25,
      left: 40,
      right: 40,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navIcon(
              Icons.home_filled, 
              l10n.home, // Используем локализацию
              _controller.currentIndex == 0, 
              () => _controller.setIndex(0),
              sw,
            ),
            _navIcon(
              Icons.access_time_filled, 
              l10n.history, // Используем локализацию
              _controller.currentIndex == 1, 
              () => _controller.setIndex(1),
              sw,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, bool active, VoidCallback onTap, double sw) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 20 * sw, vertical: 8),
            decoration: active 
                ? BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)) 
                : const BoxDecoration(),
            child: Icon(
              icon, 
              color: active ? Colors.black : Colors.grey[300], 
              size: 26 * sw,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(), // Приводим к верхнему регистру для стиля
            style: GoogleFonts.inter(
              fontSize: 10 * sw, 
              fontWeight: active ? FontWeight.w800 : FontWeight.w500, 
              color: active ? Colors.black : Colors.grey[400],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}