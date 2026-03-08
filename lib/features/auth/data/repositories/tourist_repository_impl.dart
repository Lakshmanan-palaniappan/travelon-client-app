import 'dart:io';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import '../../domain/entities/tourist.dart';
import '../../domain/repositories/tourist_repository.dart';
import '../models/tourist_model.dart';

/// ---------------------------------------------------------------------------
/// TouristRepositoryImpl
/// ---------------------------------------------------------------------------
/// The concrete implementation of [TouristRepository].
/// 
/// This class coordinates data between the [TouristRemoteDataSource] and 
/// the Domain layer. It handles the conversion between [TouristModel] (Data) 
/// and [Tourist] (Entity).
/// ---------------------------------------------------------------------------
class TouristRepositoryImpl implements TouristRepository {
  final TouristRemoteDataSource remoteDataSource;

  TouristRepositoryImpl(this.remoteDataSource);

  /// -------------------------------------------------------------------------
  /// registerTourist
  /// -------------------------------------------------------------------------
  /// Maps the [RegisterTouristEntity] into a [TouristModel] before sending 
  /// it to the remote data source along with the physical [kycFile].
  /// -------------------------------------------------------------------------
  @override
  Future<Map<String, dynamic>> registerTourist(
    RegisterTouristEntity data,
    File kycFile,
  ) {
    final model = TouristModel.fromRegisterEntity(data);

    return remoteDataSource.registerTourist(model, kycFile);
  }

  /// -------------------------------------------------------------------------
  /// loginTourist
  /// -------------------------------------------------------------------------
  /// Authenticates the user via the remote data source using credentials.
  /// -------------------------------------------------------------------------
  @override
  Future<Map<String, dynamic>> loginTourist(
    String email,
    String password,
  ) async {
    return await remoteDataSource.loginTourist(email, password);
  }

  /// -------------------------------------------------------------------------
  /// getTouristById
  /// -------------------------------------------------------------------------
  /// Fetches a tourist's profile and converts the resulting [TouristModel]
  /// into a pure [Tourist] entity for the Domain layer.
  /// -------------------------------------------------------------------------
  @override
  Future<Tourist> getTouristById(String touristId) async {
    final model = await remoteDataSource.getTouristById(touristId);
    return model.toEntity();
  }

  /// -------------------------------------------------------------------------
  /// forgotPassword
  /// -------------------------------------------------------------------------
  /// Triggers the password reset flow via the remote service.
  /// -------------------------------------------------------------------------
  @override
  Future<void> forgotPassword(String email) async {
    await remoteDataSource.forgotPassword(email);
  }

  /// -------------------------------------------------------------------------
  /// changePassword
  /// -------------------------------------------------------------------------
  /// Securely updates the user's password.
  /// -------------------------------------------------------------------------
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

  /// -------------------------------------------------------------------------
  /// updateTourist
  /// -------------------------------------------------------------------------
  /// Sends partial or full profile updates to the remote data source.
  /// -------------------------------------------------------------------------
  @override
  Future<void> updateTourist(
    String touristId,
    Map<String, dynamic> data,
  ) async {
    await remoteDataSource.updateTourist(touristId, data);
  }
}