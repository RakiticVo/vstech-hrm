import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vstech_hrm/app.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Lock screen orientation to Portrait only (as per AGENTS.md spec)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 2. Load environment variables from .env
  try {
    await dotenv.load();
  } on Object catch (e) {
    // If .env is missing or invalid, fallback gracefully
    appLogger.w('Could not load .env file, relying on defaults', error: e);
  }

  // 3. Initialize GetIt Dependency Injection
  await initDependencies();

  // 4. Launch Root App
  runApp(const VSTechHrmApp());
}
