import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Card container for a group of profile key-value rows matching reference design.
class ProfileInfoCard extends StatelessWidget {
  const new({
    required this.title,
    required this.rows,
    super.key,
  });

  final String title;
  final List<(String key, String value)> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: colors.border.withValues(alpha: 0.5),
            ),
            itemBuilder: (ctx, index) {
              final row = rows[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      row.$1,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      row.$2,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
