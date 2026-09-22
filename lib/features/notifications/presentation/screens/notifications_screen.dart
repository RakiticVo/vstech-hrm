import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 18: Notification Center with vibrant category colors and badges.
class NotificationsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedCategoryIndex = 0;
  final _categories = ['Tất cả', 'Phép', 'Lương', 'Chấm công', 'Thưởng', 'Tuyển dụng'];

  final _allNotifications = const [
    _NotificationData(
      letter: 'P',
      category: 'Phép',
      time: '2h trước',
      title: 'Yêu cầu nghỉ phép 21–23/09 đã được Lê Thu Hà duyệt.',
      isUnread: true,
      accentColor: Color(0xFF16A34A),
      bgColor: Color(0xFFDCFCE7),
    ),
    _NotificationData(
      letter: 'L',
      category: 'Lương',
      time: '1 ngày trước',
      title: 'Phiếu lương tháng 9 đã có. Thực nhận 25.500.000 ₫.',
      isUnread: true,
      accentColor: Color(0xFFD97706),
      bgColor: Color(0xFFFEF3C7),
    ),
    _NotificationData(
      letter: 'C',
      category: 'Chấm công',
      time: '1 ngày trước',
      title: 'Ngày 15/09 thiếu giờ ra. Vui lòng gửi yêu cầu sửa công trước 20/09.',
      isUnread: false,
      accentColor: Color(0xFF0284C7),
      bgColor: Color(0xFFE0F2FE),
    ),
    _NotificationData(
      letter: 'T',
      category: 'Thưởng',
      time: '3 ngày trước',
      title: 'Thưởng KPI quý 3: 2.500.000 ₫ đã trả cùng lương tháng 9.',
      isUnread: false,
      accentColor: Color(0xFF9333EA),
      bgColor: Color(0xFFF3E8FF),
    ),
    _NotificationData(
      letter: 'R',
      category: 'Tuyển dụng',
      time: '4 ngày trước',
      title: 'Vị trí Quản lý cửa hàng mở cho ứng viên nội bộ đến 30/09.',
      isUnread: false,
      accentColor: Color(0xFF4F46E5),
      bgColor: Color(0xFFEEF2FF),
    ),
    _NotificationData(
      letter: 'A',
      category: 'Hệ thống',
      time: '5 ngày trước',
      title: 'Nghỉ lễ Quốc khánh 02/09 — toàn bộ chi nhánh đóng cửa.',
      isUnread: false,
      accentColor: Color(0xFFEA580C),
      bgColor: Color(0xFFFFEDD5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final filtered = _selectedCategoryIndex == 0
        ? _allNotifications
        : _allNotifications
            .where((n) => n.category == _categories[_selectedCategoryIndex])
            .toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc')),
              );
            },
            child: Text(
              'Đọc tất cả',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: colors.primaryIndigo,
              ),
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
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                        _categories[idx],
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, index) {
                final item = filtered[index];
                return Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: item.isUnread ? item.accentColor.withValues(alpha: 0.35) : colors.border,
                      width: item.isUnread ? 1.5 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vibrant Avatar Letter Box
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            item.letter,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: item.accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: item.bgColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: item.accentColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (item.isUnread)
                                      Container(
                                        width: 7,
                                        height: 7,
                                        margin: const EdgeInsets.only(right: 6),
                                        decoration: BoxDecoration(
                                          color: item.accentColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    Text(
                                      item.time,
                                      style: TextStyle(fontSize: 11, color: colors.textTertiary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: item.isUnread ? FontWeight.w800 : FontWeight.w600,
                                color: colors.textPrimary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  const new({
    required this.letter,
    required this.category,
    required this.time,
    required this.title,
    required this.isUnread,
    required this.accentColor,
    required this.bgColor,
  });

  final String letter;
  final String category;
  final String time;
  final String title;
  final bool isUnread;
  final Color accentColor;
  final Color bgColor;
}
