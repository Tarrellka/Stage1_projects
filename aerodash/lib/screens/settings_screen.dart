import 'package:flutter/material.dart';
import '../services/log_service.dart';
import '../game/game_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GameSettings _settings = GameSettings();

  final List<Map<String, dynamic>> configItems = const [
    {'name': 'Тяга двигателя', 'icon': Icons.speed},
    {'name': 'Гравитация', 'icon': Icons.arrow_downward},
    {'name': 'Частота препятствий', 'icon': Icons.grid_view},
    {'name': 'Скорость полета', 'icon': Icons.fast_forward},
    {'name': 'Размер самолета', 'icon': Icons.photo_size_select_large},
  ];

  void _showEditDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _settings.currentValues[title]!,
                    onChanged: (newValue) {
                      // Обновляем слайдер внутри диалога
                      setModalState(() => _settings.updateField(title, newValue));
                      // Обновляем список на основном экране
                      setState(() {});
                      LogService.logSettingChange(title, newValue);
                    },
                  ),
                  Text("${(_settings.currentValues[title]! * 100).toInt()}%"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки физики'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Сбросить всё',
            onPressed: () {
              setState(() {
                _settings.reset();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки восстановлены')),
              );
              LogService.logGameEvent("Пользователь сбросил настройки");
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: configItems.length,
        itemBuilder: (context, index) {
          final item = configItems[index];
          final name = item['name'];
          final value = _settings.currentValues[name]!;

          return ListTile(
            leading: Icon(item['icon']),
            title: Text(name),
            subtitle: Text("Текущее значение: ${(value * 100).toInt()}%"),
            trailing: const Icon(Icons.edit, color: Colors.blue),
            onTap: () => _showEditDialog(name),
          );
        },
      ),
    );
  }
}