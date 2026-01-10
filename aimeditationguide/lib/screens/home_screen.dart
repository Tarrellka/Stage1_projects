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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(_handleControllerChange);
    

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  void _handleControllerChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    super.dispose();
  }


  List<Widget> _getPages() {
    return [
      const HomeContentView(),
      const HistoryScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    final double sw = (size.width / 375).clamp(0.8, 1.2);

    return Scaffold(
      backgroundColor: Colors.white,

      extendBody: true,
      body: Stack(
        children: [

          if (!_isInitialized)
            const Center(child: CircularProgressIndicator.adaptive())
          else
            IndexedStack(
              index: _controller.currentIndex,
              children: _getPages(),
            ),
          
          _buildBottomNavBar(l10n, sw),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(AppLocalizations l10n, double sw) {
    return Positioned(
      bottom: 25,
      left: 24, 
      right: 24,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
              l10n.home, 
              _controller.currentIndex == 0, 
              () => _controller.setIndex(0),
              sw,
            ),
            _navIcon(
              Icons.access_time_filled, 
              l10n.history, 
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
    return Expanded( 
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 20 * sw, vertical: 8),
              decoration: active 
                  ? BoxDecoration(
                      color: const Color(0xFFF5F5F5), 
                      borderRadius: BorderRadius.circular(20),
                    ) 
                  : BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
              child: Icon(
                icon, 
                color: active ? Colors.black : Colors.grey[400], 
                size: 26 * sw,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10 * sw, 
                fontWeight: active ? FontWeight.w800 : FontWeight.w500, 
                color: active ? Colors.black : Colors.grey[400],
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}