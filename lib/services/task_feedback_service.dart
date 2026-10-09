import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class TaskFeedbackService {
  const TaskFeedbackService();

  void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onUndo,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final palette = context.palette;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: viewportWidth < 480 ? viewportWidth - 32 : 448,
        duration: Duration(seconds: onUndo == null ? 3 : 5),
        backgroundColor: palette.surface,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.border),
        ),
        content: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? palette.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: palette.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                textColor: palette.primary,
                onPressed: onUndo,
              ),
      ),
    );
  }
}
