import 'package:audioplayers/audioplayers.dart';

/// Service for playing alert sounds in the application.
///
/// Handles:
/// - Playing SOS alert sounds
/// - Playing geofence warning sounds
/// - Stopping active sound playback
class SoundPlayer {
  static final AudioPlayer _player = AudioPlayer();

  /// Plays the geofence warning sound in a continuous loop.
  static Future<void> playGeofenceWarningLoop() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('sounds/geo_warning.mp3'));
    } catch (e) {
      // Ignore audio playback errors (e.g., asset not loaded or player unavailable)
    }
  }

  /// Plays the SOS alert sound once.
  static Future<void> playSosAlert() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.stop); // play once
      await _player.play(AssetSource('sounds/sos_help.mp3'));
    } catch (e) {
      // Ignore playback error
    }
  }

  /// Stops any currently playing alert sound.
  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {
      // Ignore stop errors
    }
  }
}
