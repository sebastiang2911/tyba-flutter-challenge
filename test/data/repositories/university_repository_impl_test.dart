import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tyba_technical_test/data/repositories/university_repository_impl.dart';
import 'package:tyba_technical_test/data/services/universities_api_service.dart';
import 'package:tyba_technical_test/domain/failures/failure.dart';

Map<String, dynamic> _json(String name) => {
  'name': name,
  'country': 'United States',
  'alpha_two_code': 'US',
  'state-province': null,
  'domains': ['$name.edu'],
  'web_pages': ['http://$name.edu'],
};

UniversityRepositoryImpl _repo(MockClientHandler handler) =>
    UniversityRepositoryImpl(UniversitiesApiService(MockClient(handler)));

void main() {
  test('returns universities in source order with sequential ids', () async {
    final body = jsonEncode([_json('B'), _json('A'), _json('C')]);
    final repo = _repo((_) async => http.Response(body, 200));

    final universities = await repo.getUniversities();

    expect(universities.map((u) => u.name), ['B', 'A', 'C']);
    expect(universities.map((u) => u.id), [0, 1, 2]);
  });

  test('gives distinct ids to universities with duplicate names', () async {
    final body = jsonEncode([_json('Same'), _json('Same')]);
    final repo = _repo((_) async => http.Response(body, 200));

    final universities = await repo.getUniversities();

    expect(universities[0].id, isNot(universities[1].id));
  });

  test('maps all fields to the domain model', () async {
    final body = jsonEncode([_json('A')]);
    final repo = _repo((_) async => http.Response(body, 200));

    final university = (await repo.getUniversities()).single;

    expect(university.name, 'A');
    expect(university.country, 'United States');
    expect(university.alphaTwoCode, 'US');
    expect(university.stateProvince, isNull);
    expect(university.domains, ['A.edu']);
    expect(university.webPages, ['http://A.edu']);
  });

  test('throws Failure on a non-200 response', () {
    final repo = _repo((_) async => http.Response('', 500));

    expect(repo.getUniversities(), throwsA(isA<Failure>()));
  });

  test('throws Failure on a network error', () {
    final repo = _repo((_) async => throw http.ClientException('offline'));

    expect(repo.getUniversities(), throwsA(isA<Failure>()));
  });

  test('throws Failure on a malformed payload', () {
    final repo = _repo((_) async => http.Response('{}', 200));

    expect(repo.getUniversities(), throwsA(isA<Failure>()));
  });
}
