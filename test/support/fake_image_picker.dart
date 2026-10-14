import 'package:image_picker/image_picker.dart';

/// Records the requested source and returns [result] (`null` = cancelled).
class FakeImagePicker implements ImagePicker {
  FakeImagePicker({this.result});

  XFile? result;
  ImageSource? requestedSource;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    requestedSource = source;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not faked');
}
