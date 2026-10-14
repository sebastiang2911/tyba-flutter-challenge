import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tyba_technical_test/data/services/universities_api_service.dart';

Map<String, dynamic> _json(String name, {String? state}) => {
  'name': name,
  'country': 'United States',
  'alpha_two_code': 'US',
  'state-province': state,
  'domains': ['$name.edu'],
  'web_pages': ['http://$name.edu'],
};

UniversitiesApiService _service(MockClientHandler handler) =>
    UniversitiesApiService(MockClient(handler));

void main() {
  test('requests the universities endpoint', () async {
    Uri? requested;
    final service = _service((request) async {
      requested = request.url;
      return http.Response('[]', 200);
    });

    await service.fetchUniversities();

    expect(requested, UniversitiesApiService.endpoint);
  });

  test('parses every field of an entry', () async {
    final body = jsonEncode([_json('A', state: 'Texas')]);
    final service = _service((_) async => http.Response(body, 200));

    final models = await service.fetchUniversities();

    expect(models, hasLength(1));
    expect(models.single.name, 'A');
    expect(models.single.country, 'United States');
    expect(models.single.alphaTwoCode, 'US');
    expect(models.single.stateProvince, 'Texas');
    expect(models.single.domains, ['A.edu']);
    expect(models.single.webPages, ['http://A.edu']);
  });

  test('accepts a null state-province', () async {
    final body = jsonEncode([_json('A')]);
    final service = _service((_) async => http.Response(body, 200));

    final models = await service.fetchUniversities();

    expect(models.single.stateProvince, isNull);
  });

  test('decodes UTF-8 bodies', () async {
    final body = jsonEncode([_json('Universidad de Córdoba')]);
    final service = _service(
      (_) async => http.Response.bytes(utf8.encode(body), 200),
    );

    final models = await service.fetchUniversities();

    expect(models.single.name, 'Universidad de Córdoba');
  });

  test('throws on a non-200 response', () {
    final service = _service((_) async => http.Response('', 500));

    expect(service.fetchUniversities(), throwsA(isA<http.ClientException>()));
  });

  test('throws on a malformed payload', () {
    final service = _service((_) async => http.Response('{}', 200));

    expect(service.fetchUniversities(), throwsA(anything));
  });
}
