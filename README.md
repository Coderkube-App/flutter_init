# flutter_create_cli

Scaffold a production-ready Flutter project in minutes with structure, dependencies, and state management templates.

## Features

- Supports `simple_getx`, `reactive_getx`, `provider`, and `bloc`
- Interactive mode for easy setup and non-interactive flags for CI/script usage
- Config-file driven setup via `flutter_create.config.json` or `--config`
- Built-in `doctor` command for Flutter/Dart environment checks
- Adds reusable template architecture and package import replacement
- Generates quality starter files:
  - `analysis_options.yaml`
  - `.github/workflows/ci.yml`
  - `assets/images/` and linked pubspec assets
- Generates new features after initialization:
  - `flutter_create generate module <name>`
  - `flutter_create generate screen <name>`

## Installation

```bash
npm install -g flutter_create_cli
```

## Commands

### Initialize a project

Interactive:

```bash
flutter_create init
```

Non-interactive:

```bash
flutter_create init my_app --state=bloc --yes
```

Dry-run (safe test, no files changed):

```bash
flutter_create init demo_app --state=provider --yes --dry-run --skip-doctor
```

### Generate module/screen in an existing Flutter app

From inside project root:

```bash
flutter_create generate module user
flutter_create generate screen checkout
```

With explicit project path:

```bash
flutter_create generate module inventory --project ./my_app
```

### Environment doctor

```bash
flutter_create doctor
```

## Config File

Create `flutter_create.config.json`:

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
flutter_create init
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
npm install -g ./flutter_create_cli-*.tgz
flutter_create init my_real_app --state=bloc --yes
```

### 5) Verify generated Flutter app

Inside generated app:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Publish To npm

Use these steps to publish `flutter_create_cli` as a public package.

### 1) Authenticate with the correct npm account

```bash
npm logout
npm login
npm whoami
```

### 2) Confirm package metadata

```bash
node -p "const p=require('./package.json'); p.name + '@' + p.version"
```

### 3) Optional preflight checks

```bash
npm test
npm pack
```

### 4) Publish

```bash
npm publish --access public
```

### 5) Verify published version

```bash
npm view flutter_create_cli version
```

### Install and use after publish

```bash
npm install -g flutter_create_cli
flutter_create init
```

### If you get E403 (2FA/token required)

If npm shows:
`Two-factor authentication or granular access token with bypass 2fa enabled is required`

then either:

- publish with OTP prompt after `npm login`, or
- use a granular access token with publish permission and 2FA bypass enabled.
