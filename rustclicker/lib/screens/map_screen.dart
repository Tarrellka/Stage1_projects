import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  final bool hasFurnace;
  final List<String> unlockedTools;

  const MapScreen({
    super.key, 
    required this.hasFurnace, 
    required this.unlockedTools
  });

  @override
  Widget build(BuildContext context) {
    bool hasPickaxe = unlockedTools.contains("Stone Pickaxe") || 
                      unlockedTools.contains("Metal Pickaxe");
    
    bool arcticUnlocked = hasFurnace && hasPickaxe;

    String arcticHint;
    if (arcticUnlocked) {
      arcticHint = "Больше металла (x2)";
    } else {
      List<String> missing = [];
      if (!hasFurnace) missing.add("Печка");
      if (!hasPickaxe) missing.add("Кирка");
      arcticHint = "Нужно: ${missing.join(' и ')}";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("КАРТА МИРА", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildBiomeCard(context, "Лес", "Базовая локация", Icons.forest, Colors.green, true),
            _buildBiomeCard(context, "Пустыня", "Больше камня (x2)", Icons.landscape, Colors.orange, true),
            _buildBiomeCard(
              context, "Арктика", arcticHint, Icons.ac_unit, Colors.blue, arcticUnlocked,
              isError: !arcticUnlocked
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiomeCard(BuildContext context, String name, String subtitle, IconData icon, Color color, bool isUnlocked, {bool isError = false}) {
    return GestureDetector(
      onTap: isUnlocked ? () => Navigator.pop(context, name) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white10 : Colors.black38,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isUnlocked ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isUnlocked ? color : Colors.grey, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: isUnlocked ? Colors.white : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: isUnlocked ? Colors.white60 : (isError ? Colors.redAccent : Colors.grey), fontSize: 12)),
                ],
              ),
            ),
            if (!isUnlocked) const Icon(Icons.lock, color: Colors.grey, size: 20)
          ],
        ),
      ),
    );
  }
}