import '../entities/tourist.dart';
import 'dart:io';

abstract class TouristRepository {
  Future<Map<String, dynamic>> registerTourist(Tourist tourist, File kycFile);
}
