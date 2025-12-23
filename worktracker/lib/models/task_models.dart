import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String id;
  final String title;
  bool isCompleted;
  final String category;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    isCompleted: json['isCompleted'],
    category: json['category'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class TaskModels extends ChangeNotifier {
  List<Task> _tasks = [];
  String _selectedCategory = 'Все'; 

  TaskModels() {
    _loadTasks();
  }

  List<Task> get allTasks => _tasks;
  String get selectedCategory => _selectedCategory;

  // Геттер с фильтрацией: если выбрано "Все", отдаем весь список
  List<Task> get filteredTasks {
    if (_selectedCategory == "Все") {
      return _tasks;
    }
    return _tasks.where((task) => task.category == _selectedCategory).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addTask(String title) {
    if (title.isEmpty) return;

    // Если находимся во вкладке "Все", создаем задачу в "Работа" по умолчанию
    String targetCategory = _selectedCategory == "Все" ? "Работа" : _selectedCategory;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: targetCategory,
      createdAt: DateTime.now(),
      isCompleted: false,
    );

    _tasks.insert(0, newTask);
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString('saved_tasks_list', encodedData);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('saved_tasks_list');
    if (savedData != null) {
      final List<dynamic> decodedData = json.decode(savedData);
      _tasks = decodedData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    }
  }
}