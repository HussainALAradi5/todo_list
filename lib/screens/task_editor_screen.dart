import 'package:flutter/material.dart';

import '../constants/layout_constants.dart';
import '../enums/task/task_category.dart';
import '../enums/task/task_priority.dart';
import '../models/todo_task.dart';
import '../theme/app_theme.dart';
import '../widgets/task_editor/task_category_field.dart';
import '../widgets/task_editor/task_due_date_field.dart';
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.background,
      title: Text(widget.task == null ? 'New task' : 'Edit task'),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
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
                  TaskTextFields(
                    titleController: _titleController,
                    notesController: _notesController,
                    autofocus: widget.task == null,
                  ),
                  const SizedBox(height: 28),
                  TaskCategoryField(
                    value: _category,
                    onChanged: (value) => setState(() => _category = value),
                  ),
                  const SizedBox(height: 28),
                  TaskDueDateField(
                    value: _dueAt,
                    onChanged: (value) => setState(() => _dueAt = value),
                  ),
                  const SizedBox(height: 28),
                  TaskPriorityField(
                    value: _priority,
                    onChanged: (value) => setState(() => _priority = value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LayoutConstants.contentPadding,
                10,
                LayoutConstants.contentPadding,
                20,
              ),
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.purple,
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
          ],
        ),
      ),
    ),
  );
}
