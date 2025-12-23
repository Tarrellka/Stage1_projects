import 'package:flutter/material.dart';
import '../services/history_service.dart';
import '../main.dart'; // Импортируем наш сигнал (notifier)

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
    
    // Подписываемся на обновления
    historyUpdateNotifier.addListener(_loadHistory);
  }

  @override
  void dispose() {
    // Отписываемся при закрытии, чтобы не тратить память
    historyUpdateNotifier.removeListener(_loadHistory);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final data = await HistoryService.getHistory();
    if (mounted) {
      setState(() {
        _history = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("История"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await HistoryService.clearHistory();
              _loadHistory();
            },
          )
        ],
      ),
      body: _history.isEmpty
          ? const Center(child: Text("История пуста"))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item['content'] ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(item['analysis'] ?? "", maxLines: 2),
                    onTap: () => _showDetails(item),
                  ),
                );
              },
            ),
    );
  }

  void _showDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Данные QR:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SelectableText(item['content'] ?? ""),
            const Divider(height: 30),
            const Text("Анализ безопасности:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Expanded(child: SingleChildScrollView(child: SelectableText(item['analysis'] ?? ""))),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Center(child: Text("Закрыть")),
            )
          ],
        ),
      ),
    );
  }
}