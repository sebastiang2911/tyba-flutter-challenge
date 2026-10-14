import 'package:image_picker/image_picker.dart';

import '../../domain/models/university_profile.dart';

/// Stateless wrapper around `image_picker`.
class ImagePickerService {
  ImagePickerService([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Returns the picked file path, or `null` when the user cancels.
  Future<String?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: switch (source) {
        PhotoSource.gallery => ImageSource.gallery,
        PhotoSource.camera => ImageSource.camera,
      },
    );
    return file?.path;
  }
}
