import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Instruction text and animated step progress indicator for face scan flow.
class FaceScanStepProgress extends StatelessWidget {
  const new({
    required this.isSubmitting,
    required this.isSuccess,
    super.key,
  });

  final bool isSubmitting;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    String title;
    String subtitle;

    if (isSuccess) {
      title = 'Xác thực thành công!';
      subtitle = 'Hệ thống đã lưu nhận diện khuôn mặt và vị trí';
    } else if (isSubmitting) {
      title = 'Đang nhận diện...';
      subtitle = 'Đang gửi ảnh quét mặt và toạ độ GPS về máy chủ';
    } else {
      title = 'Căn chỉnh khuôn mặt';
      subtitle = 'Giữ thẳng đầu và nhìn trực diện vào camera';
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = index == 0 ||
                (index == 1 && (isSubmitting || isSuccess)) ||
                (index == 2 && isSuccess);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? colors.accentAmber
                    : Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
