import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final List<Widget> children;

  const ProfileSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.colorScheme.surface,
      child: Column(children: children),
    );
  }
}
