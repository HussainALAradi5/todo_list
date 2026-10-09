import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';

class FilterRangeField extends StatelessWidget {
  const FilterRangeField({
    super.key,
    required this.caption,
    required this.value,
    required this.icon,
    required this.onPressed,
  });

  final String caption;
  final String value;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      side: BorderSide(color: context.palette.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: TextStyle(fontSize: 11, color: context.palette.muted),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 5),
            Expanded(
              child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ],
    ),
  );
}
