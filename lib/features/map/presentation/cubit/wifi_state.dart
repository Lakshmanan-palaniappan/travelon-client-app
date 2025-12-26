import 'package:meta/meta.dart';
import '../../domain/entities/wifi_access_point.dart';

@immutable
class WifiState {
  final List<WifiAccessPoint> accessPoints;
  final bool loading;

  const WifiState({
    this.accessPoints = const [],
    this.loading = false,
  });

  WifiState copyWith({
    List<WifiAccessPoint>? accessPoints,
    bool? loading,
  }) {
    return WifiState(
      accessPoints: accessPoints ?? this.accessPoints,
      loading: loading ?? this.loading,
    );
  }
}
