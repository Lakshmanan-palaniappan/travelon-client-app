import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GpsState {
  final LatLng? location;
  final double accuracy;
  final bool loading;

  GpsState({
    this.location,
    this.accuracy = 0,
    this.loading = false,
  });
}


class GpsCubit extends Cubit<GpsState> {
  GpsCubit() : super(GpsState());

  Future<void> fetchCurrentLocation(BuildContext context) async {
    try {
      emit(GpsState(loading: true));

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ErrorFlash.show(context, message: "Location service disabled");
        emit(GpsState());
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ErrorFlash.show(context, message: "Location permission denied");
        emit(GpsState());
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      emit(GpsState(
        location: LatLng(pos.latitude, pos.longitude),
        accuracy: pos.accuracy, // ✅ FIX
        loading: false,
      ));
    } catch (_) {
      emit(GpsState());
      ErrorFlash.show(context, message: "Failed to get GPS location");
    }
  }
}

