// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'VSTech HRM';

  @override
  String get login => 'Đăng nhập';

  @override
  String get employeeCode => 'Mã nhân viên';

  @override
  String get password => 'Mật khẩu';

  @override
  String get checkIn => 'Chấm công';

  @override
  String get checkOut => 'Tan ca';

  @override
  String get home => 'Trang chủ';

  @override
  String get attendance => 'Chấm công';

  @override
  String get requests => 'Yêu cầu';

  @override
  String get approvals => 'Phê duyệt';

  @override
  String get payroll => 'Bảng lương';

  @override
  String get profile => 'Cá nhân';

  @override
  String get errorOccurred => 'Đã có lỗi xảy ra';

  @override
  String get retry => 'Thử lại';

  @override
  String get contactHr => 'Liên hệ HR';
}
