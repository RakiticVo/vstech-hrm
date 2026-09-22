import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_success_dialog.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_oval_frame.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_mode_toggle.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_step_progress.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_top_bar.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/location_status_card.dart';

/// Screen performing AI Face Scan Attendance with online and offline vector matching support.
class FaceScanScreen extends StatefulWidget {
  const new({
    this.type = AttendanceType.checkIn,
    super.key,
  });

  final AttendanceType type;

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  CameraController? _cameraController;
  late final Timer _clockTimer;
  String _currentTime = '';
  bool _isOfflineMode = false;
  bool _isOfflineProcessing = false;

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceBloc>().add(PrepareFaceScanEvent(type: widget.type));
      unawaited(_initCamera());
    });
  }

  void _updateClock() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    if (mounted) setState(() => _currentTime = '$h:$m:$s');
  }

  Future<void> _initCamera() async {
    final hasCamera = await AppPermissionHandler.requestCamera(context);
    if (!mounted) return;
    await AppPermissionHandler.requestLocation(context);
    if (!mounted) return;

    if (hasCamera) {
      try {
        final cameras = await availableCameras();
        final frontCam = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
        final controller = CameraController(
          frontCam,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await controller.initialize();
        if (mounted) setState(() => _cameraController = controller);
      } on Object {
        // Graceful fallback to simulator if camera hardware is unavailable
      }
    }
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  Future<void> _onCaptureAndSubmit() async {
    if (_isOfflineMode) {
      await _handleOfflineCapture();
      return;
    }

    context.read<AttendanceBloc>().add(
          SubmitFaceScanEvent(
            imagePath: 'mock_face_capture_${DateTime.now().millisecondsSinceEpoch}.jpg',
            type: widget.type,
          ),
        );
  }

  Future<void> _handleOfflineCapture() async {
    setState(() => _isOfflineProcessing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    const employeeCode = 'NV0089';
    final baseline = await OfflineAttendanceService.getOrEnrollVector(employeeCode);
    final scan = OfflineAttendanceService.simulateScanVector(baseline);
    final score = OfflineAttendanceService.calculateSimilarity(baseline, scan);

    if (score >= OfflineAttendanceService.matchThreshold) {
      final record = OfflineAttendanceRecord(
        id: 'off_${DateTime.now().millisecondsSinceEpoch}',
        employeeCode: employeeCode,
        type: widget.type,
        timestamp: DateTime.now(),
        latitude: 10.7769,
        longitude: 106.7009,
        similarityScore: score,
      );
      await OfflineAttendanceService.enqueueOfflinePunch(record);
      if (!mounted) return;
      setState(() => _isOfflineProcessing = false);

      final pct = (score * 100).toStringAsFixed(1);
      final recordEntity = AttendanceRecordEntity(
        id: record.id,
        timestamp: record.timestamp,
        type: widget.type,
        classification: AttendanceClassification.onTime,
        locationName: 'Văn phòng HCM (Ngoại tuyến)',
        lat: record.latitude,
        lng: record.longitude,
        note: 'Offline match $pct%',
      );

      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.offlineMatchSuccess(pct)),
          backgroundColor: const Color(0xFF0F766E),
        ),
      );
      _showSuccessReceipt(recordEntity);
    } else {
      if (!mounted) return;
      final l10n = context.l10n;
      setState(() => _isOfflineProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.offlineMatchFailed),
          backgroundColor: const Color(0xFFE11D48),
        ),
      );
    }
  }

  void _showSuccessReceipt(AttendanceRecordEntity record) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AttendanceSuccessSheet(
          record: record,
          onClose: () {
            context
              ..pop()
              ..pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final l10n = context.l10n;

    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (!_isOfflineMode) {
          if (state.status == AttendanceProcessStatus.success && state.lastRecord != null) {
            _showSuccessReceipt(state.lastRecord!);
          } else if (state.status == AttendanceProcessStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? l10n.attendanceFailed), backgroundColor: colors.brickRed),
            );
          }
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == AttendanceProcessStatus.submitting || _isOfflineProcessing;
        final isSuccess = state.status == AttendanceProcessStatus.success;

        return Scaffold(
          backgroundColor: colors.tileDark,
          body: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: TilePatternPainter(
                    backgroundColor: colors.tileDark,
                    patternColor: Colors.white.withValues(alpha: 0.07),
                    tileSize: 46,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    FaceScanTopBar(
                      title: widget.type.isCheckIn ? l10n.faceScanCheckInTitle : l10n.faceScanCheckOutTitle,
                      currentTime: _currentTime,
                      onClose: () => context.pop(),
                    ),
                    FaceScanModeToggle(
                      isOfflineMode: _isOfflineMode,
                      onToggle: () => setState(() => _isOfflineMode = !_isOfflineMode),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaceOvalFrame(
                            cameraController: _cameraController,
                            isSuccess: isSuccess,
                            isScanning: !isSubmitting && !isSuccess,
                          ),
                          20.gapH,
                          FaceScanStepProgress(
                            isSubmitting: isSubmitting,
                            isSuccess: isSuccess,
                          ),
                        ],
                      ),
                    ),
                    _buildBottomControls(context, state, isSubmitting, isSuccess),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildBottomControls(BuildContext context, AttendanceState state, bool isSubmitting, bool isSuccess) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Column(
        children: [
          LocationStatusCard(
            locationName: _isOfflineMode ? l10n.offlineLocationLabel : state.locationName,
            isVerified: true,
          ),
          14.gapH,
          AmberCtaButton(
            text: widget.type.isCheckIn ? l10n.faceScanCaptureCheckInCta : l10n.faceScanCaptureCheckOutCta,
            icon: Symbols.camera_alt,
            isLoading: isSubmitting,
            onPressed: isSuccess ? null : _onCaptureAndSubmit,
          ),
        ],
      ),
    );
  }
}
