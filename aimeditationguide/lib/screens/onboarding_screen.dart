import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/l10n/app_localizations.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage(int dataLength) {
    if (_currentPage < dataLength - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600), 
        curve: Curves.easeInOutCubic
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.of(context).size;
    final double sw = (screenSize.width / 375).clamp(0.8, 1.2);
    final double imgWidth = (screenSize.width * 0.75).clamp(200.0, 300.0);
    final double containerHeight = imgWidth * 0.85;


    final List<Map<String, dynamic>> onboardingData = [
      {
        "image": "assets/images/onb1.png",
        "title": l10n.onboardingTitle1,
        "subtitle": l10n.onboardingSubtitle1,
        "shadowBottom": 0.11,
        "shadowOffset": 0.0,
        "shadowScale": 1.3,
        "colors": [0xFFCBA7FF, 0xFF7ACBFF, 0xFFFFD1A3, 0xFF77C97E],
      },
      {
        "image": "assets/images/onb2.png",
        "title": l10n.onboardingTitle2,
        "subtitle": l10n.onboardingSubtitle2,
        "shadowBottom": 0.09,
        "shadowOffset": 0.0,
        "shadowScale": 1.0,
        "colors": [0xFFCBA7FF, 0xFF77C97E, 0xFFFFD1A3, 0xFF7ACBFF],
      },
      {
        "image": "assets/images/onb3.png",
        "title": l10n.onboardingTitle3,
        "subtitle": l10n.onboardingSubtitle3,
        "shadowBottom": 0.18,
        "shadowOffset": 125.0 * sw,
        "shadowScale": 0.4,
        "colors": [0xFFCBA7FF, 0xFF7ACBFF, 0xFFFFD1A3, 0xFF77C97E], 
      },
      {
        "image": "assets/images/onb4.png",
        "title": l10n.onboardingTitle4,
        "subtitle": l10n.onboardingSubtitle4,
        "shadowBottom": 0.23,
        "shadowOffset": 112.0 * sw, 
        "shadowScale": 0.8,
        "colors": [0xFFCBA7FF, 0xFFFFD1A3, 0xFF77C97E, 0xFF7ACBFF], 
      },
    ];

    final currentData = onboardingData[_currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackgroundMesh(screenSize, currentData['colors']),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = onboardingData[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: imgWidth,
                            height: containerHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  bottom: imgWidth * data['shadowBottom'],
                                  left: data['shadowOffset'] != 0 ? data['shadowOffset'] : null,
                                  child: _buildFigmaShadows(0.8, imgWidth, data['shadowScale']),
                                ),
                                Image.asset(data["image"], width: imgWidth, fit: BoxFit.contain),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: (screenSize.height * 0.05).clamp(32.0, 42.0),
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFF1E1E1E),
                                ),
                                children: [
                                  TextSpan(text: "${data["title"]}\n"),
                                  TextSpan(
                                    text: data["subtitle"],
                                    style: GoogleFonts.inter(
                                      fontSize: (screenSize.height * 0.045).clamp(30.0, 40.0),
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildPageIndicator(onboardingData.length),
                const SizedBox(height: 32),
                _buildNextButton(l10n, onboardingData.length, sw),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFigmaShadows(double globalOpacity, double imgWidth, double customScale) {
    final double scale = (imgWidth / 280.0) * customScale;
    return Stack(
      alignment: Alignment.center,
      children: [
        _singleShadow(121.0 * scale, 21.0 * scale, 0.15 * globalOpacity, 25.0 * scale, 2.0),
        _singleShadow(108.0 * scale, 18.0 * scale, 0.15 * globalOpacity, 20.0 * scale, 1.5),
        _singleShadow(85.0 * scale, 9.0 * scale, 0.40 * globalOpacity, 10.0 * scale, 0.0),
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
          BoxShadow(color: const Color(0xFF111111).withOpacity(op), blurRadius: blur, spreadRadius: spread),
        ],
      ),
    );
  }

  Widget _buildBackgroundMesh(Size size, List<int> colors) {
    return Stack(
      children: [
        _spot(size.height * 0.25, -size.width * 0.1, 300, Color(colors[0]), 0.4),
        _spot(size.height * 0.05, -size.width * 0.05, 280, Color(colors[1]), 0.35),
        _spot(size.height * 0.20, size.width * 0.6, 320, Color(colors[2]), 0.45),
        _spot(size.height * 0.60, size.width * 0.5, 300, Color(colors[3]), 0.4),
      ],
    );
  }

  Widget _spot(double top, double left, double size, Color color, double opacity) {
    return Positioned(
      top: top, left: left,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: size, height: size * 0.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withOpacity(opacity), blurRadius: 90, spreadRadius: 10),
            BoxShadow(color: color.withOpacity(opacity * 0.5), blurRadius: 160, spreadRadius: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 24 : 4, height: 4,
          decoration: BoxDecoration(color: isActive ? Colors.black : const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
        );
      }),
    );
  }

  Widget _buildNextButton(AppLocalizations l10n, int dataLength, double sw) {
    bool isLastPage = _currentPage == dataLength - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => _nextPage(dataLength),
        child: Container(
          height: 72,
          decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(36)),
          child: Row(
            children: [
              const Spacer(flex: 3),
              Text(
                isLastPage ? l10n.startNow.toUpperCase() : l10n.next.toUpperCase(),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16 * sw, fontWeight: FontWeight.w700, letterSpacing: 1.2),
              ),
              const Spacer(flex: 2),
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 56, height: 56,
                decoration: const BoxDecoration(color: Color(0xFF222222), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 