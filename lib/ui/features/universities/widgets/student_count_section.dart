import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/validators/student_count_validator.dart';

class StudentCountSection extends StatefulWidget {
  const StudentCountSection({
    super.key,
    required this.initialValue,
    required this.error,
    required this.onSubmit,
  });

  final int? initialValue;
  final StudentCountError? error;
  final bool Function(String) onSubmit;

  @override
  State<StudentCountSection> createState() => _StudentCountSectionState();
}

class _StudentCountSectionState extends State<StudentCountSection> {
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

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  void _submit(String value) {
    _dismissKeyboard();
    if (widget.onSubmit(value)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Student count saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Number of students',
            errorText: _message(widget.error),
          ),
          onSubmitted: _submit,
          onTapOutside: (_) => _dismissKeyboard(),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => _submit(_controller.text),
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
