# Tasks

## 1. Palette

- [x] 1.1 Replace seed with indigo `#283593` and set `secondary` to amber `#F2A93B` in `lib/app/theme.dart`; remove the unused `tybaRed`; verify `flutter analyze` is clean
- [x] 1.2 Update `test/app/theme_test.dart`: assert primary hue is near indigo, secondary is amber in both themes, and dark gray rules still hold; verify `flutter test` passes
- [x] 1.3a Set the app bar background to indigo with white foreground in both themes and cover it in `theme_test.dart`
- [x] 1.3b Add `GradientBackdrop` and wrap the list screen body; verify with `gradient_backdrop_test.dart`
- [x] 1.3 Run the app in light and dark and verify list, grid and detail look coherent
