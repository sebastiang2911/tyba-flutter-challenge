import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tyba_technical_test/data/services/image_picker_service.dart';
import 'package:tyba_technical_test/domain/models/university_profile.dart';

import '../../support/fake_image_picker.dart';

void main() {
  test('picks from the gallery and returns the file path', () async {
    final picker = FakeImagePicker(result: XFile('/tmp/gallery.png'));

    final path = await ImagePickerService(picker).pick(PhotoSource.gallery);

    expect(picker.requestedSource, ImageSource.gallery);
    expect(path, '/tmp/gallery.png');
  });

  test('picks from the camera and returns the file path', () async {
    final picker = FakeImagePicker(result: XFile('/tmp/camera.png'));

    final path = await ImagePickerService(picker).pick(PhotoSource.camera);

    expect(picker.requestedSource, ImageSource.camera);
    expect(path, '/tmp/camera.png');
  });

  test('returns null when the user cancels', () async {
    final picker = FakeImagePicker();

    expect(await ImagePickerService(picker).pick(PhotoSource.gallery), isNull);
  });
}
