import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_state.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/risk_alert_card.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/risk_tier_summary_pills.dart';

class RiskComplianceScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<RiskComplianceScreen> createState() => _RiskComplianceScreenState();
}

class _RiskComplianceScreenState extends State<RiskComplianceScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<RiskAlertsCubit>().fetchRiskAlerts());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      body: SafeArea(
        child: BlocConsumer<RiskAlertsCubit, RiskAlertsState>(
          listener: (context, state) {
            if (state is RiskAlertsLoaded && state.actionMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.riskAssignedSuccess),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(context),
                if (state is RiskAlertsLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is RiskAlertsError)
                  Expanded(
                    child: Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else if (state is RiskAlertsLoaded) ...[
                  AppGap.h12,
                  RiskTierSummaryPills(
                    criticalCount: state.criticalCount,
                    highCount: state.highCount,
                    mediumCount: state.mediumCount,
                  ),
                  AppGap.h12,
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          context.read<RiskAlertsCubit>().fetchRiskAlerts(),
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          context.w(16),
                          0,
                          context.w(16),
                          context.h(24),
                        ),
                        itemCount: state.alerts.length,
                        separatorBuilder: (context, _) => AppGap.h12,
                        itemBuilder: (context, index) {
                          final alert = state.alerts[index];
                          return RiskAlertCard(
                            alert: alert,
                            onAssignToHr: () {
                              unawaited(
                                context
                                    .read<RiskAlertsCubit>()
                                    .assignToHr(alert.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(8),
      ),
      child: Row(
        children: [
          Material(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: context.w(38),
                height: context.w(38),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          AppGap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.riskTitle,
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                AppGap.h2,
                Text(
                  l10n.riskCaption,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
