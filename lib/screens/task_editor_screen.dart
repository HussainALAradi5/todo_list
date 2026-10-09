import 'package:flutter/material.dart';

import '../constants/layout_constants.dart';
import '../enums/task/task_category.dart';
import '../enums/task/task_priority.dart';
import '../models/todo_task.dart';
import '../theme/app_palette.dart';
import '../widgets/task_editor/task_category_field.dart';
import '../widgets/task_editor/task_due_date_field.dart';
import '../widgets/task_editor/task_editor_layout.dart';
import '../widgets/task_editor/task_priority_field.dart';
import '../widgets/task_editor/task_text_fields.dart';

class TaskEditorScreen extends StatefulWidget {
  const TaskEditorScreen({super.key, this.task});

  final TodoTask? task;

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late TaskCategory _category;
  late TaskPriority _priority;
  DateTime? _dueAt;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _notesController = TextEditingController(text: widget.task?.notes ?? '');
    _category = widget.task?.category ?? TaskCategory.personal;
    _priority = widget.task?.priority ?? TaskPriority.normal;
    _dueAt = widget.task?.dueAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TodoTask(
        id: widget.task?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        notes: _notesController.text.trim(),
        dueAt: _dueAt,
        category: _category,
        priority: _priority,
        isCompleted: widget.task?.isCompleted ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width >= 600 && size.width > size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.palette.background,
        title: Text(widget.task == null ? 'New task' : 'Edit task'),
        centerTitle: true,
        actions: landscape
            ? [
                TextButton(
                  onPressed: _save,
                  child: Text(
                    'Save',
                    style: TextStyle(color: context.palette.primary),
                  ),
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: TaskEditorLayout(
            textFields: TaskTextFields(
              titleController: _titleController,
              notesController: _notesController,
              autofocus: widget.task == null,
            ),
            categoryField: TaskCategoryField(
              value: _category,
              onChanged: (value) => setState(() => _category = value),
            ),
            dueDateField: TaskDueDateField(
              value: _dueAt,
              onChanged: (value) => setState(() => _dueAt = value),
            ),
            priorityField: TaskPriorityField(
              value: _priority,
              onChanged: (value) => setState(() => _priority = value),
            ),
            saveButton: Padding(
              padding: const EdgeInsets.fromLTRB(
                LayoutConstants.contentPadding,
                10,
                LayoutConstants.contentPadding,
                20,
              ),
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: context.palette.primary,
                  foregroundColor: context.palette.background,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  widget.task == null ? 'Create task' : 'Save changes',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
