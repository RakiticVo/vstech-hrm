import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Screen 4 / OB-Docs: Candidate HR intake document checklist and upload.
class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final List<_DocUploadItem> _docs = [
    _DocUploadItem(
      title: 'Bản sao CCCD công chứng (2 mặt)',
      subtitle: 'Tối đa 6 tháng kể từ ngày công chứng',
      fileName: 'CCCD_NguyenMinhTuan.pdf',
      isUploaded: true,
    ),
    _DocUploadItem(
      title: 'Sơ yếu lý lịch có xác nhận',
      subtitle: 'Khai đầy đủ thông tin gia đình & dán ảnh 4x6',
      fileName: 'SYLL_NguyenMinhTuan.pdf',
      isUploaded: true,
    ),
    _DocUploadItem(
      title: 'Giấy khám sức khỏe (Thông tư 14)',
      subtitle: 'Thời hạn không quá 6 tháng từ BV Đa khoa',
      fileName: null,
      isUploaded: false,
    ),
    _DocUploadItem(
      title: 'Bằng tốt nghiệp Đại học / Cao đẳng',
      subtitle: 'Bản sao y có công chứng',
      fileName: null,
      isUploaded: false,
    ),
  ];

  void _uploadDoc(int index) {
    setState(() {
      _docs[index].isUploaded = true;
      _docs[index].fileName = 'Tailieu_${index + 1}_NguyenMinhTuan.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã tải lên: ${_docs[index].title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final uploadedCount = _docs.where((d) => d.isUploaded).length;

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
          l10n.uploadDocsTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Progress Summary Card
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
                    Text(
                      l10n.uploadDocsProgress(uploadedCount, _docs.length),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                    ),
                    Text(
                      '${((uploadedCount / _docs.length) * 100).toInt()}%',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.primaryIndigo),
                    ),
                  ],
                ),
                10.gapH,
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: uploadedCount / _docs.length,
                    minHeight: 8,
                    backgroundColor: colors.cardSecondary,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.pineGreen),
                  ),
                ),
                10.gapH,
                Text(
                  'Vui lòng hoàn thành tải lên đầy đủ các tài liệu trước ngày 01/10/2026 để phòng Nhân sự hoàn tất hồ sơ bảo hiểm.',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
          18.gapH,

          Text(
            'Hồ sơ bắt buộc cần nộp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          10.gapH,
          ...List.generate(_docs.length, (index) {
            final doc = _docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: doc.isUploaded ? colors.pineGreen.withValues(alpha: 0.5) : colors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: doc.isUploaded ? colors.pineGreen.withValues(alpha: 0.12) : colors.cardSecondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: AppIcon(
                        doc.isUploaded ? AppIcons.checkCircle2 : AppIcons.upload,
                        color: doc.isUploaded ? colors.pineGreen : colors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.title,
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary),
                        ),
                        2.gapH,
                        Text(
                          doc.isUploaded ? doc.fileName! : doc.subtitle,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: doc.isUploaded ? colors.pineGreen : colors.textSecondary,
                            fontWeight: doc.isUploaded ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.gapW,
                  if (doc.isUploaded)
                    StatusChip(label: 'Đã nộp', type: AppStatusType.approved)
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryIndigo,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _uploadDoc(index),
                      child: const Text('Tải lên', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: 'Tiếp tục: Chụp ảnh thẻ',
            iconName: AppIcons.camera,
            onPressed: () => context.push(AppRoutes.onboardingCapture),
          ),
        ),
      ),
    );
  }
}

class _DocUploadItem {
  _DocUploadItem({
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.isUploaded,
  });

  final String title;
  final String subtitle;
  String? fileName;
  bool isUploaded;
}
