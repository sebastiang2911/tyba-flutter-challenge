import 'package:flutter/material.dart';

/// Placeholder for the university detail. Replaced by a later change.
class UniversityDetailView extends StatelessWidget {
  const UniversityDetailView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University')),
      body: Center(child: Text('University detail #$id')),
    );
  }
}
