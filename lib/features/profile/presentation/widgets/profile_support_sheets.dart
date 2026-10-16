import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Modal bottom sheets for FAQ and Privacy Policy on the Profile screen.
abstract final class ProfileSupportSheets {
  static void showFaq(BuildContext context) {
    final colors = context.colors;
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                16.gapH,
                Text(
                  ctx.l10n.faqTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                16.gapH,
                _buildFaqItem(
                  'Làm sao để điểm danh khi mất kết nối mạng?',
                  'Hệ thống hỗ trợ hàng đợi điểm danh ngoại tuyến (Offline Queue). Khi mất mạng, lượt chấm công kèm vector khuôn mặt sẽ được lưu trữ an toàn trong máy và tự động đồng bộ khi có Internet.',
                  colors,
                ),
                _buildFaqItem(
                  'Tại sao cần xác thực bảo mật khi xem phiếu lương?',
                  'Phiếu lương chứa thông tin tài chính cá nhân nhạy cảm. Hệ thống yêu cầu xác thực mật khẩu hoặc sinh trắc học (vân tay / Face ID) để đảm bảo chỉ bạn mới có thể truy cập.',
                  colors,
                ),
                _buildFaqItem(
                  'Quy trình phê duyệt đơn từ diễn ra như thế nào?',
                  'Đơn nghỉ phép hoặc tăng ca sau khi gửi sẽ chuyển qua Quản lý trực tiếp phê duyệt, sau đó chuyển tới phòng Nhân sự xác nhận.',
                  colors,
                ),
                _buildFaqItem(
                  'Tôi muốn cập nhật thông tin cá nhân thì làm thế nào?',
                  'Hiện tại chức năng tự chỉnh sửa hồ sơ đang được hoàn thiện. Vui lòng liên hệ phòng Nhân sự để cập nhật các thông tin cá nhân hoặc tài khoản ngân hàng.',
                  colors,
                ),
              ],
            );
          },
        );
      },
    ));
  }

  static void showPrivacyPolicy(BuildContext context) {
    final colors = context.colors;
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                16.gapH,
                Text(
                  ctx.l10n.privacyPolicyTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                16.gapH,
                _buildFaqItem(
                  '1. Thu thập dữ liệu sinh trắc học',
                  'Dữ liệu nhận diện khuôn mặt và sinh trắc học được mã hóa theo vector toán học 128 chiều và lưu trữ an toàn trên thiết bị thông qua FlutterSecureStorage. Chúng tôi không lưu ảnh gốc khuôn mặt lên máy chủ.',
                  colors,
                ),
                _buildFaqItem(
                  '2. Dữ liệu vị trí và chấm công',
                  'Vị trí GPS chỉ được truy cập tại thời điểm bạn thực hiện thao tác chấm công để xác minh trong bán kính văn phòng/chi nhánh cho phép, không theo dõi liên tục nền.',
                  colors,
                ),
                _buildFaqItem(
                  '3. Bảo mật thông tin lương và hồ sơ',
                  'Tất cả thông tin tài chính, lương thưởng và nhân sự được mã hóa theo chuẩn đường truyền TLS 1.3 và chỉ được phân quyền xem cho cá nhân và cấp quản lý trực tiếp.',
                  colors,
                ),
              ],
            );
          },
        );
      },
    ));
  }

  static Widget _buildFaqItem(String question, String answer, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          4.gapH,
          Text(
            answer,
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
