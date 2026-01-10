import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'paywall_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Cubic(0.2, 0.0, 0.2, 1.0)),
    );

    _controller.forward();
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _checkFirstRunAndNavigate();
          }
        });
      }
    });
  }

  Future<void> _checkFirstRunAndNavigate() async {
    // 1. Инициализируем настройки
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    // 2. ФОНОВАЯ ЗАГРУЗКА: Пока идет сплэш, подгружаем историю из Firebase
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
        print("Успешный анонимный вход: ${FirebaseAuth.instance.currentUser?.uid}");
      }
    } catch (e) {
      print("Ошибка входа: $e");
    }

    Widget nextScreen;
    if (isFirstRun) {
      nextScreen = const OnboardingScreen();
      await prefs.setBool('isFirstRun', false);
    } else {
      nextScreen = const PaywallScreen();
    }

    if (!mounted) return;

    // Плавный переход
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double shadowVerticalOffset = 30.0; 
    const double shadowHorizontalOffset = 80.0;
    const double globalShadowOpacity = 0.8;
    const double imgWidth = 280.0;
    const double imgHeight = 225.0; 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackgroundMesh(context),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: imgWidth,
                  height: imgHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        bottom: shadowVerticalOffset,
                        left: shadowHorizontalOffset,
                        child: _buildFigmaShadows(globalShadowOpacity),
                      ),
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        child: Image.asset('assets/images/onb1.png', width: imgWidth),
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return ClipRect(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              heightFactor: _animation.value,
                              child: Image.asset('assets/images/onb1.png', width: imgWidth),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                _buildTitle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Вспомогательные виджеты интерфейса ---
  
  Widget _buildFigmaShadows(double globalOpacity) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _singleShadow(121.8, 21.0, 0.15 * globalOpacity, 25.0, 2.0),
        _singleShadow(108.6, 18.7, 0.15 * globalOpacity, 20.0, 1.5),
        _singleShadow(95.5, 12.0, 0.15 * globalOpacity, 15.0, 1.0),
        _singleShadow(85.6, 9.4, 0.40 * globalOpacity, 10.0, 0.0),
      ],
    );
  }

  Widget _singleShadow(double w, double h, double op, double blur, double spread) {
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withOpacity(op * 0.5),
        borderRadius: BorderRadius.all(Radius.elliptical(w, h)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111111).withOpacity(op),
            blurRadius: blur,
            spreadRadius: spread,
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundMesh(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        _spot(size.height * 0.25, -60, 300, const Color(0xFFCBA7FF), 0.5),
        _spot(size.height * 0.1, -40, 280, const Color(0xFF7ACBFF), 0.45),
        _spot(size.height * 0.2, size.width * 0.5, 300, const Color(0xFF77C97E), 0.4),
        _spot(size.height * 0.6, size.width * 0.4, 320, const Color(0xFFFFD1A3), 0.5),
      ],
    );
  }

  Widget _spot(double top, double left, double size, Color color, double opacity) {
    return Positioned(
      top: top, left: left,
      child: Container(
        width: size, height: size * 0.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity),
              blurRadius: 80,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: color.withOpacity(opacity * 0.5),
              blurRadius: 150,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.playfairDisplay(
          fontSize: 38,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: Colors.black.withOpacity(0.8),
        ),
        children: [
          const TextSpan(text: "AI Meditation\n"),
          TextSpan(
            text: "Guide",
            style: GoogleFonts.inter(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.black),
          ),
        ],
      ),
    );
  }
}