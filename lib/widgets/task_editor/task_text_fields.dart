import 'package:flutter/material.dart';

import 'field_label.dart';

class TaskTextFields extends StatelessWidget {
  const TaskTextFields({
    super.key,
    required this.titleController,
    required this.notesController,
    required this.autofocus,
  });

  final TextEditingController titleController;
  final TextEditingController notesController;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('TASK NAME'),
      const SizedBox(height: 10),
      TextFormField(
        controller: titleController,
        autofocus: autofocus,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        maxLength: 100,
        decoration: const InputDecoration(hintText: 'What needs to be done?'),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter a task name' : null,
      ),
      const SizedBox(height: 20),
      const FieldLabel('NOTES'),
      const SizedBox(height: 10),
      TextFormField(
        controller: notesController,
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Add a little more detail...',
        ),
      ),
    ],
  );
}
