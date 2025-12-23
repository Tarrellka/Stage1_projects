import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_models.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => StatsScreenState();
}

class StatsScreenState extends State<StatsScreen> {
  // Пустой метод для совместимости с твоим GlobalKey в MainHolder
  void refreshData() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskModels>(context);
    final tasks = taskProvider.allTasks;

    int total = tasks.length;
    int completed = tasks.where((t) => t.isCompleted).length;
    double percent = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Твой светлый фон
      appBar: AppBar(
        title: const Text("Статистика", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- ТО САМОЕ КОЛЕСО (Круговая диаграмма) ---
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      color: const Color(0xFF3366FF),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${(percent * 100).toInt()}%",
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const Text("Выполнено", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // --- КАРТОЧКИ ОБЩЕЙ СТАТИСТИКИ ---
            Row(
              children: [
                _buildSmallStatCard("Всего", "$total", Icons.assignment, Colors.blue),
                const SizedBox(width: 15),
                _buildSmallStatCard("Сделано", "$completed", Icons.done_all, Colors.green),
              ],
            ),

            const SizedBox(height: 30),

            // --- СЕКЦИЯ КАТЕГОРИЙ ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("По категориям", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            
            _buildCategoryRow("Работа", tasks, Colors.blue),
            _buildCategoryRow("Личное", tasks, Colors.orange),
            _buildCategoryRow("Учеба", tasks, Colors.purple),
            _buildCategoryRow("Спорт", tasks, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String title, List<Task> allTasks, Color color) {
    final catTasks = allTasks.where((t) => t.category == title).toList();
    final done = catTasks.where((t) => t.isCompleted).length;
    final total = catTasks.length;
    final progress = total == 0 ? 0.0 : done / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("$done / $total", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: color.withOpacity(0.1),
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}