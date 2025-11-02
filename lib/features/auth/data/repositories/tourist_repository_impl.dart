import 'dart:io';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import '../../domain/entities/tourist.dart';
import '../../domain/repositories/tourist_repository.dart';
import '../models/tourist_model.dart';

class TouristRepositoryImpl implements TouristRepository {
  final TouristRemoteDataSource remoteDataSource;

  TouristRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> registerTourist(Tourist tourist, File kycFile) {
    final model = TouristModel(
      name: tourist.name,
      nationality: tourist.nationality,
      contact: tourist.contact,
      email: tourist.email,
      gender: tourist.gender,
      kycType: tourist.kycType,
      emergencyContact: tourist.emergencyContact,
      address: tourist.address,
      password: tourist.password,
      agencyId: tourist.agencyId,
      kycNo: tourist.kycNo,
    );
    return remoteDataSource.registerTourist(model, kycFile);
  }

  @override
  Future<Map<String, dynamic>> loginTourist(String email, String password) async {
    // You can directly call the data source here
    return await remoteDataSource.loginTourist(email, password);
  }
}
