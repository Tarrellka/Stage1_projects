import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_models.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskModels>(context);
    final theme = Theme.of(context);

    final total = taskProvider.filteredTasks.length;
    final completed = taskProvider.filteredTasks.where((t) => t.isCompleted).length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Задачи", style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    taskProvider.selectedCategory == "Все" 
                      ? "Общий список дел" 
                      : "Категория: ${taskProvider.selectedCategory}",
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  _categoryCard(context, "Все", Icons.auto_awesome_mosaic_outlined, taskProvider),
                  _categoryCard(context, "Работа", Icons.work_outline, taskProvider),
                  _categoryCard(context, "Личное", Icons.person_outline, taskProvider),
                  _categoryCard(context, "Учеба", Icons.school, taskProvider),
                  _categoryCard(context, "Спорт", Icons.fitness_center, taskProvider),
                ],
              ),
            ),

            Expanded(
              child: taskProvider.filteredTasks.isEmpty 
                ? _buildEmptyState() 
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: taskProvider.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.filteredTasks[index];
                      return _taskCard(task, taskProvider, theme);
                    },
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context, taskProvider),
        label: const Text("Добавить"),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF3366FF),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _categoryCard(BuildContext context, String title, IconData icon, TaskModels provider) {
    bool isSelected = provider.selectedCategory == title;
    return GestureDetector(
      onTap: () => provider.setCategory(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3366FF) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 26),
            const SizedBox(height: 6),
            Text(
              title, 
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskCard(task, provider, theme) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
        side: BorderSide(color: Colors.grey.withOpacity(0.1))
      ),
      child: ListTile(
        leading: Checkbox(
          shape: const CircleBorder(),
          value: task.isCompleted,
          onChanged: (_) => provider.toggleTaskStatus(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: provider.selectedCategory == "Все" 
          ? Text(task.category, style: const TextStyle(fontSize: 10, color: Colors.blue))
          : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          onPressed: () => provider.deleteTask(task.id),
        ),
      ),
    );
  }

    Widget _buildEmptyState() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заменили на стандартную иконку списка
              Icon(
                Icons.checklist_rtl_rounded, 
                size: 60, 
                color: Colors.grey.withOpacity(0.3)
              ),
              const SizedBox(height: 10),
              const Text(
                "Список пуст", 
                style: TextStyle(color: Colors.grey, fontSize: 16)
              ),
            ],
          ),
        );
      }

  void _showAddTaskDialog(BuildContext context, TaskModels provider) {
    final controller = TextEditingController();
    String currentCat = provider.selectedCategory == "Все" ? "Работа" : provider.selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Добавить задачу в '$currentCat'", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Напишите что-нибудь...",
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { 
                  provider.addTask(controller.text); 
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                child: const Text("Сохранить", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}