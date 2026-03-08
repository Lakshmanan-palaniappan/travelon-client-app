import 'package:shared_preferences/shared_preferences.dart';

/// ---------------------------------------------------------------------------
/// SosCooldownStorage
/// ---------------------------------------------------------------------------
/// A local storage utility for managing the SOS feature's cooldown period.
/// 
/// Uses [SharedPreferences] to persist the 'end time' of a cooldown,
/// ensuring the lockout remains active across app restarts.
/// ---------------------------------------------------------------------------
class SosCooldownStorage {
  static const _key = "sos_cooldown_end";

  /// -------------------------------------------------------------------------
  /// Persists the cooldown expiration timestamp.
  /// 
  /// Converts the [DateTime] to [millisecondsSinceEpoch] for integer storage.
  /// -------------------------------------------------------------------------
  static Future<void> saveEnd(DateTime end) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, end.millisecondsSinceEpoch);
  }

  /// -------------------------------------------------------------------------
  /// Retrieves the stored cooldown expiration timestamp.
  /// 
  /// Returns [null] if no cooldown is currently active in storage.
  /// -------------------------------------------------------------------------
  static Future<DateTime?> loadEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_key);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// -------------------------------------------------------------------------
  /// Removes the cooldown timestamp from local storage.
  /// 
  /// Typically called once the cooldown period has elapsed or when
  /// resetting the SOS state.
  /// -------------------------------------------------------------------------
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}