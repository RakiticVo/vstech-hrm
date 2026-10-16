import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/core/widgets/app_toast.dart';

void main() {
  testWidgets('AppToastCard renders message, title and triggers action', (tester) async {
    var actionTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: AppToastCard(
            title: 'Thông báo',
            message: 'Thao tác hoàn tất thành công',
            type: ToastType.success,
            actionLabel: 'Đóng',
            onAction: () => actionTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Thao tác hoàn tất thành công'), findsOneWidget);
    expect(find.text('Đóng'), findsOneWidget);

    await tester.tap(find.text('Đóng'));
    expect(actionTapped, isTrue);
  });

  testWidgets('AppToast.showSuccess displays floating toast on Scaffold', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => context.showSuccessToast('Gửi thành công!'),
              child: const Text('Show Success'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Success'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 300)); // Animate in

    expect(find.text('Gửi thành công!'), findsOneWidget);
    expect(find.byType(AppToastCard), findsOneWidget);
  });

  testWidgets('AppToast.showError displays error toast with title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => context.showErrorToast('Lỗi máy chủ', title: 'Thất bại'),
              child: const Text('Show Error'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Error'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Thất bại'), findsOneWidget);
    expect(find.text('Lỗi máy chủ'), findsOneWidget);
    expect(find.byType(AppToastCard), findsOneWidget);
  });
}
