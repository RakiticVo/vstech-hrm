import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:vstech_hrm/features/notifications/presentation/widgets/notification_card.dart';

/// Screen 18: Notification Center connected to OpenAPI /api/BaseNotifications.
class NotificationsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedCategoryIndex = 0;
  bool _isLoading = false;
  List<NotificationItemData> _allNotifications = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadNotifications());
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final result = await sl<GetNotificationsUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _allNotifications = entities.map((e) {
            final key = e.keyPage?.toLowerCase() ?? '';
            final type = key.contains('leave')
                ? 'leave'
                : key.contains('salary')
                    ? 'salary'
                    : key.contains('attend')
                        ? 'attendance'
                        : key.contains('reward')
                            ? 'reward'
                            : key.contains('recruit')
                                ? 'recruitment'
                                : 'system';
            final letter = switch (type) {
              'leave' => 'P',
              'salary' => 'L',
              'attendance' => 'C',
              'reward' => 'T',
              'recruitment' => 'R',
              _ => 'A',
            };
            final (accent, bg) = switch (type) {
              'leave' => (const Color(0xFF16A34A), const Color(0xFFDCFCE7)),
              'salary' => (const Color(0xFFD97706), const Color(0xFFFEF3C7)),
              'attendance' => (const Color(0xFF0284C7), const Color(0xFFE0F2FE)),
              'reward' => (const Color(0xFF9333EA), const Color(0xFFF3E8FF)),
              'recruitment' => (const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
              _ => (const Color(0xFFEA580C), const Color(0xFFFFEDD5)),
            };
            return NotificationItemData(
              id: e.id,
              letter: letter,
              type: type,
              time: e.dateSent ?? '',
              title: '${e.title}: ${e.body}',
              isUnread: !e.isRead,
              accentColor: accent,
              bgColor: bg,
            );
          }).toList();
        });
      },
    );
  }

  Future<void> _markAllAsRead() async {
    await sl<MarkAllNotificationsReadUseCase>()();
    if (!mounted) return;
    setState(() {
      _allNotifications = _allNotifications
          .map((n) => n.copyWith(isUnread: false))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.allNotificationsReadSnackbar)),
    );
  }

  Future<void> _onTapNotification(NotificationItemData item) async {
    if (item.isUnread) {
      await sl<MarkNotificationReadUseCase>()(item.id);
      if (!mounted) return;
      setState(() {
        final index = _allNotifications.indexOf(item);
        if (index != -1) {
          _allNotifications[index] = item.copyWith(isUnread: false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final categories = [
      (null, context.l10n.tabAll),
      ('leave', context.l10n.notificationCatLeave),
      ('salary', context.l10n.notificationCatSalary),
      ('attendance', context.l10n.notificationCatAttendance),
      ('reward', context.l10n.notificationCatReward),
      ('recruitment', context.l10n.notificationCatRecruitment),
    ];

    final selectedType = categories[_selectedCategoryIndex].$1;
    final filtered = selectedType == null
        ? _allNotifications
        : _allNotifications.where((n) => n.type == selectedType).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.notificationsTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              context.l10n.markAllRead,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.primaryIndigo),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: colors.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => 8.gapW,
                itemBuilder: (ctx, idx) {
                  final isSelected = _selectedCategoryIndex == idx;
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _selectedCategoryIndex = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primaryIndigo : colors.cardSecondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        categories[idx].$2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? const Color(0xFFFFF8EC) : colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Notification List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadNotifications,
                    child: filtered.isEmpty
                        ? ListView(
                            children: [
                              120.gapH,
                              Center(
                                child: Text(
                                  context.l10n.announcementEmpty,
                                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => 10.gapH,
                            itemBuilder: (ctx, index) {
                              final item = filtered[index];
                              return NotificationCard(
                                item: item,
                                onTap: () => unawaited(_onTapNotification(item)),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
