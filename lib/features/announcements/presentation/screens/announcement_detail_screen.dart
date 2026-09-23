import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_cubit.dart';

/// Screen displaying the complete text and metadata of an announcement.
class AnnouncementDetailScreen extends StatefulWidget {
  const new({required this.announcement, super.key});

  final AnnouncementEntity announcement;

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Auto mark as read upon viewing
    unawaited(context.read<AnnouncementsCubit>().markAsRead(widget.announcement.id));
  }

  String _formatScope(BuildContext context, AnnouncementScope scope) {
    final l10n = context.l10n;
    return switch (scope) {
      AnnouncementScope.company => l10n.announcementScopeCompany,
      AnnouncementScope.office => l10n.announcementScopeOffice,
      AnnouncementScope.factory => l10n.announcementScopeFactory,
      AnnouncementScope.department => l10n.announcementScopeDept,
      AnnouncementScope.all => l10n.announcementScopeAll,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final item = widget.announcement;
    final dateStr = DateFormat('dd/MM/yyyy • HH:mm').format(item.publishedAt);

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
          l10n.announcementDetailTitle,
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // Scope and Date Bar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.announcementTargetScope(_formatScope(context, item.scope)),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colors.primaryIndigo,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                dateStr,
                style: TextStyle(fontSize: 12, color: colors.textTertiary),
              ),
            ],
          ),
          14.gapH,

          // Announcement Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              height: 1.35,
            ),
          ),
          14.gapH,

          // Author card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.pineGreen.withValues(alpha: 0.15),
                  child: Icon(Symbols.corporate_fare, size: 20, color: colors.pineGreen),
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.authorName,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      2.gapH,
                      Text(
                        'Phê duyệt và phát hành bởi ${item.authorRole}',
                        style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'CHÍNH THỨC',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.gapH,

          // Main body content
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              item.content,
              style: TextStyle(
                fontSize: 14.5,
                color: colors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
          20.gapH,

          // Read confirmed note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.check_circle, size: 16, color: colors.pineGreen),
              6.gapW,
              Text(
                l10n.announcementReadConfirmed,
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
