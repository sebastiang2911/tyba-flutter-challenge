import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/university_profile_repository_impl.dart';
import '../data/repositories/university_repository_impl.dart';
import '../data/services/image_picker_service.dart';
import '../data/services/universities_api_service.dart';
import '../domain/repositories/university_profile_repository.dart';
import '../domain/repositories/university_repository.dart';

part 'providers.g.dart';

/// Disables Riverpod's automatic retry: failures surface at once and the user
/// retries manually, as before the migration.
Duration? noRetry(int retryCount, Object error) => null;

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
UniversitiesApiService universitiesApiService(Ref ref) =>
    UniversitiesApiService(ref.watch(httpClientProvider));

@Riverpod(keepAlive: true)
ImagePickerService imagePickerService(Ref ref) => ImagePickerService();

@Riverpod(keepAlive: true)
UniversityRepository universityRepository(Ref ref) =>
    UniversityRepositoryImpl(ref.watch(universitiesApiServiceProvider));

@Riverpod(keepAlive: true)
UniversityProfileRepository universityProfileRepository(Ref ref) =>
    InMemoryUniversityProfileRepository(ref.watch(imagePickerServiceProvider));
