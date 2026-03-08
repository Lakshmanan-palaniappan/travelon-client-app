import 'package:Travelon/features/agency/domain/entities/agency.dart';

/// ---------------------------------------------------------------------------
/// AgencyRepository
/// ---------------------------------------------------------------------------
/// Abstract contract defining the operations for managing travel agencies.
/// 
/// This interface resides in the Domain layer, acting as a bridge between 
/// the Use Cases and the underlying Data sources. It ensures the 
/// Business layer only interacts with the [Agency] entity.
/// ---------------------------------------------------------------------------
abstract class AgencyRepository {
  
  /// -------------------------------------------------------------------------
  /// Retrieves a list of all travel agencies available in the system.
  /// 
  /// Returns a [Future] list of [Agency] entities.
  /// -------------------------------------------------------------------------
  Future<List<Agency>> getAgencies();

  /// -------------------------------------------------------------------------
  /// Fetches comprehensive details for a specific agency.
  /// 
  /// Parameters:
  /// - [id]: The unique numeric identifier of the agency.
  /// 
  /// Returns a [Future] containing the [Agency] profile.
  /// -------------------------------------------------------------------------
  Future<Agency> getAgencyById(int id);
}