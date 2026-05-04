#!/usr/bin/env node

const inquirer = require('inquirer');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Recursively copy a folder
function copyRecursive(src, dest) {
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });

  fs.readdirSync(src, { withFileTypes: true }).forEach(entry => {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyRecursive(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  });
}

function replacePackageImports(libPath, oldName, newName) {
  const dartFiles = fs.readdirSync(libPath, { recursive: true })
    .filter(file => file.endsWith('.dart'));

  dartFiles.forEach(file => {
    const fullPath = path.join(libPath, file);
    let content = fs.readFileSync(fullPath, 'utf-8');
    const updated = content.replaceAll(`package:${oldName}/`, `package:${newName}/`);
    fs.writeFileSync(fullPath, updated, 'utf-8');
  });

  console.log(`🔧 Updated all import paths from "${oldName}" to "${newName}".`);
}

function addDependencies(projectPath, dependencies) {
  const originalCwd = process.cwd();
  process.chdir(projectPath); // Switch to the new project's directory

  try {
    dependencies.forEach(dep => {
      console.log(`📦 Adding dependency: ${dep}`);
      execSync(`flutter pub add ${dep}`, { stdio: 'inherit' });
    });
  } finally {
    process.chdir(originalCwd); // Revert back to original path
  }
}

/// project name validation
function slugify(input) {
  return input
    .toLowerCase()
    .replace(/[^a-z0-9_]+/g, '_')   // Replace illegal characters with underscores
    .replace(/^_+|_+$/g, '')        // Trim leading/trailing underscores
    .replace(/_{2,}/g, '_');        // Collapse multiple underscores
}

function isValidFlutterProjectName(name) {
  return /^[a-z][a-z0-9_]*$/.test(name);
}


// Project name validation helpers
function slugify(input) {
  return input
    .toLowerCase()
    .replace(/[^a-z0-9_]+/g, '_')   // Replace illegal characters with underscores
    .replace(/^_+|_+$/g, '')        // Trim leading/trailing underscores
    .replace(/_{2,}/g, '_');        // Collapse multiple underscores
}

function isValidFlutterProjectName(name) {
  return /^[a-z][a-z0-9_]*$/.test(name);
}

async function promptForProjectDetails() {
  let projectNameRaw = '';
  let projectName = '';

  while (true) {
    const { projectNameInput } = await inquirer.prompt([
      {
        name: 'projectNameInput',
        message: 'Enter your Flutter project name:',
        validate: input => {
          if (!input.trim()) return 'Project name cannot be empty.';
          const sanitized = slugify(input);
          if (!isValidFlutterProjectName(sanitized)) {
            return 'Invalid name. Must start with a letter and contain only lowercase letters, numbers, and underscores.';
          }
          return true;
        }
      }
    ]);

    projectNameRaw = projectNameInput;
    projectName = slugify(projectNameRaw);

    if (projectName !== projectNameRaw) {
      const { confirm } = await inquirer.prompt([
        {
          type: 'confirm',
          name: 'confirm',
          message: `Use "${projectName}" as your sanitized project name?`,
          default: true
        }
      ]);

      if (confirm) break;
    } else {
      break;
    }
  }

  const { stateManagement } = await inquirer.prompt([
    {
      type: 'list',
      name: 'stateManagement',
      message: 'Choose state management type:',
      choices: ['Simple Getx', 'Reactive Getx', 'Provider', 'Bloc']
    }
  ]);

  return { projectName, stateManagement };
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

function validateFlutterEnvironment() {
  console.log('🔍 Validating environment...');

  if (!isCommandAvailable('flutter')) {
    console.error('❌ Flutter is not installed or not in your PATH.');
    console.log('👉 Please install Flutter from https://docs.flutter.dev/get-started/install');
    process.exit(1);
  }

  if (!isCommandAvailable('dart')) {
    console.error('❌ Dart is not installed or not in your PATH.');
    console.log('👉 Dart is usually bundled with Flutter. Make sure Flutter is properly installed.');
    process.exit(1);
  }

  try {
    const flutterDoctor = execSync('flutter doctor', { encoding: 'utf8' });
    console.log(flutterDoctor);
  } catch (error) {
    console.error('❌ Failed to run `flutter doctor`.');
    console.log('🛠 Please ensure Flutter is fully installed and configured.');
    process.exit(1);
  }

  console.log('✅ Flutter environment looks good!\n');
}

async function main() {
  // const { projectName, stateManagement } = await inquirer.prompt([
  //   {
  //     name: 'projectName',
  //     message: 'Enter your Flutter project name:',
  //     validate: input => !!input || 'Project name cannot be empty.',
  //   },
  //   {
  //     type: 'list',
  //     name: 'stateManagement',
  //     message: 'Choose state management type:',
  //     choices: ['Simple Getx', 'Reactive Getx'],
  //   }
  // ]);

  validateFlutterEnvironment();
  const { projectName, stateManagement } = await promptForProjectDetails();

  // 1. Create the Flutter project
  console.log(`🚀 Creating Flutter project: ${projectName}`);
  execSync(`flutter create ${projectName}`, { stdio: 'inherit' });

  // 2. Determine which template to use
  const modeFolder = stateManagement === 'Reactive Getx' ? 'with_reactive_getx' :
  stateManagement === 'Provider' ? 'with_provider' :
  stateManagement === 'Bloc' ? 'with_bloc' :
  'with_simple_getx';
  const templatePath = path.join(__dirname, 'lib_template', modeFolder);
  const destLibPath = path.join(process.cwd(), projectName, 'lib');

  console.log(`📁 Copying ${stateManagement} lib structure...`);
  copyRecursive(templatePath, destLibPath);

  // 3. Replace imports
  const oldProjectName = stateManagement === 'Reactive Getx' ? 'flutter_with_reactive_getx' :
  stateManagement === 'Provider' ? 'provider_project' :
  stateManagement === 'Bloc' ? 'bloc_project' :
  'flutter_standard';
  replacePackageImports(destLibPath, oldProjectName, projectName);

  // 4.1 Create assets/images folder
  const assetsImagesPath = path.join(process.cwd(), projectName, 'assets', 'images');
  fs.mkdirSync(assetsImagesPath, { recursive: true });
  console.log('📁 Created assets/images folder.');

  // 4.2 Update pubspec.yaml to include assets after uses-material-design
  const pubspecPath = path.join(process.cwd(), projectName, 'pubspec.yaml');
  let pubspec = fs.readFileSync(pubspecPath, 'utf-8');

  // Check if the correct assets path is already present
  if (!pubspec.includes('  assets:\n    - assets/images/')) {
    // Regex to match the default commented assets section only
    const commentedAssetsRegex = /  # To add assets to your application.*?(?:  # .*\n)*  # assets:\n(?:  #.*\n)*/g;

    let updatedPubspec = pubspec;

    if (commentedAssetsRegex.test(pubspec)) {
      // Replace the whole commented section with our actual assets block
      updatedPubspec = pubspec.replace(
        commentedAssetsRegex,
        '  generate: true\n  assets:\n    - assets/images/\n'
      );
      console.log('📝 Commented assets section replaced.');
    } else {
      // If commented section not found, just add it below uses-material-design
      updatedPubspec = pubspec.replace(
        /  uses-material-design: true\n/,
        '  uses-material-design: true\n\n  generate: true\n  assets:\n    - assets/images/\n'
      );
      console.log('📝 Assets section added below uses-material-design.');
    }

    fs.writeFileSync(pubspecPath, updatedPubspec, 'utf-8');
    console.log('✅ Updated pubspec.yaml with assets/images/');
  } else {
    console.log('ℹ️ pubspec.yaml already contains assets/images/');
  }
  if (stateManagement === 'Provider') {
  /// Add l10n.yaml file
  const l10nPath = path.join(process.cwd(), projectName, 'l10n.yaml');

  const l10nContent = `
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
synthetic-package: false
`;

  fs.writeFileSync(l10nPath, l10nContent.trimStart(), 'utf-8');
  console.log('✅ Created l10n.yaml for localization config.');

  }

  //4. Adding dependencies
  let dependencies = [
    'get_storage',
    'dynamicutils',
    'image_picker',
    'shared_preferences',
    'cached_network_image',
    'http',
    'connectivity_plus',
    'file_picker',
    'flutter_offline',
  ];
  
  if (stateManagement === 'Provider') {
    dependencies.push('provider', 'flutter_localization');
  } else if (stateManagement === 'Bloc') {
    dependencies.push('flutter_bloc', 'equatable');
  } else {
    dependencies.push('get', 'get_storage'); // Only GetX types
  }
  addDependencies(path.join(process.cwd(), projectName), dependencies);

  console.log(`✅ Flutter project "${projectName}" with ${stateManagement} setup is ready!`);
}

main();
