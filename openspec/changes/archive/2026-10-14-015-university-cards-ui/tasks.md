# Tasks

## 1. Card theme

- [ ] 1.1 Update `cardTheme` in `lib/app/theme.dart` (elevation, radius, surface color) and verify `flutter analyze` is clean and detail screen cards still look correct on `flutter run`

## 2. List and grid cards

- [x] 2.1 Rework `UniversityTile` as a card (Card + InkWell + ListTile, larger avatar, margins) and verify `university_tile_test.dart` covers card presence, name, country, chevron and tap
- [x] 2.2 Rework `UniversityCard` as a centered card and update the grid extent in `universities_content.dart`; verify `university_card_test.dart` covers content, tap, and a long name at text scale 2.0 with no overflow
- [x] 2.3 Verify hero transition to detail still works in both layouts via `flutter run` and that `flutter test` passes in full
