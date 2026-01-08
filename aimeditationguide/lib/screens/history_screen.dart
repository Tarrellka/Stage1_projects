import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/l10n/app_localizations.dart';
import '/controller/history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late HistoryController _logic;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _logic = HistoryController();
    _logic.addListener(() {
      if (mounted) setState(() {});
    });
    _logic.loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final double sw = (size.width / 375).clamp(0.8, 1.2);
    final double sh = (size.height / 812).clamp(0.8, 1.1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackgroundBlur(sw, sh),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(sw, l10n),
                const SizedBox(height: 30),
                _buildTabSelector(sw, l10n),
                Expanded(
                  child: _logic.isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Colors.black))
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildHistoryList(sw, sh, _logic.meditationHistory, l10n.meditationHistoryEmpty, l10n),
                          _buildHistoryList(sw, sh, [], l10n.breathingHistoryEmpty, l10n), // Сюда передайте _logic.breathingHistory когда будет готова
                        ],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double sw, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            l10n.history.toUpperCase(),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 14 * sw,
              letterSpacing: 1,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: const Icon(Icons.favorite, size: 20, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(double sw, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(23),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(23),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black26,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12 * sw),
        tabs: [
          Tab(text: l10n.meditations.toUpperCase()),
          Tab(text: l10n.breathing.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildHistoryList(double sw, double sh, List history, String emptyText, AppLocalizations l10n) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 14 * sw,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20 * sw, vertical: 20 * sh),
      itemCount: history.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(sw, sh, history[index], index, l10n);
      },
    );
  }

  Widget _buildHistoryCard(double sw, double sh, Map<String, dynamic> item, int index, AppLocalizations l10n) {
    // Используем текущую локаль для форматирования даты
    final String locale = Localizations.localeOf(context).languageCode;
    DateTime date = DateTime.parse(item['date'] ?? DateTime.now().toIso8601String());
    String formattedDate = DateFormat('dd MMM, HH:mm', locale).format(date);

    return Container(
      margin: EdgeInsets.only(bottom: 12 * sh),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item['image'] ?? '',
              width: 80 * sw,
              height: 80 * sh,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80 * sw,
                height: 80 * sh,
                color: Colors.grey[100],
                child: const Icon(Icons.image_outlined, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item['title'] ?? l10n.meditation).toString().toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 14 * sw,
                  ),
                ),
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 12 * sw,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9F4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.completed.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10 * sw,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF77C97E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _logic.deleteItem(index),
            icon: const Icon(Icons.delete_outline, color: Color(0xFFFFB2B2)),
          ),
        ],
      ),
    );
  }

  // Фон и размытие
  Widget _buildBackgroundBlur(double sw, double sh) {
    return Stack(
      children: [
        Positioned(
          top: 100 * sh,
          left: -50 * sw,
          child: _blurSpot(250 * sw, 250 * sh, const Color(0xFFCBA7FF).withOpacity(0.15)),
        ),
        Positioned(
          bottom: 200 * sh,
          right: -50 * sw,
          child: _blurSpot(200 * sw, 200 * sh, const Color(0xFF7ACBFF).withOpacity(0.15)),
        ),
      ],
    );
  }

  Widget _blurSpot(double w, double h, Color color) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}