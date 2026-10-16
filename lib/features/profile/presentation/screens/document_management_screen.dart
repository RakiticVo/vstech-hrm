import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/contract_viewer_modal.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/document_item_card.dart';

/// Screen for managing labor contracts, legal records and expiring document alerts.
class DocumentManagementScreen extends StatelessWidget {
  const DocumentManagementScreen({super.key});

  void _openContractViewer(BuildContext context, String title, String code) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ContractViewerModal(title: title, code: code),
    );
  }

  void _openDocumentDetails(BuildContext context, DocumentItemModel doc) {
    if (doc.isContract) {
      _openContractViewer(context, doc.title, doc.code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đang mở tài liệu: ${doc.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final contractDocs = const [
      DocumentItemModel(
        title: 'HĐLĐ Xác định thời hạn 24 tháng',
        code: 'HĐ-2024/05/VSTECH',
        effectiveDate: '02/05/2024 — 01/05/2026',
        iconName: AppIcons.documents,
        isContract: true,
        statusLabel: 'Hiệu lực',
        statusType: AppStatusType.approved,
      ),
      DocumentItemModel(
        title: 'Phụ lục HĐLĐ điều chỉnh lương & chức danh',
        code: 'PL-2025/08/VSTECH',
        effectiveDate: '01/08/2025',
        iconName: AppIcons.documents,
        isContract: true,
        statusLabel: 'Hiệu lực',
        statusType: AppStatusType.approved,
      ),
      DocumentItemModel(
        title: 'Thỏa thuận bảo mật thông tin & SHTT (NDA)',
        code: 'NDA-2024/VSTECH',
        effectiveDate: '02/05/2024',
        iconName: AppIcons.shield,
        isContract: true,
        statusLabel: 'Hiệu lực',
        statusType: AppStatusType.approved,
      ),
    ];

    final legalDocs = const [
      DocumentItemModel(
        title: 'Căn cước công dân gắn chip',
        code: 'CCCD-079094001234',
        effectiveDate: 'Cấp ngày 12/04/2021',
        iconName: AppIcons.idCard,
        statusLabel: 'Đã xác thực',
        statusType: AppStatusType.approved,
      ),
      DocumentItemModel(
        title: 'Bằng Cử nhân Quản trị Kinh doanh',
        code: 'Văn bằng ĐH Kinh Tế TP.HCM',
        effectiveDate: 'Tốt nghiệp 2016',
        iconName: AppIcons.checklist,
        statusLabel: 'Đã xác thực',
        statusType: AppStatusType.approved,
      ),
      DocumentItemModel(
        title: 'Giấy khám sức khỏe định kỳ',
        code: 'BV Nhân Dân Gia Định',
        effectiveDate: 'Hết hạn: 15/10/2026',
        iconName: AppIcons.warning,
        isExpiringSoon: true,
        statusLabel: 'Hết hạn 15 ngày',
        statusType: AppStatusType.rejected,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.documentManagementTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Expiring Document Warning Alert
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.error, width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon(AppIcons.warning, color: colors.error, size: 24),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.expiringDocAlertTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: colors.error,
                        ),
                      ),
                      4.gapH,
                      Text(
                        l10n.expiringDocAlertMsg(15, '15/10/2026'),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.gapH,

          // Section 1: Contracts
          Text(
            l10n.contractSectionTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          10.gapH,
          ...contractDocs.map(
            (doc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DocumentItemCard(
                item: doc,
                onTap: () => _openDocumentDetails(context, doc),
              ),
            ),
          ),
          16.gapH,

          // Section 2: Legal Documents & Certificates
          Text(
            l10n.legalDocSectionTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          10.gapH,
          ...legalDocs.map(
            (doc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DocumentItemCard(
                item: doc,
                onTap: () => _openDocumentDetails(context, doc),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: l10n.uploadNewDocBtn,
            iconName: AppIcons.attach,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mở trình chọn tệp để tải lên tài liệu mới...')),
              );
            },
          ),
        ),
      ),
    );
  }
}
