import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/university_api_model.dart';

class UniversitiesApiService {
  UniversitiesApiService(this._client);

  static final Uri endpoint = Uri.parse(
    'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json',
  );

  final http.Client _client;

  /// Fetches the raw universities. Throws on non-200 or unparsable payloads.
  Future<List<UniversityApiModel>> fetchUniversities() async {
    final response = await _client.get(endpoint);
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Unexpected status ${response.statusCode}',
        endpoint,
      );
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(UniversityApiModel.fromJson)
        .toList(growable: false);
  }
}
