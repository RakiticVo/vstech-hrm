import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/holidays/domain/usecases/get_holidays_usecase.dart';

/// Screen 08: National Holidays and Compensatory Leave days matching reference design.
class HolidaysScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  bool _isLoading = false;
  List<_HolidayItem> _holidays = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadHolidays());
  }

  Future<void> _loadHolidays() async {
    setState(() => _isLoading = true);
    final result = await sl<GetHolidaysUseCase>()();
    if (!mounted) return;
    final colors = context.colors;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _holidays = entities.map((h) {
            var day = '01';
            var month = 'TH1';
            if (h.date.contains('-')) {
              final parts = h.date.split('-');
              if (parts.length >= 3) {
                day = parts[2].padLeft(2, '0');
                month = 'TH${int.tryParse(parts[1]) ?? 1}';
              }
            } else if (h.date.contains('/')) {
              final parts = h.date.split('/');
              if (parts.length >= 2) {
                day = parts[0].padLeft(2, '0');
                month = 'TH${int.tryParse(parts[1]) ?? 1}';
              }
            }
            final isOptional = h.symbol?.toLowerCase().contains('opt') ?? false;
            final tintColor = isOptional ? colors.accentAmber : colors.primaryIndigo;
            final bgTint = tintColor.withValues(alpha: isOptional ? 0.14 : 0.12);
            return _HolidayItem(
              day,
              month,
              h.name,
              h.symbol ?? 'Ngày nghỉ lễ',
              isOptional ? 'Tự chọn' : 'Ngày lễ',
              tintColor,
              bgTint,
            );
          }).toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.holidaysTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                context.l10n.year2026,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryIndigo,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHolidays,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            // 3 Top Stat Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('${_holidays.length}', context.l10n.nationalHolidaysStat, colors),
                ),
                10.gapW,
                Expanded(
                  child: _buildStatCard('3', context.l10n.compensatoryLeaveStat, colors),
                ),
                10.gapW,
                Expanded(
                  child: _buildStatCard('2', context.l10n.optionalHolidaysStat, colors),
                ),
              ],
            ),
            18.gapH,

            // Holiday Items List
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              ..._holidays.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => context.push(AppRoutes.overtimeCreate),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: colors.border),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                      // Date Box Badge
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: h.bgTint,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              h.day,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: h.tintColor,
                                height: 1,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              h.month,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: h.tintColor,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.title,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              h.dayOfWeek,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Pill Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: h.bgTint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          h.tag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: h.tintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: colors.primaryIndigo,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HolidayItem {
  const new(
    this.day,
    this.month,
    this.title,
    this.dayOfWeek,
    this.tag,
    this.tintColor,
    this.bgTint,
  );

  final String day;
  final String month;
  final String title;
  final String dayOfWeek;
  final String tag;
  final Color tintColor;
  final Color bgTint;
}
