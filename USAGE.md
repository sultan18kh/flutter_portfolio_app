# Usage

## Prerequisites
- Flutter SDK (Dart SDK ^3.5.1)

## Setup
```bash
flutter pub get
dart run build_runner build   # generates lib/models/*.g.dart (JSON serialization)
```

## Run
```bash
flutter run -d chrome   # web is the primary target
```

Other targets (`flutter devices` to list): `flutter run -d macos`, `flutter run -d windows`, etc.

## Build for web deployment
```bash
flutter build web
```
Output in `build/web/` — deploy as static files (Firebase Hosting, Netlify, Vercel, GitHub Pages).

## Other commands
```bash
flutter analyze                          # lint
flutter test                             # run tests
dart run build_runner watch              # regenerate .g.dart files on change
dart run build_runner build --delete-conflicting-outputs   # if codegen conflicts
```
