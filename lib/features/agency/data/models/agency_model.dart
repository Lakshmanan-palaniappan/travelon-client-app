import '../../domain/entities/agency.dart';

class AgencyModel extends Agency {
  AgencyModel({required super.id, required super.name});

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(id: json['AgencyId'], name: json['AgencyName']);
  }
}
