import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../domain/failures/failure.dart';
import '../../../../domain/models/university.dart';
import '../../../../domain/models/university_profile.dart';
import '../../../../domain/validators/student_count_validator.dart';
import '../providers/providers.dart';

class UniversityDetailView extends ConsumerWidget {
  const UniversityDetailView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final university = ref.watch(universityProvider(id));
    return PopScope(
      // Deep link: nothing below the detail, so go to the list on back.
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.list);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.list),
          ),
          title: Text(university.value?.name ?? 'University'),
        ),
        body: university.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error is Failure ? error.message : 'Something went wrong'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(universityProvider(id)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (university) => _DetailContent(id: id, university: university),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.id, required this.university});

  final int id;
  final University university;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(universityProfileProvider(id));
    final notifier = ref.read(universityProfileProvider(id).notifier);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ImageSection(
          imagePath: state.profile.imagePath,
          error: state.imageError,
          onPick: notifier.pickImage,
        ),
        const SizedBox(height: 16),
        _InfoSection(university: university),
        const SizedBox(height: 16),
        _StudentCountSection(
          initialValue: state.profile.studentCount,
          error: state.studentCountError,
          onSubmit: notifier.submitStudentCount,
        ),
      ],
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({
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
        AspectRatio(
          aspectRatio: 16 / 9,
          child: imagePath == null
              ? const Card(child: Center(child: Text('No image assigned')))
              : Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onPick(PhotoSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onPick(PhotoSource.camera),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Camera'),
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

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(university.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        _InfoRow(label: 'Country', value: university.country),
        if (university.stateProvince != null)
          _InfoRow(label: 'State/Province', value: university.stateProvince!),
        if (university.domains.isNotEmpty)
          _InfoRow(label: 'Domains', value: university.domains.join(', ')),
        if (university.webPages.isNotEmpty)
          _InfoRow(label: 'Web pages', value: university.webPages.join('\n')),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _StudentCountSection extends StatefulWidget {
  const _StudentCountSection({
    required this.initialValue,
    required this.error,
    required this.onSubmit,
  });

  final int? initialValue;
  final StudentCountError? error;
  final ValueChanged<String> onSubmit;

  @override
  State<_StudentCountSection> createState() => _StudentCountSectionState();
}

class _StudentCountSectionState extends State<_StudentCountSection> {
  late final _controller = TextEditingController(
    text: widget.initialValue?.toString() ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _message(StudentCountError? error) => switch (error) {
    null => null,
    StudentCountError.empty => 'Enter the number of students',
    StudentCountError.notInteger => 'Must be a whole number',
    StudentCountError.outOfRange =>
      'Must be between ${StudentCountValidator.min} and '
          '${StudentCountValidator.max}',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of students',
            border: const OutlineInputBorder(),
            errorText: _message(widget.error),
          ),
          onSubmitted: widget.onSubmit,
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => widget.onSubmit(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
