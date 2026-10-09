# Dayly

A clean, responsive todo app for Android and iPhone, built with Flutter.

## Features

- Today, Upcoming, and Completed views
- Add, edit, complete, and delete tasks
- Categories, Normal/High/Urgent priority, notes, due dates, and times
- Search and category filters
- Swipe right to complete or restore, swipe left to delete, and undo either action
- Animated progress feedback
- Persistent light and dark mode toggle
- Responsive portrait and landscape layouts for phones
- Local task storage with `shared_preferences`

The app opens with a few editable example tasks on first launch. After that, it restores your saved tasks, including an empty list if you delete them all.

## Project structure

```text
lib/
  constants/  Shared layout values and storage keys
  data/       SharedPreferences adapters and app state
  enums/      Navigation and task enum subfolders
  extensions/ Category and priority presentation, derived progress values
  interfaces/ Task and theme storage contracts
  mappers/    JSON conversion for task storage
  models/     Task and progress data only
  screens/    Dashboard and task editor
  services/   Task queries and first-launch examples
  theme/      Light/dark palettes and Material themes
  utils/      Date formatting
  widgets/    home/, task_card/, task_editor/, and theme/ components
```

## Run

```sh
flutter pub get
flutter run
```

Use an Android emulator/device or an iPhone simulator/device with the appropriate Flutter platform tooling installed. Run `flutter analyze` and `flutter test` to check the project.

Run `dart run tool/check_source_lines.dart` to enforce the 250-line limit for authored Dart files.
