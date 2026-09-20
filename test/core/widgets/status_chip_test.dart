import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

void main() {
  testWidgets('StatusChip renders label correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [AppColorsExtension.light],
        ),
        home: const Scaffold(
          body: StatusChip(
            label: 'Chờ duyệt',
            type: AppStatusType.pending,
          ),
        ),
      ),
    );

    expect(find.text('Chờ duyệt'), findsOneWidget);
  });
}
