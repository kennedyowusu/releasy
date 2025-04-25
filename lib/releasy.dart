import 'dart:io';

void runReleasy() async {
  stdout.writeln('\n📦 Releasy CLI — Your Dart Release Assistant');
  stdout.write('🔖 Enter release version (e.g. v1.2.1): ');
  final String versionInput = stdin.readLineSync() ?? '';

  if (!RegExp(r'^v\\d+\\.\\d+\\.\\d+\$').hasMatch(versionInput)) {
    stderr.writeln('❌ Invalid version format. Use "vX.Y.Z"');
    exit(1);
  }

  final version = versionInput.replaceFirst('v', '');
  final buildNumber = DateTime.now().millisecondsSinceEpoch % 1000 + 60;
  final fullVersion = '$version+$buildNumber';

  // Git safety checks
  stdout.writeln('🔍 Checking for uncommitted changes...');
  final result = await Process.run('git', ['status', '--porcelain']);
  if (result.stdout.toString().trim().isNotEmpty) {
    stderr.writeln('❌ Uncommitted changes found. Please commit or stash them.');
    exit(1);
  }

  stdout.writeln('🔍 Checking for unpushed commits...');
  final unpushed = await Process.run('git', ['log', '@{upstream}..HEAD']);
  if (unpushed.stdout.toString().trim().isNotEmpty) {
    stderr.writeln('❌ Unpushed commits found. Please push them first.');
    exit(1);
  }

  stdout.writeln('🔍 Checking for existing tag...');
  final existingTag = await Process.run('git', ['tag', '--list', versionInput]);
  if (existingTag.stdout.toString().trim().isNotEmpty) {
    stderr.writeln('❌ Tag already exists. Please use a different version.');
    exit(1);
  }

  // Metadata
  stdout.write('📝 Enter release title: ');
  final title = stdin.readLineSync();

  final changelogFile = File('tool/changelog_$versionInput.md');
  changelogFile.createSync(recursive: true);

  stdout.writeln(
      '\n✍️ Paste changelog below (Markdown). Press CTRL+D to finish:\n');
  final changelog = await stdin.transform(SystemEncoding().decoder).join();
  changelogFile.writeAsStringSync(changelog.trim());

  // Ensure pubspec.yaml exists
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    stderr.writeln(
        '❌ pubspec.yaml not found. Run this from the root of a Dart project.');
    exit(1);
  }

  final updated = await pubspec.readAsLines().then((lines) => lines
      .map((line) =>
          line.startsWith('version:') ? 'version: $fullVersion' : line)
      .toList());
  await pubspec.writeAsString(updated.join('\n'));

  stdout.writeln('📦 pubspec.yaml updated to: $fullVersion');

  await Process.run('git', ['add', 'pubspec.yaml']);

  final diff = await Process.run('git', ['diff', '--cached']);
  final diffOutput = diff.stdout.toString().trim();
  if (diffOutput.isNotEmpty) {
    stdout.writeln('\n🔍 Git diff preview:\n$diffOutput');
  } else {
    stdout.writeln('\n🔍 No changes to preview.');
  }

  stdout.write('\n🚀 Ready to tag and release $versionInput? (y/n): ');
  if ((stdin.readLineSync() ?? '').toLowerCase() != 'y') {
    stdout.writeln('❌ Cancelled.');
    exit(0);
  }

  await Process.run(
      'git', ['commit', '-m', 'chore: bump version to $versionInput']);
  await Process.run(
      'git', ['tag', '-a', versionInput, '-F', changelogFile.path]);
  await Process.run('git', ['push']);
  await Process.run('git', ['push', 'origin', versionInput]);

  final gh = await Process.run('gh', [
    'release',
    'create',
    versionInput,
    '-F',
    changelogFile.path,
    '-t',
    title ?? '',
    '--draft'
  ]);

  stdout.writeln(gh.exitCode == 0
      ? '🎉 Draft GitHub release created for $versionInput!'
      : '⚠️ GitHub release failed:\n${gh.stderr}');
}
