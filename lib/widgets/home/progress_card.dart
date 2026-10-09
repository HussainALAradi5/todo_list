import 'package:flutter/material.dart';

import '../../extensions/task_progress_values.dart';
import '../../models/task_progress.dart';
import '../../theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.progress});

  final TaskProgress progress;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(23),
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TODAY’S PROGRESS',
                style: TextStyle(
                  color: Color(0xFFA9ADBD),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                progress.total == 0
                    ? 'A fresh start'
                    : '${progress.completed} of ${progress.total} done',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                progress.total == 0
                    ? 'Add your first task to get going.'
                    : progress.fraction == 1
                    ? 'Everything is checked off. Great work!'
                    : 'Keep the momentum going!',
                style: const TextStyle(color: Color(0xFFA9ADBD), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 68,
          height: 68,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.fraction),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFF35394D),
                    color: const Color(0xFFA9F0CE),
                  ),
                ),
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
