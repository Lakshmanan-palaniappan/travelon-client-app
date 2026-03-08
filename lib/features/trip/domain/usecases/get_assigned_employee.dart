import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';

/// ---------------------------------------------------------------------------
/// GetAssignedEmployee
/// ---------------------------------------------------------------------------
/// Use case for retrieving the employee assigned to the current user's trip.
/// 
/// This class follows the Command Pattern, encapsulating the logic required
/// to fetch guide/employee details through the [TripRepository].
/// ---------------------------------------------------------------------------
class GetAssignedEmployee {
  final TripRepository repository;

  GetAssignedEmployee(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the use case.
  /// 
  /// Returns an [AssignedEmployee] if one is found, otherwise returns null.
  /// -------------------------------------------------------------------------
  Future<AssignedEmployee?> call() {
    return repository.getAssignedEmployee();
  }
}