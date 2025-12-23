import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/tool_model.dart';
import '../widgets/flying_text.dart';
import '../logic/game_logic.dart';
import '../logic/save_service.dart';
import 'backpack_screen.dart';
import 'workbench_screen.dart';
import 'map_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final GameLogic gameLogic = GameLogic();
  List<Widget> damageNumbers = [];
  late AnimationController _hitController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initGame();
    _hitController = AnimationController(vsync: this, duration: const Duration(milliseconds: 50));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_hitController);
  }

  Future<void> _initGame() async {
    final data = await SaveService.loadGame();
    setState(() => gameLogic.updateState(data));
  }

  void _triggerSave() {
    SaveService.saveGame(
      gameLogic.wood,
      gameLogic.stone,
      gameLogic.metal,
      gameLogic.unlockedTools,
      gameLogic.hasFurnace,
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text("СБРОС ПРОГРЕССА", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text("Вы уверены? Весь накопленный лут и инструменты исчезнут навсегда."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ОТМЕНА")),
          TextButton(
            onPressed: () async {
              await SaveService.clearGame();
              if (mounted) {
                Navigator.pop(context);
                setState(() {
                  gameLogic.wood = 0;
                  gameLogic.stone = 0;
                  gameLogic.metal = 0;
                  gameLogic.unlockedTools = ["Rock"];
                  gameLogic.hasFurnace = false;
                  gameLogic.activeTool = Tool.rock(AppAssets.rock);
                });
              }
            },
            child: const Text("СБРОСИТЬ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addDamageNumber(double x, double y, String text, Color color) {
    Key key = UniqueKey();
    setState(() => damageNumbers.add(FlyingText(
      key: key, x: x, y: y, value: text, color: color,
      onComplete: () => setState(() => damageNumbers.removeWhere((e) => e.key == key)),
    )));
  }

  void _handleTap(TapDownDetails details) {
    final error = gameLogic.checkToolRequirement();
    if (error == null) {
      _hitController.forward().then((_) => _hitController.reverse());
      setState(() {
        gameLogic.addResource();
        _addDamageNumber(details.globalPosition.dx, details.globalPosition.dy, "+${gameLogic.activeTool.power}", Colors.greenAccent);
        _triggerSave();
      });
    } else {
      _addDamageNumber(details.globalPosition.dx, details.globalPosition.dy, error, Colors.redAccent);
    }
  }

  Future<void> _openBackpack() async {
    final selected = await Navigator.push(context, MaterialPageRoute(
      builder: (_) => BackpackScreen(unlockedTools: gameLogic.unlockedTools)
    ));
    if (selected != null) {
      setState(() {
        final name = selected['name'] as String;
        final img = selected['image'] as String;
        if (name == "Rock") {
          gameLogic.activeTool = Tool.rock(img);
        } else {
          gameLogic.activeTool = Tool(
            name: name, image: img,
            type: name.contains("Hatchet") ? ToolType.hatchet : ToolType.pickaxe,
            power: name.contains("Metal") ? 10 : 3,
            isMetal: name.contains("Metal"),
          );
        }
        _triggerSave();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _handleTap,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTopBar(),
                  const Spacer(),
                  Text(gameLogic.currentBiome.toUpperCase(), 
                    style: const TextStyle(color: Colors.white24, letterSpacing: 8, fontSize: 10)),
                  const SizedBox(height: 10),
                  ScaleTransition(scale: _scaleAnimation, child: Image.asset(gameLogic.currentResourceAsset, width: 220)),
                  const Spacer(),
                  _buildBottomMenu(),
                ],
              ),
            ),
            IgnorePointer(child: Stack(children: damageNumbers)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      children: [
        _buildStat("wood", AppAssets.wood, gameLogic.wood, Colors.brown),
        const SizedBox(width: 8),
        _buildStat("stone", AppAssets.stones, gameLogic.stone, Colors.grey),
        const SizedBox(width: 8),
        _buildStat("metal", AppAssets.metalFragments, gameLogic.metal, Colors.blueGrey),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white24, size: 20),
          onPressed: _showResetDialog,
        ),
      ],
    ),
  );

  Widget _buildStat(String type, String asset, int count, Color color) {
    final active = gameLogic.currentResourceType == type;
    return GestureDetector(
      onTap: () => setState(() { 
        gameLogic.currentResourceType = type; 
        gameLogic.currentResourceAsset = asset; 
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.3) : Colors.black26,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? color : Colors.transparent)
        ),
        child: Row(children: [
          Image.asset(asset, width: 18),
          const SizedBox(width: 5),
          Text("$count", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))
        ]),
      ),
    );
  }

  Widget _buildBottomMenu() => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _btn(AppAssets.backpack, _openBackpack),
        _activeSlot(),
        _btn(AppAssets.workbench, () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => WorkbenchScreen(
            wood: gameLogic.wood, stone: gameLogic.stone, unlockedTools: gameLogic.unlockedTools, hasFurnace: gameLogic.hasFurnace
          )));
          if (res != null) {
            setState(() { gameLogic.updateState(res); _triggerSave(); });
          }
        }),
        _btn(AppAssets.map, () async {
          final b = await Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(
            hasFurnace: gameLogic.hasFurnace, unlockedTools: gameLogic.unlockedTools
          )));
          if (b != null) setState(() => gameLogic.currentBiome = b);
        }),
      ],
    ),
  );

  Widget _activeSlot() => Container(
    width: 60, height: 60, 
    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.orange, width: 2)),
    child: Image.asset(gameLogic.activeTool.image, scale: 1.5)
  );

  Widget _btn(String asset, VoidCallback fn) => IconButton(icon: Image.asset(asset, width: 40), onPressed: fn);
}