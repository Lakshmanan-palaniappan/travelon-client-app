import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';

class GetAssignedEmployee {
  final TripRepository repository;

  GetAssignedEmployee(this.repository);

  Future<AssignedEmployee?> call() {
    return repository.getAssignedEmployee();
  }
}
