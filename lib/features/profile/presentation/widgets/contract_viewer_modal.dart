import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Modal dialog displaying digital labor contract with dynamic anti-leak watermark.
class ContractViewerModal extends StatelessWidget {
  const ContractViewerModal({
    this.title = 'Hợp đồng lao động xác định thời hạn 24 tháng',
    this.code = 'HĐ-2024/05/VSTECH',
    this.employeeCode = 'NV-04821',
    this.employeeName = 'NGUYEN MINH TUAN',
    this.date = '28/09/2026',
    super.key,
  });

  final String title;
  final String code;
  final String employeeCode;
  final String employeeName;
  final String date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final watermarkText = l10n.contractWatermark(employeeCode, employeeName, date);

    return Dialog(
      backgroundColor: colors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.contractViewerTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Số: $code',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.primaryIndigo,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const AppIcon(AppIcons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.border),

          // Contract Content with Diagonal Watermark
          Flexible(
            child: Stack(
              children: [
                // Scrollable Document Body
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      16.gapH,
                      Center(
                        child: Text(
                          'HỢP ĐỒNG LAO ĐỘNG',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: colors.primaryIndigo,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      12.gapH,
                      Text(
                        'Bên A (Người sử dụng lao động): CÔNG TY CỔ PHẦN CÔNG NGHỆ VSTECH\n'
                        'Đại diện bởi: Bà Trần Thị Kim Oanh - Chức vụ: Giám đốc Điều hành\n\n'
                        'Bên B (Người lao động): Ông $employeeName\n'
                        'Mã nhân viên: $employeeCode · CCCD: 079094001234\n\n'
                        'Điều 1: Thời hạn và công việc hợp đồng\n'
                        '- Loại hợp đồng: Hợp đồng lao động xác định thời hạn 24 tháng\n'
                        '- Chức danh chuyên môn: Giám sát cửa hàng (Bộ phận Vận hành)\n'
                        '- Địa điểm làm việc: Hệ thống chi nhánh VSTECH TP.HCM\n\n'
                        'Điều 2: Chế độ làm việc và thời giờ nghỉ ngơi\n'
                        '- Thời giờ làm việc: 48 giờ/tuần theo ca phân công\n'
                        '- Nghỉ phép năm: 12 ngày/năm có hưởng nguyên lương\n\n'
                        'Điều 3: Tiền lương và phụ cấp\n'
                        '- Mức lương chính: Theo quy chế lương công ty và thỏa thuận\n'
                        '- Hình thức trả lương: Chuyển khoản ngân hàng vào ngày 05 hàng tháng.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      20.gapH,
                    ],
                  ),
                ),

                // Anti-Leak Watermark Layer
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.14,
                      child: Transform.rotate(
                        angle: -0.45,
                        child: Center(
                          child: Text(
                            watermarkText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.border),

          // Bottom actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primaryIndigo,
                      side: BorderSide(color: colors.primaryIndigo),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.downloadingPdfSnackbar)),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: AppIcon(AppIcons.download, size: 18, color: colors.primaryIndigo),
                    label: Text(l10n.downloadDocBtn, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
                12.gapW,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primaryIndigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.closeButton, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
