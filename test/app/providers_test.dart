import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/app/providers.dart';
import 'package:tyba_technical_test/data/repositories/university_profile_repository_impl.dart';
import 'package:tyba_technical_test/data/repositories/university_repository_impl.dart';

void main() {
  test('builds the concrete infrastructure by default', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(universityRepositoryProvider),
      isA<UniversityRepositoryImpl>(),
    );
    expect(
      container.read(universityProfileRepositoryProvider),
      isA<InMemoryUniversityProfileRepository>(),
    );
  });

  test('keeps the same repository instance across reads', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(universityRepositoryProvider),
      same(container.read(universityRepositoryProvider)),
    );
  });
}
