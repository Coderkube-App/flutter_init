# flutter_create_cli

Create a Flutter project quickly with predefined architecture and state-management templates.

## Install

```bash
npm install -g flutter_create_cli
```

## Create Flutter Project

### Interactive (recommended)

```bash
flutter_create init
```

This will ask:
- Flutter project name
- State management (`Simple Getx`, `Reactive Getx`, `Provider`, `Bloc`)

### Direct command (no prompts)

```bash
flutter_create init my_app --state=reactive_getx --yes
```

Supported values for `--state`:
- `simple_getx`
- `reactive_getx`
- `provider`
- `bloc`

## Verify generated project

```bash
cd my_app
flutter pub get
flutter run
```
