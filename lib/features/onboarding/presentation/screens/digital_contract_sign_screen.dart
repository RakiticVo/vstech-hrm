import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Screen 7 / OB-Sign: Electronic probation contract signing with SMS OTP verification.
class DigitalContractSignScreen extends StatefulWidget {
  const DigitalContractSignScreen({super.key});

  @override
  State<DigitalContractSignScreen> createState() => _DigitalContractSignScreenState();
}

class _DigitalContractSignScreenState extends State<DigitalContractSignScreen> {
  final _otpController = TextEditingController(text: '889900');
  bool _isSigned = false;
  String? _signedTimestamp;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _signContract() {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã OTP 6 số hợp lệ')),
      );
      return;
    }

    setState(() {
      _isSigned = true;
      _signedTimestamp = '28/09/2026 10:45:12';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.contractSignedSuccess),
        backgroundColor: context.colors.pineGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

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
          l10n.probationContractTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
        actions: [
          if (_isSigned)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: StatusChip(label: 'Đã ký điện tử', type: AppStatusType.approved),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Contract Summary Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('HỢP ĐỒNG THỬ VIỆC ĐIỆN TỬ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.primaryIndigo)),
                    Text('HĐTV-2026/09', style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
                  ],
                ),
                10.gapH,
                Text(
                  'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.textSecondary),
                ),
                12.gapH,
                Text(
                  '- Người sử dụng lao động: CÔNG TY CỔ PHẦN CÔNG NGHỆ VSTECH\n'
                  '- Người lao động: NGUYEN MINH TUAN (NV-04821)\n'
                  '- Vị trí: Giám sát cửa hàng (Vận hành)\n'
                  '- Thời gian thử việc: 01/10/2026 đến 30/11/2026 (2 tháng)\n'
                  '- Mức lương thử việc: 14.450.000 ₫/tháng (85% lương chính thức)\n'
                  '- Địa điểm: Chi nhánh 01 (Quận 1, TP.HCM)',
                  style: TextStyle(fontSize: 12.5, color: colors.textPrimary, height: 1.45),
                ),
              ],
            ),
          ),
          16.gapH,

          if (!_isSigned) ...[
            // OTP Authentication Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Symbols.sms, size: 20, color: colors.primaryIndigo),
                      8.gapW,
                      Text('Xác thực mã OTP ký hợp đồng', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                    ],
                  ),
                  6.gapH,
                  Text(
                    'Mã xác thực gồm 6 chữ số đã được gửi qua tin nhắn SMS tới số điện thoại +84 908 *** 470.',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                  12.gapH,
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 4, color: colors.primaryIndigo),
                    decoration: InputDecoration(
                      hintText: '889900',
                      labelText: 'Nhập mã OTP 6 số',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            16.gapH,

            // Handwritten signature preview box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chữ ký người lao động', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                  10.gapH,
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.cardSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border, style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Text(
                        'Minh Tuấn',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'cursive',
                          fontWeight: FontWeight.w700,
                          color: colors.primaryIndigo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Signed Certificate Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.pineGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.pineGreen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Symbols.verified_user, color: colors.pineGreen, size: 24),
                      10.gapW,
                      Expanded(
                        child: Text(
                          'Hợp đồng đã ký điện tử thành công',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.pineGreen),
                        ),
                      ),
                    ],
                  ),
                  10.gapH,
                  Text('Người ký: NGUYEN MINH TUAN', style: TextStyle(fontSize: 12.5, color: colors.textPrimary)),
                  4.gapH,
                  Text('Thời gian ký: $_signedTimestamp', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                  4.gapH,
                  Text('Mã xác thực: SHA256-OB-998821034-OK', style: TextStyle(fontSize: 11.5, color: colors.textTertiary, fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _isSigned
              ? PrimaryButton(
                  text: 'Tiếp tục: Cẩm nang Ngày đầu tiên',
                  icon: Symbols.menu_book,
                  onPressed: () => context.push(AppRoutes.onboardingDayOne),
                )
              : PrimaryButton(
                  text: l10n.signContractBtn,
                  icon: Symbols.draw,
                  onPressed: _signContract,
                ),
        ),
      ),
    );
  }
}
