// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VSTech HRM';

  @override
  String get login => 'Sign In';

  @override
  String get employeeCode => 'Employee ID';

  @override
  String get password => 'Password';

  @override
  String get checkIn => 'Check In';

  @override
  String get checkOut => 'Check Out';

  @override
  String get home => 'Home';

  @override
  String get attendance => 'Attendance';

  @override
  String get requests => 'Requests';

  @override
  String get approvals => 'Approvals';

  @override
  String get payroll => 'Payroll';

  @override
  String get profile => 'Profile';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get contactHr => 'Contact HR';
}
