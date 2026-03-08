/// ---------------------------------------------------------------------------
/// WifiAccessPoint
/// ---------------------------------------------------------------------------
/// A domain entity representing a single Wi-Fi signal snapshot.
/// 
/// This class is used as a data point for Wi-Fi fingerprinting and 
/// indoor positioning systems.
/// ---------------------------------------------------------------------------
class WifiAccessPoint {
  /// The unique hardware identifier (MAC address) of the Wi-Fi router.
  final String bssid;

  /// The signal strength indicator (RSSI), typically measured in dBm.
  /// Lower numbers (e.g., -90) indicate a weaker signal, while numbers 
  /// closer to 0 (e.g., -30) indicate a very strong signal.
  final int level;

  WifiAccessPoint({
    required this.bssid,
    required this.level,
  });
}