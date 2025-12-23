import 'package:flutter/material.dart';
import '../core/constants.dart';

class WorkbenchScreen extends StatefulWidget {
  final int wood; final int stone;
  final List<String> unlockedTools; final bool hasFurnace;
  const WorkbenchScreen({super.key, required this.wood, required this.stone, required this.unlockedTools, required this.hasFurnace});
  @override State<WorkbenchScreen> createState() => _WorkbenchScreenState();
}

class _WorkbenchScreenState extends State<WorkbenchScreen> {
  late int wood; late int stone;
  late List<String> unlockedTools; late bool hasFurnace;

  @override void initState() {
    super.initState();
    wood = widget.wood; stone = widget.stone;
    unlockedTools = List.from(widget.unlockedTools);
    hasFurnace = widget.hasFurnace;
  }

  void _buy(String name, int w, int s, {bool furnace = false}) {
    if (wood >= w && stone >= s) {
      setState(() {
        wood -= w; stone -= s;
        if (furnace) hasFurnace = true; else unlockedTools.add(name);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Недостаточно ресурсов!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("ВЕРСТАК"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context, {'wood': wood, 'stone': stone, 'unlockedTools': unlockedTools, 'hasFurnace': hasFurnace})),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item("Кам. Топор", "Stone Hatchet", 100, 50, AppAssets.stoneHatchet, unlockedTools.contains("Stone Hatchet")),
          _item("Кам. Кирка", "Stone Pickaxe", 100, 50, AppAssets.stonePickaxe, unlockedTools.contains("Stone Pickaxe")),
          _item("Печка", "", 300, 500, AppAssets.furnace, hasFurnace, isF: true),
          _item("Жел. Топор", "Metal Hatchet", 500, 200, AppAssets.hatchet, unlockedTools.contains("Metal Hatchet")),
          _item("Жел. Кирка", "Metal Pickaxe", 500, 200, AppAssets.pickaxe, unlockedTools.contains("Metal Pickaxe")),
        ],
      ),
    );
  }

  Widget _item(String title, String id, int w, int s, String img, bool bought, {bool isF = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Image.asset(img, width: 50),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(bought ? "КУПЛЕНО" : "Цена: $w дерева, $s камня", style: TextStyle(color: bought ? Colors.green : Colors.orange, fontSize: 11)),
        ])),
        if (!bought) ElevatedButton(onPressed: () => _buy(id, w, s, furnace: isF), child: const Text("КРАФТ"))
      ]),
    );
  }
}