import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/screens/task_editor_screen.dart';
import 'package:todo_list/widgets/dialogs/task_delete_dialog.dart';

void main() {
  testWidgets('save stays disabled until persistence finishes', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final pendingSave = Completer<void>();
    var saves = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => TaskEditorScreen(
                    onSave: (_) {
                      saves++;
                      return pendingSave.future;
                    },
                  ),
                ),
              ),
              child: const Text('Open editor'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Pay rent');
    await tester.tap(find.text('Create task'));
    await tester.pump();

    expect(find.text('Saving...'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(saves, 1);
    pendingSave.complete();
    await tester.pumpAndSettle();
    expect(find.text('Open editor'), findsOneWidget);
    expect(saves, 1);
  });

  testWidgets('delete and cancel stay disabled until deletion finishes', (
    tester,
  ) async {
    final pendingDelete = Completer<void>();
    var deletes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (_) => TaskDeleteDialog(
                  title: 'Pay rent',
                  onDelete: () {
                    deletes++;
                    return pendingDelete.future;
                  },
                ),
              ),
              child: const Text('Open dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pump();

    expect(find.text('Deleting...'), findsOneWidget);
    final buttons = tester.widgetList<TextButton>(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextButton),
      ),
    );
    expect(buttons.where((button) => button.onPressed != null), isEmpty);
    expect(deletes, 1);
    pendingDelete.complete();
    await tester.pumpAndSettle();
    expect(find.text('Open dialog'), findsOneWidget);
    expect(deletes, 1);
  });
}
