import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../domain/models/university_profile.dart';
import 'image_placeholder.dart';

class UniversityImageSection extends StatelessWidget {
  const UniversityImageSection({
    super.key,
    required this.imagePath,
    required this.error,
    required this.onPick,
  });

  final String? imagePath;
  final String? error;
  final ValueChanged<PhotoSource> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          image: true,
          excludeSemantics: true,
          label: imagePath == null
              ? 'No image assigned to this university'
              : 'Image assigned to this university',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: imagePath == null
                    ? const ImagePlaceholder(key: ValueKey('placeholder'))
                    : Image.file(
                        File(imagePath!),
                        key: ValueKey(imagePath),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) =>
                            const Center(child: Icon(Icons.broken_image)),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Tooltip(
                message: 'Pick an image from the gallery',
                child: OutlinedButton.icon(
                  onPressed: () => onPick(PhotoSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Tooltip(
                message: 'Take a photo with the camera',
                child: OutlinedButton.icon(
                  onPressed: () => onPick(PhotoSource.camera),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Camera'),
                ),
              ),
            ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
