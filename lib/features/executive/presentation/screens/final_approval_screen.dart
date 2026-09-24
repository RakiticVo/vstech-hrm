import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_state.dart';
import 'package:vstech_hrm/features/executive/presentation/widgets/final_approval_item_card.dart';

class FinalApprovalScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<FinalApprovalScreen> createState() => _FinalApprovalScreenState();
}

class _FinalApprovalScreenState extends State<FinalApprovalScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<FinalApprovalCubit>().loadQueue());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocConsumer<FinalApprovalCubit, FinalApprovalState>(
      listener: (context, state) {
        if (state.userMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.userMessage!),
              backgroundColor: const Color(0xFF0F766E),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Symbols.arrow_back, color: colors.textPrimary),
              onPressed: () => context.pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.finalApprovalTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  l10n.finalApprovalCaption,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.delegationCenter),
                icon: const Icon(Symbols.assignment_ind, size: 18),
                label: Text(
                  l10n.finalApprovalDelegateBtn,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              8.gapW,
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => context.read<FinalApprovalCubit>().loadQueue(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    children: [
                      // Quick batch approval card
                      if (state.queue.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.finalApprovalBatchHint,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                              12.gapW,
                              OutlinedButton.icon(
                                onPressed: () {
                                  unawaited(
                                    context.read<FinalApprovalCubit>().approveAll(),
                                  );
                                },
                                icon: const Icon(Symbols.done_all, size: 18),
                                label: Text(
                                  l10n.finalApprovalApproveAll,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF16A34A),
                                  side: const BorderSide(color: Color(0xFF16A34A)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        16.gapH,
                      ],

                      if (state.queue.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Column(
                              children: [
                                Icon(
                                  Symbols.task_alt,
                                  size: 64,
                                  color: colors.textTertiary,
                                ),
                                12.gapH,
                                Text(
                                  'Tất cả đơn đề xuất đã được xử lý xong.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        for (final item in state.queue)
                          FinalApprovalItemCard(
                            item: item,
                            onApprove: () {
                              unawaited(
                                context.read<FinalApprovalCubit>().approveItem(item.id),
                              );
                            },
                            onReject: () {
                              unawaited(
                                context.read<FinalApprovalCubit>().rejectItem(item.id),
                              );
                            },
                          ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
