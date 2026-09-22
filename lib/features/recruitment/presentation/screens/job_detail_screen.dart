import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';

/// Screen 17: Internal Job Position Detail & Quick Application.
class JobDetailScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isSaved = false;

  void _apply() {
    unawaited(
      AppSuccessDialog.show(
        context,
        title: context.l10n.applySuccessTitle,
        message: context.l10n.applySuccessMsg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final descriptions = [
      'Chịu trách nhiệm doanh thu và vận hành hàng ngày của một cửa hàng 25 nhân sự.',
      'Xây dựng lịch làm việc, đảm bảo đủ người trong giờ cao điểm.',
      'Phối hợp với Marketing cho các chương trình khuyến mại tại điểm bán.',
    ];

    final requirements = [
      'Tối thiểu 2 năm ở vị trí giám sát trong bán lẻ.',
      'Đã từng quản lý ngân sách và chỉ tiêu doanh thu.',
      'Thành thạo tiếng Việt. Tiếng Anh cơ bản là lợi thế.',
    ];

    final benefits = [
      'Phụ cấp quản lý 3.000.000 đ/tháng.',
      'Thưởng theo doanh thu cửa hàng, xét hàng quý.',
      'Lộ trình lên Giám đốc vùng trong 3 năm.',
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
          context.l10n.jobDetailTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentAmber,
                      foregroundColor: const Color(0xFF1C1408),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _apply,
                    child: Text(
                      context.l10n.applyButton,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              12.gapW,
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _isSaved = !_isSaved),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: Icon(
                    _isSaved ? Symbols.bookmark : Symbols.bookmark_border,
                    color: _isSaved ? colors.primaryIndigo : colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Position Title Card
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quản lý cửa hàng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bộ phận Vận hành',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildTag('Hồ Chí Minh', colors),
                    _buildTag('Toàn thời gian', colors),
                    _buildTag('Hạn nộp: 30/09', colors, isHighlight: true),
                  ],
                ),
              ],
            ),
          ),
          20.gapH,

          // Mô tả công việc
          _buildSection(context.l10n.jobDescriptionSection, descriptions, colors),
          18.gapH,

          // Yêu cầu
          _buildSection(context.l10n.jobRequirementsSection, requirements, colors),
          18.gapH,

          // Phúc lợi
          _buildSection(context.l10n.jobBenefitsSection, benefits, colors),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> points, AppColorsExtension colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: points
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 6, right: 10),
                            decoration: BoxDecoration(
                              color: colors.primaryIndigo,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              p,
                              style: TextStyle(fontSize: 13, color: colors.textPrimary, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
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
