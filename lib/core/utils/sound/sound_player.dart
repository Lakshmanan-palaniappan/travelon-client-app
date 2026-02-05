import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  static final AudioPlayer _player = AudioPlayer();

  // 🔊 Looping geofence warning
  static Future<void> playGeofenceWarningLoop() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop); // 🔁 loop
      await _player.play(AssetSource('sounds/geo_warning.mp3'));
    } catch (e) {
      print("🔊 Geofence sound error: $e");
    }
  }

  // 🔊 One-shot SOS (your existing)
  static Future<void> playSosAlert() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.stop); // play once
      await _player.play(AssetSource('sounds/sos_help.mp3'));
    } catch (e) {
      print("🔊 SOS sound error: $e");
    }
  }

  // 🛑 Stop any sound
  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }
}
