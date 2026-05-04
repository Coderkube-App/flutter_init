# flutter_init

Scaffold a production-ready Flutter project in minutes with structure, dependencies, and state management templates.

## Features

- Supports `simple_getx`, `reactive_getx`, `provider`, and `bloc`
- Interactive mode for easy setup and non-interactive flags for CI/script usage
- Config-file driven setup via `flutter_init.config.json` or `--config`
- Built-in `doctor` command for Flutter/Dart environment checks
- Adds reusable template architecture and package import replacement
- Generates quality starter files:
  - `analysis_options.yaml`
  - `.github/workflows/ci.yml`
  - `assets/images/` and linked pubspec assets
- Generates new features after initialization:
  - `flutter-init generate module <name>`
  - `flutter-init generate screen <name>`

## Installation

```bash
npm install -g flutter_init
```

## Commands

### Initialize a project

Interactive:

```bash
flutter-init init
```

Non-interactive:

```bash
flutter-init init my_app --state=bloc --yes
```

Dry-run (safe test, no files changed):

```bash
flutter-init init demo_app --state=provider --yes --dry-run --skip-doctor
```

### Generate module/screen in an existing Flutter app

From inside project root:

```bash
flutter-init generate module user
flutter-init generate screen checkout
```

With explicit project path:

```bash
flutter-init generate module inventory --project ./my_app
```

### Environment doctor

```bash
flutter-init doctor
```

## Config File

Create `flutter_init.config.json`:

```json
{
  "init": {
    "projectName": "my_app",
    "state": "reactive_getx",
    "yes": true,
    "skipDoctor": false,
    "dryRun": false
  }
}
```

Then run:

```bash
flutter-init init
```

## Testing This Package

### 1) Run unit tests (Node CLI logic)

```bash
npm test
```

### 2) Validate CLI help and doctor

```bash
node cli.js --help
node cli.js doctor
```

### 3) Validate dry-run init flow

```bash
node cli.js init sample_app --state=simple_getx --yes --dry-run --skip-doctor
```

### 4) End-to-end local install test

```bash
npm pack
npm install -g ./flutter_init-*.tgz
flutter-init init my_real_app --state=bloc --yes
```

### 5) Verify generated Flutter app

Inside generated app:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```
