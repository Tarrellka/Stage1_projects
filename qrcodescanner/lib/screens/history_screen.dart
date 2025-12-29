import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '../services/database_service.dart';
import '../models/task_models.dart'; 
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = DatabaseService();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyScreenTitle),
      ),
      body: StreamBuilder<List<ScanModel>>(
        stream: _db.historyStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${l10n.errorAnalysis}: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n.historyEmpty));
          }

          final history = snapshot.data!;

          return ListView.builder(
            itemCount: history.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final scan = history[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.qr_code_2, color: Colors.deepPurple),
                  title: Text(scan.rawData, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(scan.timestamp),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    _showDetails(context, scan, l10n);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetails(BuildContext context, ScanModel scan, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiAnalysisTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  scan.aiAnalysis.isEmpty ? l10n.noAnalysis : scan.aiAnalysis,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}