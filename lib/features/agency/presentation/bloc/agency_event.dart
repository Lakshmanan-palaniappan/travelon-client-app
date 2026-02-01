abstract class AgencyEvent {}

class LoadAgencies extends AgencyEvent {}
class FetchAgencyDetails extends AgencyEvent {
  final int id;
  FetchAgencyDetails(this.id);
}