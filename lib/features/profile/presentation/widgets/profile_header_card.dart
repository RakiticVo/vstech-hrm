import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/role_switcher_sheet.dart';

/// Compact, bounded header card for Profile Screen matching Saigon tile design.
class ProfileHeaderCard extends StatelessWidget {
  const new({
    required this.name,
    required this.employeeCode,
    required this.position,
    required this.isManager,
    super.key,
  });

  final String name;
  final String employeeCode;
  final String position;
  final bool isManager;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ColoredBox(
        color: colors.primaryIndigo,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: TilePatternPainter(
                  backgroundColor: colors.primaryIndigo,
                  patternColor: const Color(0xFFFFF8EC).withValues(alpha: 0.14),
                  tileSize: 34,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  // Avatar with initials and photo change tap
                  InkWell(
                    borderRadius: BorderRadius.circular(99),
                    onTap: () async {
                      final granted = await AppPermissionHandler.requestPhotos(context);
                      if (context.mounted && granted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã sẵn sàng tải lên ảnh đại diện mới')),
                        );
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8EC),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              name.isNotEmpty ? name.substring(0, 1) : 'V',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: colors.primaryIndigo,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: const Icon(Symbols.photo_camera, size: 11, color: Color(0xFF1C1408)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFF8EC),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$employeeCode · $position',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFFFF8EC).withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Role Switcher pill
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => RoleSwitcherSheet.show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8EC).withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFF8EC).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isManager ? 'QL' : 'NV',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFFF8EC),
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Symbols.swap_horiz, size: 14, color: Color(0xFFFFF8EC)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
