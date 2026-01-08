import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniversalSelector extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelect;
  final VoidCallback onBack;
  final double sw;

  const UniversalSelector({
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
    required this.onBack,
    required this.sw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9), // Светло-серый фон
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Индикатор (Handle) сверху
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Заголовок с кнопкой назад
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * sw),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 16 * sw, color: Colors.black),
                    ),
                  ),
                ),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 14 * sw,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          
          // Список элементов, центрированный по вертикали
          Expanded(
            child: Center(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () => onSelect(items[index]),
                      child: Container(
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white, // Фулл белые кнопки
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          items[index],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}