# Tasks

## 1. Theme and orientation

- [x] 1.1 Replace `buildAppTheme` with light/dark builders from the logo palette in `lib/app/theme.dart`
- [x] 1.2 Wire `theme`, `darkTheme`, `themeMode: system` in `lib/app/app.dart`
- [x] 1.3 Lock portrait: `Info.plist` (iPhone + iPad), `AndroidManifest.xml`, `SystemChrome` in `main()`
- [x] 1.4 Tests: light/dark themes use Tyba primary and expected brightness

## 2. Shared UI core

- [x] 2.1 Add `LoadingView`, `ErrorView`, `EmptyView` to `lib/ui/core`
- [x] 2.2 Add `Skeleton` widget and list skeleton
- [x] 2.3 Replace duplicated state UI in list and detail views
- [x] 2.4 Widget tests for each shared widget (retry callback, messages)

## 3. Transitions

- [x] 3.1 Add `fadeSlidePage` helper and use it for list and detail routes (respect disabled animations)
- [x] 3.2 Hero on university name in tile, card and detail header
- [x] 3.3 Animated list <-> grid switch keeping pagination working
- [x] 3.4 Tests: navigation list -> detail -> back, layout toggle keeps items and pagination

## 4. List UX

- [x] 4.1 Load-more indicator while more items remain
- [x] 4.2 Skeleton as loading state
- [x] 4.3 Tests: indicator visible with >20 items, hidden when all shown; skeleton in loading

## 5. Detail UX and accessibility

- [x] 5.1 Image fade-in and placeholder with icon
- [x] 5.2 Snackbar on valid save, unfocus keyboard, `digitsOnly` formatter
- [x] 5.3 `Semantics` labels on image area and actions
- [x] 5.4 Tests: snackbar on valid/invalid save, non-digits rejected, semantics labels

## 6. Wrap-up

- [x] 6.1 Update existing tests broken by new finders
- [x] 6.2 `flutter analyze` and `flutter test` pass
- [x] 6.3 Update README (theme, orientation, UI decisions) and ROADMAP

## 7. Avatar Hero

- [x] 7.1 Add `UniversityAvatarHero` (initial in a `CircleAvatar`, tag `university-<id>-avatar`)
- [x] 7.2 Use it in the list tile, the grid card (new) and a `Row[avatar, title]` in the detail `_InfoSection`
- [x] 7.3 Tests: both Heroes present on list -> detail navigation (list and grid); the initial is shown in the detail header
