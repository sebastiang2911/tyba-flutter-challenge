import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/domain/models/university_profile.dart';
import 'package:tyba_technical_test/ui/features/universities/widgets/image_placeholder.dart';
import 'package:tyba_technical_test/ui/features/universities/widgets/university_image_section.dart';

Widget _wrap({
  String? imagePath,
  String? error,
  ValueChanged<PhotoSource>? onPick,
}) => MaterialApp(
  home: Scaffold(
    body: UniversityImageSection(
      imagePath: imagePath,
      error: error,
      onPick: onPick ?? (_) {},
    ),
  ),
);

void main() {
  testWidgets('shows the placeholder when there is no image', (tester) async {
    await tester.pumpWidget(_wrap());

    expect(find.byType(ImagePlaceholder), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('shows the image when a path is assigned', (tester) async {
    await tester.pumpWidget(_wrap(imagePath: '/missing.png'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(ImagePlaceholder), findsNothing);
  });

  testWidgets('reports the chosen photo source', (tester) async {
    final picked = <PhotoSource>[];
    await tester.pumpWidget(_wrap(onPick: picked.add));

    await tester.tap(find.text('Gallery'));
    await tester.tap(find.text('Camera'));

    expect(picked, [PhotoSource.gallery, PhotoSource.camera]);
  });

  testWidgets('shows the error text', (tester) async {
    await tester.pumpWidget(_wrap(error: 'Permission denied'));

    expect(find.text('Permission denied'), findsOneWidget);
  });
}
