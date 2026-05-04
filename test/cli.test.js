const test = require('node:test');
const assert = require('node:assert/strict');

const {
  parseArgs,
  slugify,
  isValidFlutterProjectName,
  resolveStateKey,
  toCamelCase,
  toPascalCase
} = require('../cli');

test('parseArgs supports command, positionals, and key=value flags', () => {
  const parsed = parseArgs([
    'init',
    'my_app',
    '--state=bloc',
    '--yes',
    '--config',
    'flutter_create.config.json'
  ]);

  assert.equal(parsed._[0], 'init');
  assert.equal(parsed._[1], 'my_app');
  assert.equal(parsed.flags.state, 'bloc');
  assert.equal(parsed.flags.yes, true);
  assert.equal(parsed.flags.config, 'flutter_create.config.json');
});

test('slugify converts human names to flutter-safe names', () => {
  assert.equal(slugify('My Awesome App'), 'my_awesome_app');
  assert.equal(slugify('___Demo___App___'), 'demo_app');
  assert.equal(slugify('123 TEST'), '123_test');
});

test('isValidFlutterProjectName validates required format', () => {
  assert.equal(isValidFlutterProjectName('my_app_2'), true);
  assert.equal(isValidFlutterProjectName('_my_app'), false);
  assert.equal(isValidFlutterProjectName('2myapp'), false);
  assert.equal(isValidFlutterProjectName('MyApp'), false);
});

test('resolveStateKey supports multiple aliases', () => {
  assert.equal(resolveStateKey('simple_getx'), 'simple_getx');
  assert.equal(resolveStateKey('reactive_getx'), 'reactive_getx');
  assert.equal(resolveStateKey('with_reactive_getx'), 'reactive_getx');
  assert.equal(resolveStateKey('provider'), 'provider');
  assert.equal(resolveStateKey('bloc'), 'bloc');
  assert.equal(resolveStateKey('riverpod'), null);
});

test('toCamelCase and toPascalCase transform names consistently', () => {
  assert.equal(toCamelCase('user_profile'), 'userProfile');
  assert.equal(toCamelCase('User Profile'), 'userProfile');
  assert.equal(toPascalCase('user_profile'), 'UserProfile');
});
