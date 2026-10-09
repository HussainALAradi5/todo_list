import 'package:flutter/material.dart';

import '../../constants/layout_constants.dart';

class TaskEditorLayout extends StatelessWidget {
  const TaskEditorLayout({
    super.key,
    required this.textFields,
    required this.categoryField,
    required this.dueDateField,
    required this.reminderField,
    required this.priorityField,
    required this.saveButton,
  });

  final Widget textFields;
  final Widget categoryField;
  final Widget dueDateField;
  final Widget reminderField;
  final Widget priorityField;
  final Widget saveButton;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width >= 600 && size.width > size.height;
    if (landscape) {
      return Row(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                LayoutConstants.contentPadding,
                16,
                12,
                16,
              ),
              children: [textFields],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                12,
                16,
                LayoutConstants.contentPadding,
                16,
              ),
              children: [
                categoryField,
                const SizedBox(height: 20),
                dueDateField,
                const SizedBox(height: 20),
                reminderField,
                const SizedBox(height: 20),
                priorityField,
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              LayoutConstants.contentPadding,
              24,
              LayoutConstants.contentPadding,
              20,
            ),
            children: [
              textFields,
              const SizedBox(height: 28),
              categoryField,
              const SizedBox(height: 28),
              dueDateField,
              const SizedBox(height: 28),
              reminderField,
              const SizedBox(height: 28),
              priorityField,
            ],
          ),
        ),
        saveButton,
      ],
    );
  }
}
