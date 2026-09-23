import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_cubit.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_state.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/factory_reminders_dialog.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/offline_queue_record_card.dart';

/// Screen listing pending and synchronized attendance records with GPS validation and 5-state lifecycle.
class OfflineQueueScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
}

class _OfflineQueueScreenState extends State<OfflineQueueScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<OfflineQueueCubit>().loadQueue());
  }

  void _showRemindersDialog(BuildContext context, FactoryRemindersConfig config) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => FactoryRemindersDialog(
          currentConfig: config,
          onSave: (newConfig) {
            unawaited(context.read<OfflineQueueCubit>().updateReminders(newConfig));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocConsumer<OfflineQueueCubit, OfflineQueueState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: colors.pineGreen,
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.offlineQueueTitle,
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Symbols.alarm, color: colors.primaryIndigo),
                tooltip: l10n.factoryRemindersTitle,
                onPressed: () => _showRemindersDialog(context, state.remindersConfig),
              ),
              IconButton(
                icon: Icon(Symbols.refresh, color: colors.textPrimary),
                onPressed: () => unawaited(context.read<OfflineQueueCubit>().loadQueue()),
              ),
              4.gapW,
            ],
          ),
          body: Column(
            children: [
              // Persistent Warning Banner if unsynced items exist
              if (state.pendingCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFFFEF2F2),
                  child: Row(
                    children: [
                      const Icon(Symbols.warning, size: 20, color: Color(0xFFDC2626)),
                      10.gapW,
                      Expanded(
                        child: Text(
                          l10n.persistentQueueWarning(state.pendingCount),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB91C1C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Filter Chips
              _buildFilterChips(context, state),

              // List of records
              Expanded(
                child: state.filteredRecords.isEmpty
                    ? Center(
                        child: Text(
                          'Không có bản ghi nào trong mục này',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: state.filteredRecords.length,
                        itemBuilder: (context, index) {
                          final item = state.filteredRecords[index];
                          return OfflineQueueRecordCard(
                            item: item,
                            onRetry: () => unawaited(
                              context.read<OfflineQueueCubit>().retryRecord(item.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          bottomNavigationBar: state.pendingCount > 0
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: state.isSyncing
                          ? null
                          : () => unawaited(context.read<OfflineQueueCubit>().syncAll()),
                      icon: state.isSyncing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Symbols.cloud_upload, size: 20),
                      label: Text(
                        state.isSyncing
                            ? 'Đang đồng bộ ${state.pendingCount} lượt công...'
                            : '${l10n.syncAllButton} (${state.pendingCount})',
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context, OfflineQueueState state) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filters = [
      (QueueFilter.all, l10n.filterAll),
      (QueueFilter.pending, '${l10n.statusPendingSync} (${state.pendingCount})'),
      (QueueFilter.synced, l10n.statusSynced),
      (QueueFilter.failed, l10n.statusSyncFailed),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final isSelected = state.filter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                f.$2,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textSecondary,
                ),
              ),
              selected: isSelected,
              selectedColor: colors.primaryIndigo,
              backgroundColor: colors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onSelected: (_) => context.read<OfflineQueueCubit>().setFilter(f.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
