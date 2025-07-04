import 'package:flutter/material.dart';

Widget testQuestChip(BuildContext context, String label, Color color) {
  return Chip(
    label: Text(
      label,
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
  );
}
