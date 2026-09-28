import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen 3 / OB-Org: Team structure, department hierarchy & buddy introduction.
class OrgChartIntroScreen extends StatelessWidget {
  const OrgChartIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final teamMembers = const [
      ('Lê Thu Hà', 'Quản lý Vùng TP.HCM (Buddy)', '10 năm tại VSTECH', true),
      ('Phạm Quốc Hưng', 'Trưởng ca Sáng', '3 năm kinh nghiệm', false),
      ('Đặng Mỹ Linh', 'Thu ngân trưởng', '2 năm kinh nghiệm', false),
      ('Nguyễn Hoàng Nam', 'Giám sát Kho chi nhánh', '1.5 năm kinh nghiệm', false),
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
          l10n.orgIntroTitle,
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
          // Buddy Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.primaryIndigo,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.buddyCardTitle,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFFF8EC)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.accentAmber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Buddy 60 Ngày',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1C1408)),
                      ),
                    ),
                  ],
                ),
                14.gapH,
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Text(
                        'H',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.primaryIndigo),
                      ),
                    ),
                    14.gapW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lê Thu Hà',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          Text(
                            'Quản lý Vùng TP.HCM · 0908 123 456',
                            style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.85)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                14.gapH,
                Text(
                  '“Chào mừng Tuấn đến với đội ngũ Vận hành! Chị sẽ là người đồng hành hướng dẫn bạn trong suốt 60 ngày thử việc. Đừng ngần ngại liên hệ nhé!”',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 1.4,
                  ),
                ),
                14.gapH,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFF8EC),
                          side: const BorderSide(color: Color(0xFFFFF8EC)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đang kết nối cuộc gọi đến Buddy: 0908 123 456')),
                          );
                        },
                        icon: const Icon(Symbols.call, size: 16),
                        label: const Text('Gọi điện', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    10.gapW,
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFF8EC),
                          side: const BorderSide(color: Color(0xFFFFF8EC)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mở hộp thư chat với Buddy')),
                          );
                        },
                        icon: const Icon(Symbols.chat, size: 16),
                        label: const Text('Nhắn tin', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.gapH,

          // Department Hierarchy Tree
          Text(
            'Sơ đồ tổ chức phòng ban trực tiếp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          12.gapH,
          _buildHierarchyCard('1. Giám đốc Khối Vận hành', 'Trần Văn Cường (BGĐ)', Symbols.workspace_premium, colors, false),
          _buildHierarchyConnector(colors),
          _buildHierarchyCard('2. Quản lý Vùng TP.HCM (Buddy)', 'Lê Thu Hà', Symbols.supervisor_account, colors, false),
          _buildHierarchyConnector(colors),
          _buildHierarchyCard('3. Giám sát Cửa hàng', 'Nguyễn Minh Tuấn (Bạn)', Symbols.person, colors, true),
          _buildHierarchyConnector(colors),
          _buildHierarchyCard('4. Đội ngũ Cửa hàng', '18 Nhân sự (Trưởng ca, Thu ngân, Kho)', Symbols.groups, colors, false),
          20.gapH,

          // Team members list
          Text(
            'Đồng nghiệp cùng chi nhánh',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          10.gapH,
          ...teamMembers.map((m) => _buildTeamTile(m.$1, m.$2, m.$3, m.$4, colors)),
        ],
      ),
    );
  }

  Widget _buildHierarchyCard(String role, String name, IconData icon, AppColorsExtension colors, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent ? colors.accentAmber.withValues(alpha: 0.15) : colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isCurrent ? colors.accentAmber : colors.border, width: isCurrent ? 2 : 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: isCurrent ? colors.accentAmber : colors.primaryIndigo),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isCurrent ? colors.primaryIndigo : colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: colors.primaryIndigo, borderRadius: BorderRadius.circular(6)),
              child: const Text('Vị trí của bạn', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildHierarchyConnector(AppColorsExtension colors) {
    return Center(
      child: Container(
        width: 2,
        height: 12,
        color: colors.border,
      ),
    );
  }

  Widget _buildTeamTile(String name, String role, String exp, bool isBuddy, AppColorsExtension colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isBuddy ? colors.primaryIndigo : colors.cardSecondary,
            child: Text(
              name.characters.first,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isBuddy ? Colors.white : colors.textPrimary),
            ),
          ),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                Text('$role · $exp', style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
