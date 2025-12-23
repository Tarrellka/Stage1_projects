import 'package:flutter/material.dart';
import '../game/settings_data.dart';
import '../services/logger_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("Настройки физики")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Настройка гравитации
          ListTile(
            title: const Text("Гравитация"),
            subtitle: Slider(
              value: AppSettings.gravity,
              min: 0, max: 3000,
              onChanged: (v) { 
                setState(() => AppSettings.gravity = v);
                LoggerService.logAction("Изменена гравитация: ${v.round()}");
              },
            ),
            trailing: Text(AppSettings.gravity.round().toString()),
          ),
          
          // Настройка отскока
          ListTile(
            title: const Text("Упругость (отскок)"),
            subtitle: Slider(
              value: AppSettings.bounce,
              min: 0.1, max: 1.0,
              onChanged: (v) => setState(() => AppSettings.bounce = v),
            ),
            trailing: Text(AppSettings.bounce.toStringAsFixed(1)),
          ),

          // Вкл/Выкл коллизии
          SwitchListTile(
            title: const Text("Столкновения шаров"),
            value: AppSettings.collisionsEnabled,
            onChanged: (v) { 
              setState(() => AppSettings.collisionsEnabled = v);
              LoggerService.logAction("Коллизии: ${v ? 'ВКЛ' : 'ВЫКЛ'}");
            },
          ),

          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Визуал", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          SwitchListTile(
            title: const Text("Случайные цвета"),
            value: AppSettings.randomColors,
            onChanged: (v) => setState(() => AppSettings.randomColors = v),
          ),
        ],
      ),
    );
  }
}