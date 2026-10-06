import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/notifications/domain/usecases/get_notifications_usecase.dart';

/// Latest Announcements / Updates section on Home screen.
/// Follows Phone.dc.html lines 215–231.
class HomeAnnouncements extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeAnnouncements> createState() => _HomeAnnouncementsState();
}

class _HomeAnnouncementsState extends State<HomeAnnouncements> {
  List<_AnnouncementItem> _items = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadAnnouncements());
  }

  Future<void> _loadAnnouncements() async {
    final result = await sl<GetNotificationsUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) {},
      (entities) {
        setState(() {
          _items = entities.take(2).map((e) {
            final key = e.keyPage?.toLowerCase() ?? '';
            final badge = key.contains('leave')
                ? 'P'
                : key.contains('salary')
                    ? 'L'
                    : key.contains('attend')
                        ? 'C'
                        : 'A';
            return _AnnouncementItem(
              badgeText: badge,
              title: '${e.title}: ${e.body}',
              time: e.dateSent ?? '',
            );
          }).toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    final badgeSize = context.custom(compact: 30, normal: 34, expanded: 38).toDouble();
    final cardPadding = context.custom(compact: 10, normal: 13, expanded: 16).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              l10n.latestUpdatesTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: colors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => context.push(AppRoutes.notifications),
              child: Text(
                l10n.viewAll,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.tealPrimary,
                ),
              ),
            ),
          ],
        ),
        11.gapH,
        Column(
          children: _items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: colors.border),
                      ),
                      padding: EdgeInsets.all(cardPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: badgeSize,
                            height: badgeSize,
                            decoration: BoxDecoration(
                              color: colors.cardSecondary,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Center(
                              child: Text(
                                item.badgeText,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: colors.tealPrimary,
                                ),
                              ),
                            ),
                          ),
                          11.gapW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                3.gapH,
                                Text(
                                  item.time,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _AnnouncementItem {
  const new({
    required this.badgeText,
    required this.title,
    required this.time,
  });

  final String badgeText;
  final String title;
  final String time;
}
