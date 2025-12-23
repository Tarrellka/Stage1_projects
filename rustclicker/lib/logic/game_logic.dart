import '../models/tool_model.dart';
import '../core/constants.dart';

class GameLogic {
  int wood = 0, stone = 0, metal = 0;
  List<String> unlockedTools = ["Rock"];
  bool hasFurnace = false;

  String currentBiome = "Лес";
  String currentResourceType = "wood";
  String currentResourceAsset = AppAssets.wood;
  late Tool activeTool;

  GameLogic() {
    activeTool = Tool.rock(AppAssets.rock);
  }

  String? checkToolRequirement() {
    final type = activeTool.type;
    if (currentResourceType == "wood" && type == ToolType.pickaxe) return "Нужен топор!";
    if (currentResourceType == "stone" && type == ToolType.hatchet) return "Нужна кирка!";
    if (currentResourceType == "metal") {
      if (!hasFurnace) return "Нужна печка!";
      if (type == ToolType.hatchet) return "Топором нельзя!";
      if (!activeTool.isMetal) return "Нужна железная кирка!";
    }
    return null;
  }

  void addResource() {
    int amount = activeTool.power;
    // Множители биомов
    if (currentBiome == "Пустыня" && currentResourceType == "stone") amount *= 2;
    if (currentBiome == "Арктика" && currentResourceType == "metal") amount *= 2;

    if (currentResourceType == "wood") wood += amount;
    else if (currentResourceType == "stone") stone += amount;
    else if (currentResourceType == "metal") metal += amount;
  }

  void updateState(Map<String, dynamic> data) {
    wood = data['wood'] ?? wood;
    stone = data['stone'] ?? stone;
    unlockedTools = data['unlockedTools'] ?? unlockedTools;
    hasFurnace = data['hasFurnace'] ?? hasFurnace;
  }
}