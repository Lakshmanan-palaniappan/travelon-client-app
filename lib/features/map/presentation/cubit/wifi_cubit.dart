import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'wifi_state.dart';
import '../../domain/entities/wifi_access_point.dart';

class WifiCubit extends Cubit<WifiState> {
  WifiCubit() : super(const WifiState());

  Future<void> scan() async {
    emit(state.copyWith(loading: true));

    final canScan = await WiFiScan.instance.canStartScan();
    if (canScan != CanStartScan.yes) {
      emit(state.copyWith(loading: false));
      return;
    }

    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();

    final wifiList = results
        .where((r) => r.bssid.isNotEmpty)
        .map(
          (r) => WifiAccessPoint(
            bssid: r.bssid,
            level: r.level,
          ),
        )
        .toList();

    emit(
      state.copyWith(
        accessPoints: wifiList,
        loading: false,
      ),
    );
  }

  void clear() => emit(const WifiState());
}
