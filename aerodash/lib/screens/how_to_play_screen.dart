import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Как играть')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: Icon(Icons.touch_app, color: Colors.blue),
            title: Text('Управление'),
            subtitle: Text('Нажимайте на экран, чтобы самолет набирал высоту. Отпустите, чтобы он начал снижаться.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('Настройки'),
            subtitle: Text('В меню настроек вы можете изменить 5 физических параметров, которые влияют на сложность полета.'),
          ),
          ListTile(
            leading: Icon(Icons.warning_amber, color: Colors.red),
            title: Text('Цель'),
            subtitle: Text('Уворачивайтесь от препятствий. Каждое столкновение завершает игру.'),
          ),
        ],
      ),
    );
  }
}