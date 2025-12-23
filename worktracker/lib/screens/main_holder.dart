import 'package:flutter/material.dart';
import 'tasks_screen.dart';
import 'timer_screen.dart';
import 'stats_screen.dart';

class MainHolder extends StatefulWidget {
  const MainHolder({super.key});

  @override
  State<MainHolder> createState() => _MainHolderState();
}

class _MainHolderState extends State<MainHolder> {
  int _selectedIndex = 0;

  // Список экранов константный, чтобы не пересоздавать их зря
  final List<Widget> _screens = const [
    TasksScreen(),
    TimerScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Задачи"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Фокус"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Отчет"),
        ],
      ),
    );
  }
}