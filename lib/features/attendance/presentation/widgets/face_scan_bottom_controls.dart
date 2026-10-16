import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/location_status_card.dart';

/// Bottom action area showing Geofencing location status and capture CTA.
class FaceScanBottomControls extends StatelessWidget {
  const FaceScanBottomControls({
    required this.type,
    required this.state,
    required this.isOfflineMode,
    required this.isSubmitting,
    required this.isVerifying,
    required this.isSuccess,
    required this.onCaptureAndSubmit,
    this.isLoading = false,
    super.key,
  });

  final AttendanceType type;
  final AttendanceState state;
  final bool isOfflineMode;
  final bool isSubmitting;
  final bool isVerifying;
  final bool isSuccess;
  final bool isLoading;
  final VoidCallback onCaptureAndSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLocationAcquired = isOfflineMode || state.isLocationReady;

    var ctaText = type.isCheckIn
        ? l10n.faceScanCaptureCheckInCta
        : l10n.faceScanCaptureCheckOutCta;

    if (isLoading) {
      ctaText = l10n.faceCheckingButton;
    } else if (isVerifying) {
      ctaText = 'Đang xác thực khuôn mặt...';
    } else if (state.status == AttendanceProcessStatus.submitting) {
      ctaText = 'Đang ghi nhận chấm công...';
    } else if (!isLocationAcquired) {
      ctaText = state.locationName;
    }

    final disableButton = !isLocationAcquired || isSuccess || isLoading || isSubmitting;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Column(
        children: [
          LocationStatusCard(
            locationName: isOfflineMode ? l10n.offlineLocationLabel : state.locationName,
            isVerified: isLocationAcquired,
          ),
          14.gapH,
          AmberCtaButton(
            text: ctaText,
            iconName: AppIcons.faceScan,
            isLoading: isSubmitting || isLoading,
            onPressed: disableButton ? null : onCaptureAndSubmit,
          ),
        ],
      ),
    );
  }
}
