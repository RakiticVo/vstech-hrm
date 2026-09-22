import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';

/// Cubit managing dynamic Locale (vi, en) across the application.
class LocaleCubit extends Cubit<Locale> {
  new({
    required this._secureStorage,
  }) : super(const Locale('vi')) {
    unawaited(_loadLocale());
  }

  final FlutterSecureStorage _secureStorage;
  static const String _localeStorageKey = 'vstech_locale';

  Future<void> _loadLocale() async {
    try {
      final savedLocale = await _secureStorage.read(key: _localeStorageKey);
      if (savedLocale == 'en') {
        emit(const Locale('en'));
      } else {
        emit(const Locale('vi'));
      }
    } on Object catch (e) {
      appLogger.w('Failed to load locale, using default Vietnamese', error: e);
    }
  }

  Future<void> setLocale(Locale locale) async {
    emit(locale);
    try {
      await _secureStorage.write(
        key: _localeStorageKey,
        value: locale.languageCode,
      );
    } on Object catch (e) {
      appLogger.w('Failed to save locale', error: e);
    }
  }
}
