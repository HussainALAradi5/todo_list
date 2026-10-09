import 'dart:io';

const maxLines = 250;
const sourceFolders = ['lib', 'test', 'tool'];

Future<void> main() async {
  final oversized = <String>[];
  for (final folder in sourceFolders) {
    await for (final entity in Directory(folder).list(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final count = (await entity.readAsLines()).length;
      if (count > maxLines) oversized.add('${entity.path}: $count lines');
    }
  }

  if (oversized.isEmpty) {
    stdout.writeln('All authored Dart files are within $maxLines lines.');
    return;
  }
  stderr.writeln(oversized.join('\n'));
  exitCode = 1;
}
