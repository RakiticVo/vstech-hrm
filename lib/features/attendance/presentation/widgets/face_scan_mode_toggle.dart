import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';

/// Toggle badge between Online server mode and Offline vector matching mode.
class FaceScanModeToggle extends StatelessWidget {
  const new({
    required this.isOfflineMode,
    required this.onToggle,
    super.key,
  });

  final bool isOfflineMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isOfflineMode
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isOfflineMode
                      ? const Color(0xFFF59E0B)
                      : Colors.white24,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOfflineMode ? Symbols.wifi_off : Symbols.wifi,
                    size: 15,
                    color: isOfflineMode
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFFFF8EC),
                  ),
                  6.gapW,
                  Text(
                    isOfflineMode
                        ? context.l10n.offlineAttendanceModeLabel
                        : context.l10n.onlineAttendanceModeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isOfflineMode
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFFFF8EC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
