import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';

/// Cubit managing dynamic ThemeMode (system, light, dark) across the application.
class ThemeCubit extends Cubit<ThemeMode> {
  new({
    required this._secureStorage,
  }) : super(ThemeMode.system) {
    unawaited(_loadThemeMode());
  }

  final FlutterSecureStorage _secureStorage;
  static const String _themeStorageKey = 'vstech_theme_mode';

  Future<void> _loadThemeMode() async {
    try {
      final savedMode = await _secureStorage.read(key: _themeStorageKey);
      if (savedMode == 'light') {
        emit(ThemeMode.light);
      } else if (savedMode == 'dark') {
        emit(ThemeMode.dark);
      } else {
        emit(ThemeMode.system);
      }
    } on Object catch (e) {
      appLogger.w('Failed to load theme mode, using default system', error: e);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    try {
      String value;
      switch (mode) {
        case ThemeMode.light:
          value = 'light';
        case ThemeMode.dark:
          value = 'dark';
        case ThemeMode.system:
          value = 'system';
      }
      await _secureStorage.write(key: _themeStorageKey, value: value);
    } on Object catch (e) {
      appLogger.w('Failed to save theme mode', error: e);
    }
  }
}
