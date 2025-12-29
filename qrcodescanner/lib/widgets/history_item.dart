import 'package:flutter/material.dart';
import '../models/task_models.dart';

class HistoryItem extends StatelessWidget {
  final ScanModel scan;
  const HistoryItem({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          child: const Icon(Icons.qr_code_2, color: Colors.deepPurple),
        ),
        title: Text(scan.rawData, maxLines: 1, overflow: TextOverflow.ellipsis, 
             style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(scan.aiAnalysis, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () => _showDetails(context),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetailsSheet(scan: scan),
    );
  }
}

class _DetailsSheet extends StatelessWidget {
  final ScanModel scan;
  const _DetailsSheet({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              const SizedBox(height: 24),
              _buildLabel("Raw Data:"),
              SelectableText(scan.rawData, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 24),
              _buildLabel("AI Security Analysis:"),
              SelectableText(scan.aiAnalysis, style: const TextStyle(fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() => Center(
    child: Container(width: 40, height: 4, decoration: BoxDecoration(
      color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
  );
}