import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

/// Card widget displaying Geofence location accuracy and Wi-Fi validation state.
class LocationStatusCard extends StatelessWidget {
  const new({
    required this.locationName,
    required this.isVerified,
    super.key,
  });

  final String locationName;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        children: [
          Icon(
            Symbols.location_on,
            size: 20,
            color: colors.cream,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              locationName,
              style: AppTextStyles.bodySmall(color: colors.cream).copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isVerified ? colors.pineGreen : colors.accentAmber,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isVerified ? Symbols.check : Symbols.sync,
              size: 14,
              color: Colors.white,
              weight: 700,
            ),
          ),
        ],
      ),
    );
  }
}
