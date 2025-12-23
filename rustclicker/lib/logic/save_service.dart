import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  static const String _woodKey = 'wood';
  static const String _stoneKey = 'stone';
  static const String _metalKey = 'metal';
  static const String _toolsKey = 'unlocked_tools';
  static const String _furnaceKey = 'has_furnace';

// Полная очистка данных
  static Future<void> clearGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Сохранение всех данных
  static Future<void> saveGame(int wood, int stone, int metal, List<String> tools, bool furnace) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_woodKey, wood);
    await prefs.setInt(_stoneKey, stone);
    await prefs.setInt(_metalKey, metal);
    await prefs.setStringList(_toolsKey, tools);
    await prefs.setBool(_furnaceKey, furnace);
  }

  // Загрузка данных
  static Future<Map<String, dynamic>> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'wood': prefs.getInt(_woodKey) ?? 0,
      'stone': prefs.getInt(_stoneKey) ?? 0,
      'metal': prefs.getInt(_metalKey) ?? 0,
      'unlockedTools': prefs.getStringList(_toolsKey) ?? ["Rock"],
      'hasFurnace': prefs.getBool(_furnaceKey) ?? false,
    };
  }
}