import 'dart:async';
import 'package:Travelon/features/map/data/datasource/location_remote_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationSyncCubit extends Cubit<void> {
  final LocationRemoteDataSource remote;
  Timer? _timer;

  LocationSyncCubit(this.remote) : super(null);

  void start({required int touristId, required LatLng Function() getGps}) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final gps = getGps();
      if (gps == null) return;
      print("🔥🔥🔥🔥🔥🔥");
      await remote.sendLocation(
        touristId: touristId,
        gps: {"lat": gps.latitude, "lng": gps.longitude},
      );
      print("🐬🐬🐬🐬🐬🐬");
    });
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
