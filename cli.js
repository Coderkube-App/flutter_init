#!/usr/bin/env node

const inquirer = require('inquirer');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const STATE_CHOICES = {
  simple_getx: {
    label: 'Simple Getx',
    modeFolder: 'with_simple_getx',
    oldPackageName: 'flutter_standard',
    stateDeps: ['get']
  },
  reactive_getx: {
    label: 'Reactive Getx',
    modeFolder: 'with_reactive_getx',
    oldPackageName: 'flutter_with_reactive_getx',
    stateDeps: ['get']
  },
  provider: {
    label: 'Provider',
    modeFolder: 'with_provider',
    oldPackageName: 'provider_project',
    stateDeps: ['provider', 'flutter_localization']
  },
  bloc: {
    label: 'Bloc',
    modeFolder: 'with_bloc',
    oldPackageName: 'bloc_project',
    stateDeps: ['flutter_bloc', 'equatable']
  }
};

const COMMON_DEPENDENCIES = [
  'dynamicutils',
  'image_picker',
  'shared_preferences',
  'cached_network_image',
  'http',
  'connectivity_plus',
  'file_picker',
  'flutter_offline',
  'get_storage'
];

function toCamelCase(value) {
  const parts = slugify(value).split('_').filter(Boolean);
  return parts
    .map((segment, index) => (index === 0 ? segment : `${segment[0].toUpperCase()}${segment.slice(1)}`))
    .join('');
}

function toPascalCase(value) {
  return toCamelCase(value).replace(/^./, (char) => char.toUpperCase());
}

function slugify(input) {
  return String(input)
    .toLowerCase()
    .replace(/[^a-z0-9_]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .replace(/_{2,}/g, '_');
}

function isValidFlutterProjectName(name) {
  return /^[a-z][a-z0-9_]*$/.test(name);
}

function parseArgs(rawArgs) {
  const result = { _: [], flags: {} };
  for (let index = 0; index < rawArgs.length; index += 1) {
    const token = rawArgs[index];
    if (!token.startsWith('--')) {
      result._.push(token);
      continue;
    }
    const clean = token.slice(2);
    const equalIndex = clean.indexOf('=');
    if (equalIndex >= 0) {
      const key = clean.slice(0, equalIndex);
      const value = clean.slice(equalIndex + 1);
      result.flags[key] = value;
      continue;
    }
    const nextToken = rawArgs[index + 1];
    if (!nextToken || nextToken.startsWith('--')) {
      result.flags[clean] = true;
      continue;
    }
    result.flags[clean] = nextToken;
    index += 1;
  }
  return result;
}

function boolFlag(value, fallback = false) {
  if (typeof value === 'boolean') return value;
  if (typeof value !== 'string') return fallback;
  const normalized = value.trim().toLowerCase();
  if (['true', '1', 'yes', 'y'].includes(normalized)) return true;
  if (['false', '0', 'no', 'n'].includes(normalized)) return false;
  return fallback;
}

function printHelp() {
  console.log(`
flutter-init commands:
  flutter-init init [projectName] [--state simple_getx|reactive_getx|provider|bloc] [--yes] [--dry-run] [--skip-doctor] [--config path]
  flutter-init generate module <name> [--project path] [--state ...]
  flutter-init generate screen <name> [--project path] [--state ...]
  flutter-init doctor

Examples:
  flutter-init init my_app --state=bloc --yes
  flutter-init init --config flutter_init.config.json
  flutter-init generate module user --project ./my_app --state provider
`);
}

function getConfigPath(flags) {
  if (typeof flags.config === 'string') return path.resolve(process.cwd(), flags.config);
  const candidates = ['flutter_init.config.json', 'flutter_init.config.js'];
  for (const candidate of candidates) {
    const fullPath = path.join(process.cwd(), candidate);
    if (fs.existsSync(fullPath)) return fullPath;
  }
  return null;
}

function loadConfig(flags) {
  const configPath = getConfigPath(flags);
  if (!configPath) return {};
  if (configPath.endsWith('.js')) {
    // eslint-disable-next-line global-require, import/no-dynamic-require
    return require(configPath);
  }
  return JSON.parse(fs.readFileSync(configPath, 'utf-8'));
}

function resolveStateKey(input) {
  if (!input) return null;
  const normalized = slugify(input).replace(/^with_/, '');
  if (STATE_CHOICES[normalized]) return normalized;
  if (normalized === 'simple_getx' || normalized === 'simple_getx_getx') return 'simple_getx';
  if (normalized === 'reactive_getx' || normalized === 'reactive') return 'reactive_getx';
  return null;
}

function ensureDirectory(targetPath) {
  if (!fs.existsSync(targetPath)) {
    fs.mkdirSync(targetPath, { recursive: true });
  }
}

function copyRecursive(src, dest) {
  ensureDirectory(dest);
  fs.readdirSync(src, { withFileTypes: true }).forEach((entry) => {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyRecursive(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  });
}

function walkFiles(rootDir, extension = '.dart') {
  const result = [];
  const entries = fs.readdirSync(rootDir, { withFileTypes: true });
  entries.forEach((entry) => {
    const fullPath = path.join(rootDir, entry.name);
    if (entry.isDirectory()) {
      result.push(...walkFiles(fullPath, extension));
    } else if (fullPath.endsWith(extension)) {
      result.push(fullPath);
    }
  });
  return result;
}

function replacePackageImports(libPath, oldName, newName) {
  const dartFiles = walkFiles(libPath, '.dart');
  dartFiles.forEach((filePath) => {
    const content = fs.readFileSync(filePath, 'utf-8');
    const updated = content.replaceAll(`package:${oldName}/`, `package:${newName}/`);
    fs.writeFileSync(filePath, updated, 'utf-8');
  });
  console.log(`🔧 Updated import paths from "${oldName}" to "${newName}".`);
}

function runCommand(command, options = {}) {
  if (options.dryRun) {
    console.log(`🧪 [dry-run] ${command}`);
    return '';
  }
  return execSync(command, { stdio: options.stdio || 'inherit', encoding: options.encoding || 'utf8' });
}

function addDependencies(projectPath, dependencies, options = {}) {
  const originalCwd = process.cwd();
  process.chdir(projectPath);
  try {
    dependencies.forEach((dependency) => {
      console.log(`📦 Adding dependency: ${dependency}`);
      runCommand(`flutter pub add ${dependency}`, options);
    });
  } finally {
    process.chdir(originalCwd);
  }
}

function isCommandAvailable(command) {
  try {
    const check = process.platform === 'win32' ? `where ${command}` : `which ${command}`;
    execSync(check, { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

function validateFlutterEnvironment(options = {}) {
  console.log('🔍 Validating environment...');
  if (!isCommandAvailable('flutter')) {
    throw new Error('Flutter is not installed or not in your PATH.');
  }
  if (!isCommandAvailable('dart')) {
    throw new Error('Dart is not installed or not in your PATH.');
  }
  runCommand('flutter doctor', { ...options, stdio: 'inherit' });
  console.log('✅ Flutter environment looks good!\n');
}

function updatePubspec(pubspecPath) {
  let pubspec = fs.readFileSync(pubspecPath, 'utf-8');
  if (pubspec.includes('  assets:\n    - assets/images/')) {
    console.log('ℹ️ pubspec.yaml already contains assets/images/');
    return;
  }

  const commentedAssetsRegex = /  # To add assets to your application.*?(?:  # .*\n)*  # assets:\n(?:  #.*\n)*/g;
  if (commentedAssetsRegex.test(pubspec)) {
    pubspec = pubspec.replace(commentedAssetsRegex, '  generate: true\n  assets:\n    - assets/images/\n');
    console.log('📝 Replaced commented assets section.');
  } else {
    pubspec = pubspec.replace(
      /  uses-material-design: true\n/,
      '  uses-material-design: true\n\n  generate: true\n  assets:\n    - assets/images/\n'
    );
    console.log('📝 Added assets section below uses-material-design.');
  }
  fs.writeFileSync(pubspecPath, pubspec, 'utf-8');
  console.log('✅ Updated pubspec.yaml with assets/images/.');
}

function createL10nConfig(projectPath) {
  const l10nPath = path.join(projectPath, 'l10n.yaml');
  const l10nContent = [
    'arb-dir: lib/l10n',
    'template-arb-file: app_en.arb',
    'output-localization-file: app_localizations.dart',
    'output-class: AppLocalizations',
    'synthetic-package: false',
    ''
  ].join('\n');
  fs.writeFileSync(l10nPath, l10nContent, 'utf-8');
  console.log('✅ Created l10n.yaml.');
}

function createQualityFiles(projectPath) {
  const analysisOptionsPath = path.join(projectPath, 'analysis_options.yaml');
  if (!fs.existsSync(analysisOptionsPath)) {
    fs.writeFileSync(
      analysisOptionsPath,
      [
        'include: package:flutter_lints/flutter.yaml',
        '',
        'linter:',
        '  rules:',
        '    prefer_single_quotes: true',
        '    avoid_print: false',
        ''
      ].join('\n'),
      'utf-8'
    );
  }

  const githubWorkflowPath = path.join(projectPath, '.github', 'workflows', 'ci.yml');
  ensureDirectory(path.dirname(githubWorkflowPath));
  if (!fs.existsSync(githubWorkflowPath)) {
    fs.writeFileSync(
      githubWorkflowPath,
      [
        'name: Flutter CI',
        '',
        'on:',
        '  push:',
        '    branches: [ main ]',
        '  pull_request:',
        '    branches: [ main ]',
        '',
        'jobs:',
        '  analyze_and_test:',
        '    runs-on: ubuntu-latest',
        '    steps:',
        '      - uses: actions/checkout@v4',
        '      - uses: subosito/flutter-action@v2',
        '        with:',
        '          channel: stable',
        '      - run: flutter pub get',
        '      - run: flutter analyze',
        '      - run: flutter test',
        ''
      ].join('\n'),
      'utf-8'
    );
  }
}

function createStandardStructure(projectPath) {
  const libPath = path.join(projectPath, 'lib');
  const folders = [
    'core/constants',
    'core/localization',
    'core/network',
    'core/services',
    'core/storage',
    'core/theme',
    'core/utils',
    'core/widgets',
    'data/models',
    'data/providers',
    'data/repositories',
    'domain/entities',
    'domain/repositories',
    'modules/auth',
    'modules/home',
    'modules/profile',
    'routes'
  ];

  folders.forEach((folder) => ensureDirectory(path.join(libPath, folder)));
}

async function promptForProjectDetails(defaults = {}) {
  let projectName = defaults.projectName || '';

  if (!projectName) {
    while (true) {
      const { projectNameInput } = await inquirer.prompt([
        {
          name: 'projectNameInput',
          message: 'Enter your Flutter project name:',
          validate: (input) => {
            if (!input.trim()) return 'Project name cannot be empty.';
            const sanitized = slugify(input);
            if (!isValidFlutterProjectName(sanitized)) {
              return 'Name must start with a letter and contain only lowercase letters, numbers, and underscores.';
            }
            return true;
          }
        }
      ]);
      const sanitized = slugify(projectNameInput);
      if (sanitized !== projectNameInput) {
        const { confirm } = await inquirer.prompt([
          {
            type: 'confirm',
            name: 'confirm',
            message: `Use "${sanitized}" as your project name?`,
            default: true
          }
        ]);
        if (!confirm) continue;
      }
      projectName = sanitized;
      break;
    }
  }

  const stateOptions = Object.values(STATE_CHOICES).map((state) => state.label);
  let stateLabel = defaults.stateLabel || '';
  if (!stateLabel) {
    const response = await inquirer.prompt([
      {
        type: 'list',
        name: 'stateManagement',
        message: 'Choose state management type:',
        choices: stateOptions
      }
    ]);
    stateLabel = response.stateManagement;
  }

  return { projectName, stateLabel };
}

function resolveStateFromLabelOrKey(value) {
  const fromKey = resolveStateKey(value);
  if (fromKey) return fromKey;
  const lowered = String(value || '').toLowerCase();
  const entry = Object.entries(STATE_CHOICES).find(([, state]) => state.label.toLowerCase() === lowered);
  return entry ? entry[0] : null;
}

function resolveInitOptions(parsed) {
  const config = loadConfig(parsed.flags);
  const configInit = config.init || {};
  const projectNameInput = parsed._[1] || parsed.flags.project || configInit.projectName;
  const projectName = projectNameInput ? slugify(projectNameInput) : '';
  const stateKey = resolveStateFromLabelOrKey(parsed.flags.state || configInit.state || 'simple_getx');
  if (!stateKey) {
    throw new Error('Invalid state management. Use simple_getx, reactive_getx, provider, or bloc.');
  }
  return {
    projectName,
    stateKey,
    yes: boolFlag(parsed.flags.yes, boolFlag(configInit.yes, false)),
    dryRun: boolFlag(parsed.flags['dry-run'], boolFlag(configInit.dryRun, false)),
    skipDoctor: boolFlag(parsed.flags['skip-doctor'], boolFlag(configInit.skipDoctor, false))
  };
}

function renderModuleTemplate(featureName) {
  const pascal = toPascalCase(featureName);
  return `import 'package:flutter/material.dart';

class ${pascal}View extends StatelessWidget {
  const ${pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${pascal} module'),
      ),
    );
  }
}
`;
}

function generateModule(targetLibPath, featureName) {
  const folderName = slugify(featureName);
  const modulesRoot = fs.existsSync(path.join(targetLibPath, 'modules')) ? 'modules' : 'module';
  const modulePath = path.join(targetLibPath, modulesRoot, folderName);
  ensureDirectory(modulePath);
  const viewPath = path.join(modulePath, `${folderName}_view.dart`);
  if (!fs.existsSync(viewPath)) {
    fs.writeFileSync(viewPath, renderModuleTemplate(folderName), 'utf-8');
  }
  console.log(`✅ Module generated at ${path.relative(process.cwd(), modulePath)}`);
}

function generateScreen(targetLibPath, screenName) {
  const folderName = slugify(screenName);
  const viewRoot = fs.existsSync(path.join(targetLibPath, 'modules')) ? 'modules' : 'view';
  const viewFolderPath = path.join(targetLibPath, viewRoot, folderName);
  ensureDirectory(viewFolderPath);
  const viewPath = path.join(viewFolderPath, `${folderName}_view.dart`);
  if (!fs.existsSync(viewPath)) {
    fs.writeFileSync(viewPath, renderModuleTemplate(folderName), 'utf-8');
  }
  console.log(`✅ Screen generated at ${path.relative(process.cwd(), viewPath)}`);
}

function detectProjectLibPath(projectPath) {
  const libPath = path.join(projectPath, 'lib');
  if (!fs.existsSync(libPath)) {
    throw new Error(`No lib folder found at ${projectPath}. Use --project to point to your Flutter app.`);
  }
  return libPath;
}

function runDoctor() {
  try {
    validateFlutterEnvironment();
    return 0;
  } catch (error) {
    console.error(`❌ ${error.message}`);
    console.log('👉 Install guide: https://docs.flutter.dev/get-started/install');
    return 1;
  }
}

async function runInit(parsed) {
  const options = resolveInitOptions(parsed);
  if (!options.skipDoctor) {
    validateFlutterEnvironment({ dryRun: options.dryRun });
  }

  let projectName = options.projectName;
  let stateKey = options.stateKey;

  if (!options.yes || !projectName) {
    const details = await promptForProjectDetails({
      projectName,
      stateLabel: STATE_CHOICES[stateKey].label
    });
    projectName = details.projectName;
    stateKey = resolveStateFromLabelOrKey(details.stateLabel);
  }

  if (!isValidFlutterProjectName(projectName)) {
    throw new Error(`Invalid Flutter project name "${projectName}".`);
  }

  const state = STATE_CHOICES[stateKey];
  console.log(`🚀 Creating Flutter project: ${projectName}`);
  runCommand(`flutter create ${projectName}`, { dryRun: options.dryRun });

  const projectPath = path.join(process.cwd(), projectName);
  const templatePath = path.join(__dirname, 'lib_template', state.modeFolder);
  const destLibPath = path.join(projectPath, 'lib');

  if (!options.dryRun) {
    copyRecursive(templatePath, destLibPath);
    replacePackageImports(destLibPath, state.oldPackageName, projectName);
    createStandardStructure(projectPath);
    ensureDirectory(path.join(projectPath, 'assets', 'images'));
    updatePubspec(path.join(projectPath, 'pubspec.yaml'));
    if (stateKey === 'provider') createL10nConfig(projectPath);
    createQualityFiles(projectPath);
    const dependencies = [...new Set([...COMMON_DEPENDENCIES, ...state.stateDeps])];
    addDependencies(projectPath, dependencies, options);
  } else {
    console.log(`🧪 [dry-run] would copy template ${state.modeFolder}`);
    console.log('🧪 [dry-run] would update pubspec.yaml, create assets/images, and install dependencies');
  }

  console.log(`✅ Flutter project "${projectName}" with ${state.label} setup is ready.`);
}

function runGenerate(parsed) {
  const kind = parsed._[1];
  const name = parsed._[2];
  if (!kind || !name) {
    throw new Error('Usage: flutter-init generate <module|screen> <name> [--project path]');
  }
  const projectPath = path.resolve(process.cwd(), parsed.flags.project || '.');
  const libPath = detectProjectLibPath(projectPath);
  if (kind === 'module') {
    generateModule(libPath, name);
    return;
  }
  if (kind === 'screen') {
    generateScreen(libPath, name);
    return;
  }
  throw new Error(`Unknown generate target "${kind}". Use module or screen.`);
}

async function main() {
  const parsed = parseArgs(process.argv.slice(2));
  if (parsed.flags.help || parsed.flags.h) {
    printHelp();
    return;
  }
  const command = parsed._[0] || 'init';

  try {
    if (command === '--help' || command === '-h' || command === 'help') {
      printHelp();
      return;
    }
    if (command === 'doctor') {
      process.exitCode = runDoctor();
      return;
    }
    if (command === 'generate') {
      runGenerate(parsed);
      return;
    }
    if (command === 'init') {
      await runInit(parsed);
      return;
    }
    if (!command.startsWith('-')) {
      parsed._.unshift('init');
      await runInit(parsed);
      return;
    }
    printHelp();
    process.exitCode = 1;
  } catch (error) {
    console.error(`❌ ${error.message}`);
    process.exitCode = 1;
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  parseArgs,
  slugify,
  isValidFlutterProjectName,
  resolveStateKey,
  toCamelCase,
  toPascalCase
};
