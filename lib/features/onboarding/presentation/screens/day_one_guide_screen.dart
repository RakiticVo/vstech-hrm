import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// Screen 8 / OB-Day1: Comprehensive logistical guide for the candidate's first day.
class DayOneGuideScreen extends StatelessWidget {
  const DayOneGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final checklists = const [
      ('Mang theo CCCD bản gốc', 'Đối chiếu hồ sơ thực tế và nhận thẻ đeo nhân viên thông minh.', AppIcons.badgeAlert),
      ('Trang phục chuẩn Smart Casual', 'Áo sơ mi hoặc áo polo có cổ, quần tối màu, giày lịch sự.', AppIcons.userCheck),
      ('Gửi xe tại hầm B2', 'Báo nhân viên bảo vệ: Nhân sự mới VSTECH để được quẹt vé miễn phí.', AppIcons.mapPin),
      ('Nhận thiết bị và tài khoản', 'Gặp bộ phận IT tại Tầng 8 lúc 09:30 để bàn giao laptop và kích hoạt tài khoản.', AppIcons.laptop),
      ('Gặp gỡ Buddy và dùng bữa trưa', 'Chị Lê Thu Hà sẽ đón tiếp tại sảnh lễ tân lúc 08:30 và dẫn đi ăn trưa cùng nhóm.', AppIcons.coffee),
    ];

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
          l10n.dayOneGuideTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Time & Place Hero Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.primaryIndigo,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: colors.accentAmber, borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        '08:30 SÁNG · 01/10/2026',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF1C1408)),
                      ),
                    ),
                    const AppIcon(AppIcons.calendar, color: Color(0xFFFFF8EC), size: 20),
                  ],
                ),
                14.gapH,
                const Text(
                  'Địa điểm tập trung ngày đầu tiên',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFFF8EC)),
                ),
                4.gapH,
                const Text(
                  'Trụ sở chính VSTECH TP.HCM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                4.gapH,
                Text(
                  'Tầng 8, Tòa nhà VSTECH, 34 Lê Duẩn, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh',
                  style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.9), height: 1.4),
                ),
                14.gapH,
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                12.gapH,
                Row(
                  children: [
                    const AppIcon(AppIcons.user, size: 18, color: Color(0xFFFFF8EC)),
                    8.gapW,
                    Expanded(
                      child: Text(
                        'Người đón tiếp: Chị Lê Thu Hà (0908 123 456)',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.95)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.gapH,

          Text(
            l10n.dayOneChecklistTitle,
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          12.gapH,
          ...checklists.map(
            (c) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.primaryIndigo.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: AppIcon(c.$3, size: 20, color: colors.primaryIndigo),
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.$1,
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary),
                        ),
                        4.gapH,
                        Text(
                          c.$2,
                          style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: 'Tôi đã sẵn sàng cho Ngày 1!',
            iconName: AppIcons.sparkles,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Hẹn gặp bạn vào lúc 08:30 ngày 01/10/2026 tại VSTECH!'),
                  backgroundColor: colors.pineGreen,
                ),
              );
              context.go(AppRoutes.onboardingHome);
            },
          ),
        ),
      ),
    );
  }
}
