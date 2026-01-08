  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'dart:ui'; 
  import 'home_screen.dart';

  class PaywallScreen extends StatefulWidget {
    const PaywallScreen({super.key});

    @override
    State<PaywallScreen> createState() => _PaywallScreenState();
  }

  class _PaywallScreenState extends State<PaywallScreen> {
    String selectedPlan = 'monthly';

    // Метод перехода вынесен отдельно для чистоты
    void _navigateToHome() async {
  // Даем UI потоку "продышаться"
  await Future.delayed(const Duration(milliseconds: 100));
  if (!mounted) return;
  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            // 1. Оптимизированный фон
            _buildBackground(),
            
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          Center(
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/3209/3209931.png',
                              height: 120,
                              // Кэшируем размер, чтобы не вешать UI при отрисовке
                              cacheHeight: 240, 
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          Text(
                            "Unlock Full",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "AI Meditation Power",
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Unlimited guided sessions, personalized AI meditations, track your mindfulness.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          _buildFeaturesList(),
                          
                          const SizedBox(height: 30),

                          _buildPlanOption(
                            id: 'weekly',
                            title: 'Weekly',
                            price: '\$3.99',
                            period: '/ week',
                            badge: '3-day trial',
                            color: Colors.purpleAccent,
                          ),
                          _buildPlanOption(
                            id: 'monthly',
                            title: 'Monthly',
                            price: '\$11.99',
                            period: '/ month',
                            color: Colors.blueAccent,
                          ),
                          _buildPlanOption(
                            id: 'yearly',
                            title: 'Yearly',
                            price: '\$49.99',
                            period: '/ year',
                            badge: 'Save 75%',
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: _navigateToHome,
                      child: _buildNextButton(),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              child: IconButton(
                onPressed: _navigateToHome,
                icon: const Icon(Icons.close_rounded, color: Colors.black54, size: 30),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildBackground() {
      return Stack(
        children: [
          Container(color: Colors.white),
          _buildEllipse(241, 137, -107, 80.77, const Color(0xFF7ACBFF)), 
          _buildEllipse(235, 133, 116, 149.27, const Color(0xFFFFD1A3)), 
          _buildEllipse(241, 137, -110.42, 229.85, const Color(0xFFCBA7FF)),
          _buildEllipse(235, 133, 146.43, 495, const Color(0xFF77C97E)), 

          Positioned.fill(
            child: ClipRect( // ClipRect критически важен для производительности BackdropFilter
              child: BackdropFilter(
                // Sigma 70 заменена на 25 для плавности на эмуляторах
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25), 
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildEllipse(double w, double h, double offsetX, double top, Color color) {
      return Positioned(
        width: w,
        height: h,
        left: (MediaQuery.of(context).size.width / 2) - (w / 2) + offsetX,
        top: top,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    Widget _buildFeaturesList() {
      final List<String> features = [
        "Personalized Sessions",
        "Sleep & Relaxation",
        "Focus & Energy",
        "Mindfulness Tracking",
        "Nature & Music Sounds"
      ];

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 20, color: Colors.black),
                const SizedBox(width: 12),
                Text(f, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          )).toList(),
        ),
      );
    }

    Widget _buildPlanOption({required String id, required String title, required String price, required String period, String? badge, required Color color}) {
      bool isSelected = selectedPlan == id;
      return GestureDetector(
        onTap: () => setState(() => selectedPlan = id),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), 
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: 2)
          ),
          child: Row(
            children: [
              Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Row(
                    children: [
                      Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(period, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text(badge, style: TextStyle(color: color.darken(), fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? Colors.black : Colors.grey[300]),
            ],
          ),
        ),
      );
    }

    Widget _buildNextButton() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 70,
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(35)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Text("NEXT", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8), 
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.1), 
                child: const Icon(Icons.arrow_forward, color: Colors.white)
              )
            ),
          ],
        ),
      );
    }
  }

  // Extension для затемнения цветов (Darken)
  extension ColorExtension on Color {
    Color darken([double amount = .1]) {
      assert(amount >= 0 && amount <= 1);
      final hsl = HSLColor.fromColor(this);
      final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
      return hslDark.toColor();
    }
  }