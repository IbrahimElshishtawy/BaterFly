import 'dart:io';

Future<void> preBuild() async {
  stdout.writeln('🔧 Running pre-build checks...');

  final buildDir = Directory('build');
  if (buildDir.existsSync()) {
    stdout.writeln('🧹 Cleaning old build folder...');
    buildDir.deleteSync(recursive: true);
  }

  final envFile = File('.env');
  if (!envFile.existsSync()) {
    stdout.writeln(
      '⚠️  Warning: .env file not found. Please create it before build.',
    );
  }

  stdout.writeln('✅ Pre-build checks completed.');
}
