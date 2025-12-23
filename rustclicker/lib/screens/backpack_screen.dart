import 'package:flutter/material.dart';
import '../core/constants.dart';

class BackpackScreen extends StatelessWidget {
  final List<String> unlockedTools;

  const BackpackScreen({super.key, required this.unlockedTools});

  @override
  Widget build(BuildContext context) {
    // Список всех возможных инструментов в игре (без админского)
    final allTools = [
      {'name': 'Rock', 'image': AppAssets.rock},
      {'name': 'Stone Hatchet', 'image': AppAssets.stoneHatchet},
      {'name': 'Stone Pickaxe', 'image': AppAssets.stonePickaxe},
      {'name': 'Metal Hatchet', 'image': AppAssets.hatchet},
      {'name': 'Metal Pickaxe', 'image': AppAssets.pickaxe},
    ];

    // Фильтруем только те, которые разблокированы игроком
    final tools = allTools.where((t) => unlockedTools.contains(t['name'])).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("РЮКЗАК", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black26,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        // Отображаем ровно столько слотов, сколько есть инструментов
        itemCount: tools.length, 
        itemBuilder: (context, index) {
          final tool = tools[index];
          return GestureDetector(
            onTap: () => Navigator.pop(context, tool),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(tool['image']!, width: 40),
                  const SizedBox(height: 5),
                  Text(
                    tool['name']!.split(' ').last, // Короткое название (например, Hatchet)
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}