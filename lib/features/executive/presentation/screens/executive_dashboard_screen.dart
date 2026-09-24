import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_state.dart';
import 'package:vstech_hrm/features/executive/presentation/widgets/executive_dept_progress_card.dart';
import 'package:vstech_hrm/features/executive/presentation/widgets/executive_hero_waiting_card.dart';
import 'package:vstech_hrm/features/executive/presentation/widgets/executive_kpi_grid.dart';

class ExecutiveDashboardScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ExecutiveDashboardScreen> createState() => _ExecutiveDashboardScreenState();
}

class _ExecutiveDashboardScreenState extends State<ExecutiveDashboardScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<ExecutiveCubit>().loadOverview());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<ExecutiveCubit, ExecutiveState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = state.stats;
          if (stats == null) {
            return Center(
              child: Text(state.errorMessage ?? 'Không thể tải dữ liệu'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ExecutiveCubit>().loadOverview(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Saigon Tile Executive Header
                  CustomPaint(
                    painter: TilePatternPainter(
                      backgroundColor: colors.primaryIndigo,
                      patternColor: const Color(0xFFFFF8EC).withValues(alpha: 0.12),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        MediaQuery.paddingOf(context).top + 16,
                        16,
                        48,
                      ),
                      color: colors.primaryIndigo,
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8EC),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text(
                                'LH',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F766E),
                                ),
                              ),
                            ),
                          ),
                          12.gapW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.execRoleTag,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.4,
                                    color: Color(0xFFFFF8EC),
                                  ),
                                ),
                                2.gapH,
                                Text(
                                  l10n.execGreeting,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Symbols.notifications, color: Colors.white),
                            onPressed: () => context.push(AppRoutes.notifications),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Hero Waiting Card (Negative margin overlapping header)
                  Transform.translate(
                    offset: const Offset(0, -28),
                    child: ExecutiveHeroWaitingCard(
                      waitingCount: stats.pendingFinalApprovalsCount,
                      oldestHours: stats.oldestPendingHours,
                      onTap: () => context.push(AppRoutes.finalApproval),
                    ),
                  ),

                  // 3. KPI Metrics
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.execCompanyNow,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: colors.textSecondary,
                          ),
                        ),
                        10.gapH,
                        ExecutiveKpiGrid(stats: stats),
                        24.gapH,

                        // 4. Urgent Risks Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.execNeedAttention,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: colors.error.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${stats.flaggedRisks.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: colors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.gapH,
                        for (final r in stats.flaggedRisks)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border(
                                top: BorderSide(color: colors.border),
                                right: BorderSide(color: colors.border),
                                bottom: BorderSide(color: colors.border),
                                left: BorderSide(
                                  color: r.tier == 'critical'
                                      ? colors.error
                                      : colors.accentAmber,
                                  width: 4,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        r.title,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w800,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      r.metricValue,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: r.tier == 'critical'
                                            ? colors.error
                                            : colors.accentAmber,
                                      ),
                                    ),
                                  ],
                                ),
                                4.gapH,
                                Text(
                                  r.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        10.gapH,
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: () => context.push(AppRoutes.riskCompliance),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.primaryIndigo,
                              side: BorderSide(color: colors.primaryIndigo),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.execSeeAllAlerts,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                                6.gapW,
                                const Icon(Symbols.chevron_right, size: 18),
                              ],
                            ),
                          ),
                        ),
                        24.gapH,

                        // 5. Attendance by Workshop & Department
                        Text(
                          l10n.execAttendanceByDept,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        10.gapH,
                        ExecutiveDeptProgressCard(
                          departments: stats.departmentRates,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
