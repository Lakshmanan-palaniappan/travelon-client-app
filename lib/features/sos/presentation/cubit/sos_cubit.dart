import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Travelon/features/sos/data/sos_api.dart';
import 'sos_state.dart';

class SosCubit extends Cubit<SosState> {
  final SosApi sosApi;

  SosCubit(this.sosApi) : super(SosInitial());

  Future<void> trigger({
    required List<Map<String, dynamic>> wifiAccessPoints,
    required double? lat,
    required double? lng,
    required double? accuracy,
    String? message,
  }) async {
    try {
      emit(SosSending());

      final gps =
          (lat != null && lng != null)
              ? {"lat": lat, "lng": lng, "accuracy": accuracy?.round() ?? 0}
              : null;

       await sosApi.triggerSOS(
        wifiAccessPoints: wifiAccessPoints,
        gps: gps,
        message: message,
      );
      print("🚑🚑🚑🚑🚑 SOS sent Successfully");
      
      emit(SosSuccess(gps != null ? "gps" : "wifi"));
    } catch (e) {
      emit(SosError(e.toString()));
    }
  }
}
