import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GpsState {
  final LatLng? location;
  final bool loading;

  const GpsState({this.location, this.loading = false});
}

class GpsCubit extends Cubit<GpsState> {
  GpsCubit() : super(const GpsState());

  Future<void> fetchCurrentLocation(BuildContext context) async {
    try {
      emit(const GpsState(loading: true));

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ErrorFlash.show(context, message: "Location service disabled");
        emit(const GpsState());
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ErrorFlash.show(context, message: "Location permission denied");
        emit(const GpsState());
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      emit(GpsState(
        location: LatLng(pos.latitude, pos.longitude),
      ));
    } catch (_) {
      emit(const GpsState());
      ErrorFlash.show(context, message: "Failed to get GPS location");
    }
  }
}
