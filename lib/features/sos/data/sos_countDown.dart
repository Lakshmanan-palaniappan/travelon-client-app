import 'package:shared_preferences/shared_preferences.dart';

class SosCooldownStorage {
  static const _key = "sos_cooldown_end";

  static Future<void> saveEnd(DateTime end) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, end.millisecondsSinceEpoch);
  }

  static Future<DateTime?> loadEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_key);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
