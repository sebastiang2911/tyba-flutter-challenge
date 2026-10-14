import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app/app.dart';
import 'data/repositories/university_profile_repository_impl.dart';
import 'data/repositories/university_repository_impl.dart';
import 'data/services/image_picker_service.dart';
import 'data/services/universities_api_service.dart';

void main() {
  final repository = UniversityRepositoryImpl(
    UniversitiesApiService(http.Client()),
  );
  final profileRepository = InMemoryUniversityProfileRepository(
    ImagePickerService(),
  );
  runApp(App(repository: repository, profileRepository: profileRepository));
}
