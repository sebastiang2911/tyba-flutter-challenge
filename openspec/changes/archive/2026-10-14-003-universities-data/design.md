# Design

## Context

Layout and conventions are fixed by `001`/`002` and `CLAUDE.md`: Data (services, repositories, API models) and Domain (clean models, repository contracts) grouped by type, `ui ->` domain `<- data`. The source is one JSON array of 2178 entries with fields `name`, `country`, `alpha_two_code`, `state-province` (nullable), `domains[]`, `web_pages[]` and no id. See proposal.md for scope and the `universities-data` spec for behavior.

## Goals / Non-Goals

**Goals:**
- A domain-facing repository contract independent of HTTP and JSON.
- Identity/order guarantees from the spec implemented in exactly one place.
- Fully unit-tested without network access.

**Non-Goals:**
- State management, DI wiring, caching, retry, pagination (later changes).

## Decisions

**Files.**

```
lib/domain/models/university.dart
lib/domain/failures/failure.dart
lib/domain/repositories/university_repository.dart      abstract
lib/data/models/university_api_model.dart               fromJson, toDomain(id)
lib/data/services/universities_api_service.dart         HTTP GET, returns api models
lib/data/repositories/university_repository_impl.dart   assigns ids, maps errors
test/data/services/universities_api_service_test.dart
test/data/repositories/university_repository_impl_test.dart
```

**Service is stateless and raw.** `UniversitiesApiService(http.Client)` performs the GET, checks status 200, decodes UTF-8 and returns `List<UniversityApiModel>`; it throws on non-200 or parse errors. Per the skill, services return raw API models; mapping belongs to the repository.

**Id assignment in the repository only.** `UniversityRepositoryImpl` maps with `indexed`, so `id` equals the array index and the order is preserved. Alternative: assign ids in the API model (`fromJson(json, index)`), rejected because identity is a domain concern, not a serialization one.

**Single `Failure` type.** `Failure(message)` implements `Exception` with value equality. The repository catches everything from the service and throws `Failure('Could not load universities')`. Alternative: typed failure subclasses (network, parsing); rejected as unnecessary until the UI distinguishes them. It lives in `lib/domain/failures/` because the domain contract (`getUniversities`) declares it; this adds one folder not in `001`.

**Repository contract.** `Future<List<University>> getUniversities()`; documented to throw `Failure`. Alternative: a `Result<T>` wrapper, rejected to keep ViewModels simple (`try/catch` in one place).

**Endpoint as a constant in the service**, injectable `http.Client` for tests (`package:http/testing.dart` `MockClient`).

**No `provider` registration yet.** Nothing consumes the repository until the list ViewModel exists; wiring it now would add untested, unused setup.

## Risks / Trade-offs

- [Catch-all in the repository hides the root cause] -> Accepted for now; the message is generic and the original error is not leaked to the UI. A later change can add a `cause` field if logging is needed.
- [Whole list parsed on the main isolate (2178 entries)] -> Acceptable at this size; revisit with `compute` only if profiling shows jank.
- [New `domain/failures/` folder] -> Documented here and in `CLAUDE.md`'s layout line.

## Open Questions

None.
