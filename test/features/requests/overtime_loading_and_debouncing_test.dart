import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_modal_components.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_request_modal.dart';
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
    home: Scaffold(body: child),
  );
}

void main() {
  group('Overtime Loading and Debouncing Tests', () {
    testWidgets('OvertimeSubmitButton shows spinner and disables when isSubmitting is true', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        _wrapWithApp(
          OvertimeSubmitButton(
            title: 'Xác nhận gửi',
            isSubmitting: true,
            onPressed: () => tapCount++,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Xác nhận gửi'), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(tapCount, 0);
    });

    testWidgets('OvertimeRequestModal prevents double submission while in flight', (tester) async {
      var callCount = 0;
      final completer = Completer<String?>();

      await tester.pumpWidget(
        _wrapWithApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    OvertimeRequestModal.show(
                      context,
                      initialDate: DateTime(2026, 10, 15),
                      availableTypes: const [
                        OvertimeTypeEntity(code: 'OT_WEEKDAY', name: 'Tăng ca ngày thường'),
                      ],
                      onConfirm: (type, date, start, end, length, reason, {accept, employeeCode, employeeName}) {
                        callCount++;
                        return completer.future;
                      },
                    ),
                  );
                },
                child: const Text('Open Modal'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();
      expect(find.text('Nhập thông tin tăng ca'), findsOneWidget);

      // Enter reason so validation passes
      await tester.enterText(find.byType(TextField), 'Dự án ra mắt sản phẩm mới');
      await tester.pump();

      // First tap on submit button
      final submitBtn = find.text('Xác nhận gửi');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pump();

      expect(callCount, 1);
      // Button should now show CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Second rapid tap while in flight
      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pump();
      expect(callCount, 1); // Guard prevented 2nd call!

      // Complete async submission with error
      completer.complete('Ngày 2026-10-15 đã được đăng ký');
      await tester.pump();

      // Modal stays open and displays error banner
      expect(find.text('Nhập thông tin tăng ca'), findsOneWidget);
      expect(find.text('Ngày 2026-10-15 đã được đăng ký'), findsOneWidget);
      expect(find.text('Xác nhận gửi'), findsOneWidget);
    });
  });
}
