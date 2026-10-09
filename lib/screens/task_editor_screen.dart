import 'package:flutter/material.dart';

import '../constants/layout_constants.dart';
import '../enums/task/task_category.dart';
import '../enums/task/task_priority.dart';
import '../enums/task/task_reminder.dart';
import '../enums/ui/action_button_variant.dart';
import '../extensions/task_reminder_details.dart';
import '../models/todo_task.dart';
import '../services/task_feedback_service.dart';
import '../theme/app_palette.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/task_editor/task_category_field.dart';
import '../widgets/task_editor/task_due_date_field.dart';
import '../widgets/task_editor/task_editor_layout.dart';
import '../widgets/task_editor/task_priority_field.dart';
import '../widgets/task_editor/task_reminder_field.dart';
import '../widgets/task_editor/task_text_fields.dart';

class TaskEditorScreen extends StatefulWidget {
  const TaskEditorScreen({
    super.key,
    this.task,
    required this.onSave,
    this.requestReminderPermission,
  });

  final TodoTask? task;
  final Future<void> Function(TodoTask task) onSave;
  final Future<bool> Function()? requestReminderPermission;

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late TaskCategory _category;
  late TaskPriority _priority;
  late TaskReminder _reminder;
  DateTime? _dueAt;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _notesController = TextEditingController(text: widget.task?.notes ?? '');
    _category = widget.task?.category ?? TaskCategory.personal;
    _priority = widget.task?.priority ?? TaskPriority.normal;
    _reminder = widget.task?.reminder ?? TaskReminder.none;
    _dueAt = widget.task?.dueAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    final task = TodoTask(
      id: widget.task?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      dueAt: _dueAt,
      category: _category,
      priority: _priority,
      isCompleted: widget.task?.isCompleted ?? false,
      reminder: _dueAt == null ? TaskReminder.none : _reminder,
    );
    setState(() => _isSaving = true);
    try {
      if (task.reminder != TaskReminder.none &&
          widget.requestReminderPermission != null) {
        final allowed = await widget.requestReminderPermission!();
        if (!allowed) {
          if (!mounted) return;
          setState(() => _isSaving = false);
          const TaskFeedbackService().show(
            context,
            message: 'Allow notifications or choose Reminder Off.',
            icon: Icons.notifications_off_outlined,
          );
          return;
        }
      }
      await widget.onSave(task);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      const TaskFeedbackService().show(
        context,
        message: 'Could not save task. Try again.',
        icon: Icons.error_outline_rounded,
        iconColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width >= 600 && size.width > size.height;
    return PopScope(
      canPop: !_isSaving,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.palette.background,
          title: Text(widget.task == null ? 'New task' : 'Edit task'),
          centerTitle: true,
          automaticallyImplyLeading: !_isSaving,
          actions: landscape
              ? [
                  CustomButton(
                    label: 'Save',
                    processingLabel: 'Saving...',
                    onPressed: _save,
                    isProcessing: _isSaving,
                    variant: ActionButtonVariant.text,
                  ),
                  const SizedBox(width: 8),
                ]
              : null,
        ),
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: _isSaving,
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
                  onChanged: (value) => setState(() {
                    _dueAt = value;
                    if (value == null ||
                        !value
                            .subtract(_reminder.leadTime)
                            .isAfter(DateTime.now())) {
                      _reminder = TaskReminder.none;
                    }
                  }),
                ),
                reminderField: TaskReminderField(
                  dueAt: _dueAt,
                  value: _reminder,
                  onChanged: (value) => setState(() => _reminder = value),
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
                  child: CustomButton(
                    label: widget.task == null ? 'Create task' : 'Save changes',
                    processingLabel: 'Saving...',
                    onPressed: _save,
                    isProcessing: _isSaving,
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
