import 'package:flutter/material.dart';

import '../../enums/ui/action_button_variant.dart';
import '../../services/task_feedback_service.dart';
import '../common/custom_button.dart';

class TaskDeleteDialog extends StatefulWidget {
  const TaskDeleteDialog({
    super.key,
    required this.title,
    required this.onDelete,
  });

  final String title;
  final Future<void> Function() onDelete;

  @override
  State<TaskDeleteDialog> createState() => _TaskDeleteDialogState();
}

class _TaskDeleteDialogState extends State<TaskDeleteDialog> {
  bool _isDeleting = false;

  Future<void> _delete() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);
    try {
      await widget.onDelete();
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      const TaskFeedbackService().show(
        context,
        message: 'Could not delete task. Try again.',
        icon: Icons.error_outline_rounded,
        iconColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_isDeleting,
    child: AlertDialog(
      title: const Text('Delete task?'),
      content: Text('“${widget.title}” will be removed.'),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        CustomButton(
          label: 'Delete',
          processingLabel: 'Deleting...',
          onPressed: _delete,
          isProcessing: _isDeleting,
          variant: ActionButtonVariant.text,
          destructive: true,
        ),
      ],
    ),
  );
}
