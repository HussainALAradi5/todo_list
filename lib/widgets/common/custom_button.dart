import 'package:flutter/material.dart';

import '../../enums/ui/action_button_variant.dart';
import '../../theme/app_palette.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.processingLabel,
    required this.onPressed,
    this.isProcessing = false,
    this.variant = ActionButtonVariant.filled,
    this.destructive = false,
  });

  final String label;
  final String processingLabel;
  final VoidCallback? onPressed;
  final bool isProcessing;
  final ActionButtonVariant variant;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = destructive
        ? Theme.of(context).colorScheme.error
        : palette.primary;
    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: isProcessing
          ? Row(
              key: const ValueKey('processing'),
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: variant == ActionButtonVariant.filled
                        ? palette.background
                        : foreground,
                  ),
                ),
                const SizedBox(width: 9),
                Text(processingLabel),
              ],
            )
          : Text(
              label,
              key: const ValueKey('ready'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
    );
    final action = isProcessing ? null : onPressed;
    return switch (variant) {
      ActionButtonVariant.filled => FilledButton(
        onPressed: action,
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.background,
          disabledBackgroundColor: palette.primary.withValues(alpha: .6),
          disabledForegroundColor: palette.background,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: content,
      ),
      ActionButtonVariant.text => TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          disabledForegroundColor: foreground.withValues(alpha: .65),
        ),
        child: content,
      ),
    };
  }
}
