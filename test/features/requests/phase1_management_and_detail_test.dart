import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/correction_manage_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/leave_manage_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/overtime_manage_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/request_detail_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/request_sent_screen.dart';
import 'package:vstech_hrm/features/schedule/presentation/screens/shift_swaps_screen.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi')],
    locale: const Locale('vi'),
    home: child,
  );
}

void main() {
  group('Phase 1 Management & Detail Screens Tests', () {
    testWidgets('RequestDetailScreen renders fields, requester and timeline', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const RequestDetailScreen(
            requestCode: 'RQ-2026-0934',
            title: 'Nghỉ phép năm · 1 ngày',
            category: 'leave',
            requesterName: 'Nguyễn Minh Tuấn (NV-04821)',
            department: 'Vận hành · Chi nhánh 01',
            initialStatus: 'pending',
            isApprover: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('RQ-2026-0934'), findsOneWidget);
      expect(find.text('Nghỉ phép năm · 1 ngày'), findsOneWidget);
      expect(find.text('Nguyễn Minh Tuấn (NV-04821)'), findsOneWidget);
      expect(find.text('Hủy yêu cầu'), findsOneWidget);
    });

    testWidgets('RequestDetailScreen approver mode renders approve and reject buttons', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const RequestDetailScreen(
            requestCode: 'RQ-2026-0934',
            title: 'Nghỉ phép năm · 1 ngày',
            category: 'leave',
            requesterName: 'Nguyễn Minh Tuấn (NV-04821)',
            initialStatus: 'pending',
            isApprover: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Duyệt'), findsOneWidget);
      expect(find.text('Từ chối'), findsOneWidget);
    });

    testWidgets('LeaveManageScreen renders balance card and leave requests', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const LeaveManageScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Số phép năm'), findsOneWidget);
      expect(find.text('Tạo đơn nghỉ phép'), findsOneWidget);
      expect(find.text('Nghỉ phép năm · 1 ngày'), findsOneWidget);
    });

    testWidgets('OvertimeManageScreen renders overtime breakdown and total hours', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const OvertimeManageScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Tổng giờ tăng ca'), findsOneWidget);
      expect(find.text('10.0h'), findsOneWidget);
      expect(find.text('Đăng ký tăng ca'), findsOneWidget);
    });

    testWidgets('CorrectionManageScreen renders quota and missing punch alert', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const CorrectionManageScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Hạn mức sửa công tháng này'), findsOneWidget);
      expect(find.text('Thứ Ba, 15/09 · Thiếu giờ ra'), findsOneWidget);
      expect(find.text('Sửa công ngay'), findsOneWidget);
    });

    testWidgets('ShiftSwapsScreen toggles between sent and received tabs', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const ShiftSwapsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Đơn gửi đi'), findsOneWidget);
      expect(find.text('Đơn nhận được'), findsOneWidget);
      expect(find.text('Phạm Thu Hương (NV-0091)'), findsOneWidget);

      await tester.tap(find.text('Đơn nhận được'));
      await tester.pumpAndSettle();

      expect(find.text('Trần Văn Nam (NV-0089)'), findsOneWidget);
    });

    testWidgets('RequestSentScreen renders confirmation and back action', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const RequestSentScreen(
            requestCode: 'RQ-2026-0935',
            requestTitle: 'Nghỉ phép năm · 1 ngày',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gửi thành công'), findsOneWidget);
      expect(find.text('RQ-2026-0935'), findsOneWidget);
      expect(find.text('Về danh sách'), findsOneWidget);
      expect(find.text('Xem chi tiết yêu cầu'), findsOneWidget);
    });
  });
}
