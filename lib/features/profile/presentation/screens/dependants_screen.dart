import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/dependant_item_card.dart';

/// Screen displaying registered dependants for Personal Income Tax (PIT) relief.
class DependantsScreen extends StatefulWidget {
  const DependantsScreen({super.key});

  @override
  State<DependantsScreen> createState() => _DependantsScreenState();
}

class _DependantsScreenState extends State<DependantsScreen> {
  final _dependants = const [
    DependantItemModel(
      name: 'Nguyễn Minh Khang',
      relationship: 'Con ruột (< 18 tuổi)',
      birthDate: '12/08/2020',
      idNumber: 'GKS: 45/2020/TPHCM',
      startMonth: '01/2021',
      reliefAmount: '4.400.000 ₫/tháng',
      status: 'Đang áp dụng',
      statusType: AppStatusType.approved,
    ),
    DependantItemModel(
      name: 'Trần Thị Mai',
      relationship: 'Mẹ ruột (ngoài tuổi lao động)',
      birthDate: '05/04/1958',
      idNumber: 'CCCD: 079158000412',
      startMonth: '06/2023',
      reliefAmount: '4.400.000 ₫/tháng',
      status: 'Đang áp dụng',
      statusType: AppStatusType.approved,
    ),
  ];

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
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.dependantsManageTitle,
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
          // Tax Relief Summary Hero Card
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
                      l10n.dependantsTaxReliefTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.pineGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Luật Thuế TNCN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: colors.pineGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                12.gapH,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.cardSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Số người phụ thuộc',
                              style: TextStyle(fontSize: 11, color: colors.textSecondary),
                            ),
                            4.gapH,
                            Text(
                              '${_dependants.length} người',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: colors.primaryIndigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.gapW,
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.cardSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng mức giảm trừ',
                              style: TextStyle(fontSize: 11, color: colors.textSecondary),
                            ),
                            4.gapH,
                            Text(
                              '8.800.000 ₫',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: colors.pineGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                12.gapH,
                Text(
                  l10n.dependantPolicyNotice,
                  style: TextStyle(fontSize: 11.5, color: colors.textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
          20.gapH,

          Text(
            'Danh sách người phụ thuộc',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          10.gapH,
          ..._dependants.map(
            (dep) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DependantItemCard(item: dep),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: l10n.addDependantBtn,
            iconName: AppIcons.plus,
            onPressed: () => context.push(AppRoutes.dependantNew),
          ),
        ),
      ),
    );
  }
}
