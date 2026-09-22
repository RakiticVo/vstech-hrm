import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 04: All Services grid hub categorized into 4 departments.
class AllServicesScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
          'Tất cả dịch vụ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildCategory(
            title: 'Chấm công & Thời gian',
            items: [
              _ServiceItem('Chấm công vào/ra', Symbols.power_settings_new, () => context.go(AppRoutes.attendance)),
              _ServiceItem('Lịch ca làm việc', Symbols.schedule, () => context.push(AppRoutes.shiftSchedule)),
              _ServiceItem('Lịch công tháng', Symbols.calendar_month, () => context.push(AppRoutes.calendar)),
              _ServiceItem('Ngày lễ trong năm', Symbols.flag, () => context.push(AppRoutes.holidays)),
            ],
            colors: colors,
          ),
          const SizedBox(height: 22),
          _buildCategory(
            title: 'Đơn từ',
            items: [
              _ServiceItem('Xin nghỉ phép', Symbols.beach_access, () => context.push(AppRoutes.leaveCreate)),
              _ServiceItem('Đăng ký tăng ca', Symbols.schedule, () => context.push(AppRoutes.overtimeCreate)),
              _ServiceItem('Sửa công', Symbols.edit_note, () => context.push(AppRoutes.attendanceCorrection)),
              _ServiceItem('Theo dõi yêu cầu', Symbols.list_alt, () => context.go(AppRoutes.requests)),
            ],
            colors: colors,
          ),
          const SizedBox(height: 22),
          _buildCategory(
            title: 'Lương & thưởng',
            items: [
              _ServiceItem('Bảng lương tháng', Symbols.account_balance_wallet, () => context.go(AppRoutes.payroll)),
              _ServiceItem('Phiếu lương', Symbols.receipt_long, () => context.push(AppRoutes.payslipDetail)),
              _ServiceItem('Thưởng & ghi nhận', Symbols.star, () => context.push(AppRoutes.rewards)),
              _ServiceItem('Phụ cấp', Symbols.payments, () => context.go(AppRoutes.payroll)),
            ],
            colors: colors,
          ),
          const SizedBox(height: 22),
          _buildCategory(
            title: 'Nghề nghiệp & hồ sơ',
            items: [
              _ServiceItem('Tuyển dụng nội bộ', Symbols.work, () => context.push(AppRoutes.jobRecruitment)),
              _ServiceItem('Hồ sơ cá nhân', Symbols.person, () => context.go(AppRoutes.profile)),
              _ServiceItem('Cài đặt', Symbols.settings, () => context.push(AppRoutes.settings)),
              _ServiceItem('Phê duyệt', Symbols.fact_check, () => context.push(AppRoutes.approvals)),
            ],
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildCategory({
    required String title,
    required List<_ServiceItem> items,
    required AppColorsExtension colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.border),
                      ),
                      child: Center(
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: colors.primaryIndigo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        height: 1.25,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _ServiceItem {
  const new(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}
