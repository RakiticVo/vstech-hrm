import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 16: Internal Job Recruitment board.
class InternalRecruitmentScreen extends StatelessWidget {
  const InternalRecruitmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    const jobs = [
      _JobItem(
        title: 'Quản lý cửa hàng',
        department: 'Vận hành · Báo cáo cho Giám đốc vùng',
        location: 'Hồ Chí Minh',
        type: 'Toàn thời gian',
        deadline: 'Hạn nộp 30/09',
        isNew: true,
      ),
      _JobItem(
        title: 'Chuyên viên Đào tạo',
        department: 'Nhân sự',
        location: 'Hồ Chí Minh',
        type: 'Toàn thời gian',
        deadline: 'Hạn 05/10',
        isNew: true,
      ),
      _JobItem(
        title: 'Giám sát kho',
        department: 'Chuỗi cung ứng',
        location: 'Bình Dương',
        type: 'Toàn thời gian',
        deadline: 'Hạn 12/10',
        isNew: false,
      ),
      _JobItem(
        title: 'Nhân viên thu ngân cấp cao',
        department: 'Vận hành',
        location: 'Hà Nội',
        type: 'Bán thời gian',
        deadline: 'Hạn 20/10',
        isNew: false,
      ),
    ];

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
          context.l10n.internalRecruitmentTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.group_add),
            tooltip: 'Hồ sơ đã giới thiệu',
            onPressed: () => context.push(AppRoutes.myReferrals),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Referral Banner
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push(AppRoutes.myReferrals),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primaryIndigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Symbols.stars, color: colors.accentAmber, size: 28),
                  12.gapW,
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giới thiệu bạn bè — Thưởng 3.000.000 ₫',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFFFF8EC)),
                        ),
                        Text(
                          'Theo dõi tiến độ hồ sơ & hoa hồng tuyển dụng',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFFFFF8EC)),
                        ),
                      ],
                    ),
                  ),
                  8.gapW,
                  const Icon(Symbols.chevron_right, size: 18, color: Color(0xFFFFF8EC)),
                ],
              ),
            ),
          ),
          // Search box
          TextField(
            decoration: InputDecoration(
              hintText: context.l10n.searchJobPlaceholder,
              hintStyle: TextStyle(fontSize: 13.5, color: colors.textTertiary),
              prefixIcon: Icon(Symbols.search, size: 20, color: colors.textSecondary),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.primaryIndigo, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          14.gapH,

          // Count text
          Text(
            context.l10n.openPositionsCount(jobs.length),
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          12.gapH,

          // Job list
          ...jobs.map((j) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.push(AppRoutes.jobDetail),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.border),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              j.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            if (j.isNew)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colors.accentAmber.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  context.l10n.tagNew,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: colors.accentAmber,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          j.department,
                          style: TextStyle(fontSize: 12, color: colors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildTag(j.location, colors),
                            _buildTag(j.type, colors),
                            _buildTag(j.deadline, colors, isHighlight: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTag(String text, AppColorsExtension colors, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colors.cardSecondary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
          color: isHighlight ? colors.primaryIndigo : colors.textSecondary,
        ),
      ),
    );
  }
}

class _JobItem {
  const new({
    required this.title,
    required this.department,
    required this.location,
    required this.type,
    required this.deadline,
    required this.isNew,
  });

  final String title;
  final String department;
  final String location;
  final String type;
  final String deadline;
  final bool isNew;
}
