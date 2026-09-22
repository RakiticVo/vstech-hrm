import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// BottomSheet to configure application PIN lock and auto-lock timeout.
class AppLockSheet extends StatefulWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AppLockSheet(),
    );
  }

  @override
  State<AppLockSheet> createState() => _AppLockSheetState();
}

class _AppLockSheetState extends State<AppLockSheet> {
  bool _isLockEnabled = true;
  int _selectedTimeoutMinutes = 1;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'BẢO VỆ DỮ LIỆU',
            style: AppTextStyles.labelMicro(color: colors.textTertiary),
          ),
          const SizedBox(height: 6),
          Text(
            'Khóa ứng dụng & Mã PIN',
            style: AppTextStyles.headlineSmall(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Tự động khóa ứng dụng khi rời màn hình để bảo vệ thông tin lương và hồ sơ nhân viên.',
            style: AppTextStyles.bodySmall(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Symbols.phonelink_lock, size: 24, color: colors.tealPrimary),
                        const SizedBox(width: 10),
                        Text(
                          'Bật khóa ứng dụng',
                          style: AppTextStyles.bodyMedium(color: colors.textPrimary)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _isLockEnabled,
                      activeThumbColor: colors.tealPrimary,
                      onChanged: (val) => setState(() => _isLockEnabled = val),
                    ),
                  ],
                ),
                if (_isLockEnabled) ...[
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.5)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'TỰ ĐỘNG KHÓA SAU',
                      style: AppTextStyles.labelMicro(color: colors.textTertiary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTimeoutOption(0, 'Ngay lập tức khi rời app', colors),
                  _buildTimeoutOption(1, 'Sau 1 phút', colors),
                  _buildTimeoutOption(5, 'Sau 5 phút', colors),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Lưu thiết lập',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Đã cập nhật cấu hình khóa ứng dụng thành công'),
                  backgroundColor: colors.tealPrimary,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeoutOption(int minutes, String label, AppColorsExtension colors) {
    final isSelected = _selectedTimeoutMinutes == minutes;
    return InkWell(
      onTap: () => setState(() => _selectedTimeoutMinutes = minutes),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall(color: colors.textPrimary)),
            if (isSelected)
              Icon(Symbols.check, size: 18, color: colors.tealPrimary),
          ],
        ),
      ),
    );
  }
}
