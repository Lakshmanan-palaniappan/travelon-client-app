import 'package:Travelon/features/agency/domain/entities/agency.dart';

abstract class AgencyState {}

class AgencyInitial extends AgencyState {}

class AgencyLoading extends AgencyState {}

class AgencyLoaded extends AgencyState {
  final List<Agency> agencies;
  AgencyLoaded(this.agencies);
}

class AgencyError extends AgencyState {
  final String message;
  AgencyError(this.message);
}
class AgencyDetailLoaded extends AgencyState {
  final Agency agency;
  AgencyDetailLoaded(this.agency);
}

