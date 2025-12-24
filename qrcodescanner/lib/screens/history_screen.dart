import 'package:flutter/material.dart';
import '../services/history_service.dart';
import '../main.dart'; 

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    historyUpdateNotifier.addListener(_loadHistory);
  }

  @override
  void dispose() {
    historyUpdateNotifier.removeListener(_loadHistory);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final data = await HistoryService.getHistory();
    
    if (mounted) {
      setState(() {
        _history = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("История сканирований"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirmed = await _showDeleteConfirm();
              if (confirmed == true) {
                await HistoryService.clearHistory();
                _loadHistory();
              }
            },
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _history.isEmpty
          ? const Center(child: Text("История пуста"))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.qr_code_2),
                    title: Text(
                      item['raw_data'] ?? "Нет данных", 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis
                    ),
                    subtitle: Text(
                      item['ai_verdict'] ?? "Анализ отсутствует", 
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis
                    ),
                    onTap: () => _showDetails(item),
                  ),
                );
              },
            ),
    );
  }

  Future<bool?> _showDeleteConfirm() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Очистить историю?"),
        content: const Text("Это действие нельзя будет отменить."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Отмена")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Удалить", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _showDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Данные QR:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            SelectableText(item['raw_data'] ?? ""),
            const Divider(height: 30),
            const Text("Вердикт ИИ:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(child: SelectableText(item['ai_verdict'] ?? "")),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Закрыть"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}