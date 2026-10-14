import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/calendar/presentation/widgets/calendar_timesheet_view.dart';

/// Screen C1: Standardized 5-Color Monthly Timesheet Calendar with Red-day Correction shortcut.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: l10n.calendarScreenTitle,
            subtitle: l10n.calendarSubtitle,
            onBack: () => context.pop(),
          ),
          const Expanded(
            child: CalendarTimesheetView(),
          ),
        ],
      ),
    );
  }
}
