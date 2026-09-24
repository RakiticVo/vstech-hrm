import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_state.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/active_delegation_card.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/delegation_limit_card.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/delegation_period_card.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/delegation_person_card.dart';
import 'package:vstech_hrm/features/compliance/presentation/widgets/delegation_scope_toggle.dart';

class DelegationCenterScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DelegationCenterScreen> createState() => _DelegationCenterScreenState();
}

class _DelegationCenterScreenState extends State<DelegationCenterScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<DelegationCubit>().loadInitialData());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      body: SafeArea(
        child: BlocConsumer<DelegationCubit, DelegationState>(
          listener: (context, state) {
            if (state is DelegationLoaded && state.successMessage != null) {
              final msg = state.successMessage == 'created'
                  ? l10n.delCreateSuccess
                  : l10n.delRevokeSuccess;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
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
                if (state is DelegationLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is DelegationError)
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
                else if (state is DelegationLoaded)
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        context.w(16),
                        context.h(8),
                        context.w(16),
                        context.h(32),
                      ),
                      children: [
                        _buildSectionTitle(l10n.delSelectPerson),
                        ...state.eligibleDelegates.map(
                          (person) => Padding(
                            padding: EdgeInsets.only(bottom: context.h(8)),
                            child: DelegationPersonCard(
                              person: person,
                              isSelected: state.selectedPerson?.id == person.id,
                              onTap: () => context
                                  .read<DelegationCubit>()
                                  .selectPerson(person),
                            ),
                          ),
                        ),
                        AppGap.h12,
                        _buildSectionTitle(l10n.delPeriod),
                        DelegationPeriodCard(
                          fromDate: state.fromDate,
                          toDate: state.toDate,
                          onSelectDateRange: (from, to) {
                            context
                                .read<DelegationCubit>()
                                .setDateRange(from, to);
                          },
                        ),
                        AppGap.h12,
                        _buildSectionTitle(l10n.delScope),
                        DelegationScopeToggle(
                          isAllScope: state.isAllScope,
                          onScopeChanged: (val) => context
                              .read<DelegationCubit>()
                              .setScope(isAllScope: val),
                        ),
                        AppGap.h12,
                        DelegationLimitCard(
                          selectedLimit: state.selectedLimit,
                          onSelectLimit: (limit) {
                            context
                                .read<DelegationCubit>()
                                .setFinancialLimit(limit);
                          },
                        ),
                        AppGap.h20,
                        _buildSubmitButton(context, state.isSubmitting),
                        if (state.activeDelegations.isNotEmpty) ...[
                          AppGap.h24,
                          _buildSectionTitle(l10n.delActiveList),
                          ...state.activeDelegations.map(
                            (del) => Padding(
                              padding: EdgeInsets.only(bottom: context.h(10)),
                              child: ActiveDelegationCard(
                                delegation: del,
                                onRevoke: () {
                                  unawaited(
                                    context
                                        .read<DelegationCubit>()
                                        .revoke(del.id),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
                  l10n.delTitle,
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                AppGap.h2,
                Text(
                  l10n.delCaption,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: Text(
        title,
        style: AppTextStyles.bodyBold.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 13.5,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isSubmitting) {
    final l10n = context.l10n;

    return SizedBox(
      height: context.h(52),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () {
                unawaited(
                  context.read<DelegationCubit>().submitDelegation(),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B),
          foregroundColor: const Color(0xFF1E293B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                l10n.delSubmit,
                style: AppTextStyles.bodyBold.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: const Color(0xFF1E293B),
                ),
              ),
      ),
    );
  }
}
