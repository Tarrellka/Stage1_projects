import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_models.dart';

class StorageService {
  static const String _tasksKey = 'user_tasks_list';
  static const String _focusKey = 'total_focus_minutes';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, encodedData);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_tasksKey);
    if (data == null || data.isEmpty) return [];
    final List<dynamic> decodedData = jsonDecode(data);
    return decodedData.map((item) => Task.fromJson(item)).toList();
  }

  static Future<void> addFocusTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_focusKey) ?? 0;
    await prefs.setInt(_focusKey, current + minutes);
  }

  static Future<int> getFocusTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_focusKey) ?? 0;
  }
}