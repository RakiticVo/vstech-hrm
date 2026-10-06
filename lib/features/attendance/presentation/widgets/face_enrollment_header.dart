import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Header widget displaying the employee's face registration status.
class FaceEnrollmentHeader extends StatelessWidget {
  const FaceEnrollmentHeader({
    required this.isChecking,
    required this.isRegistered,
    super.key,
  });

  final bool isChecking;
  final bool isRegistered;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isRegistered
            ? const Color(0xFF0F766E).withValues(alpha: 0.1)
            : const Color(0xFFF59E0B).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRegistered
              ? const Color(0xFF0F766E).withValues(alpha: 0.3)
              : const Color(0xFFF59E0B).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isRegistered ? Icons.check_circle : Icons.info_outline,
            color: isRegistered
                ? const Color(0xFF0F766E)
                : const Color(0xFFF59E0B),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isChecking
                  ? 'Đang kiểm tra hồ sơ khuôn mặt...'
                  : (isRegistered
                        ? 'Đã có dữ liệu khuôn mặt. Bạn có thể chụp lại để cập nhật.'
                        : 'Chưa đăng ký khuôn mặt. Vui lòng căn chỉnh thẳng mặt để chụp.'),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
