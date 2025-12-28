import 'dart:io';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import '../../domain/entities/tourist.dart';
import '../../domain/repositories/tourist_repository.dart';
import '../models/tourist_model.dart';

class TouristRepositoryImpl implements TouristRepository {
  final TouristRemoteDataSource remoteDataSource;

  TouristRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> registerTourist(
    RegisterTouristEntity data,
    File kycFile,
  ) {
    final model = TouristModel.fromRegisterEntity(data);

    return remoteDataSource.registerTourist(model, kycFile);
  }

  @override
  Future<Map<String, dynamic>> loginTourist(
    String email,
    String password,
  ) async {
    // You can directly call the data source here
    return await remoteDataSource.loginTourist(email, password);
  }

  // @override
  // Future<Tourist> getTouristById(String touristId) async {
  //   final data = await remoteDataSource.getTouristById(touristId);
  //   return TouristModel.fromJson(data);
  // }
  @override
  Future<Tourist> getTouristById(String touristId) async {
    final model = await remoteDataSource.getTouristById(touristId);
    return model.toEntity();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String touristId,
  }) {
    return remoteDataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      touristId: touristId,
    );
  }

  @override
  Future<void> updateTourist(
    String touristId,
    Map<String, dynamic> data,
  ) async {
    await remoteDataSource.updateTourist(touristId, data);
  }
}
