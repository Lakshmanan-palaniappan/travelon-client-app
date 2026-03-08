import '../entities/sos_alert.dart';

/// ---------------------------------------------------------------------------
/// SosAlertsRepository
/// ---------------------------------------------------------------------------
/// Abstract contract defining the operations for managing SOS alerts.
/// 
/// This interface resides in the Domain layer, acting as a bridge between 
/// the Use Cases and the underlying Data sources. It ensures the 
/// Business layer only interacts with the [SosAlert] entity.
/// ---------------------------------------------------------------------------
abstract class SosAlertsRepository {
  
  /// -------------------------------------------------------------------------
  /// Retrieves a chronological list of SOS alerts triggered by the 
  /// current authenticated user.
  /// 
  /// Returns a [Future] list of [SosAlert] entities, including GPS 
  /// coordinates and resolution status.
  /// -------------------------------------------------------------------------
  Future<List<SosAlert>> getMySosAlerts();
}