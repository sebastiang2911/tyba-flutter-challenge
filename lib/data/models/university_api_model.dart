import '../../domain/models/university.dart';

class UniversityApiModel {
  const UniversityApiModel({
    required this.name,
    required this.country,
    required this.alphaTwoCode,
    required this.domains,
    required this.webPages,
    this.stateProvince,
  });

  factory UniversityApiModel.fromJson(Map<String, dynamic> json) {
    return UniversityApiModel(
      name: json['name'] as String,
      country: json['country'] as String,
      alphaTwoCode: json['alpha_two_code'] as String,
      stateProvince: json['state-province'] as String?,
      domains: List<String>.from(json['domains'] as List),
      webPages: List<String>.from(json['web_pages'] as List),
    );
  }

  final String name;
  final String country;
  final String alphaTwoCode;
  final String? stateProvince;
  final List<String> domains;
  final List<String> webPages;

  University toDomain(int id) {
    return University(
      id: id,
      name: name,
      country: country,
      alphaTwoCode: alphaTwoCode,
      stateProvince: stateProvince,
      domains: domains,
      webPages: webPages,
    );
  }
}
