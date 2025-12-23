import '../entities/tourist.dart';
import 'dart:io';

abstract class TouristRepository {
  Future<Map<String, dynamic>> registerTourist(Tourist tourist, File kycFile);
  Future<Map<String, dynamic>> loginTourist(String email, String password);

  Future<Tourist> getTouristById(String touristId);

 Future<void> forgotPassword(String email);


}
