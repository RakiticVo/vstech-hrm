import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_success_dialog.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_oval_frame.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_step_progress.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_top_bar.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/location_status_card.dart';

/// Screen performing AI Face Scan Attendance with real camera feed or simulated fallback.
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

  @override
  void dispose() {
    _clockTimer.cancel();
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  void _onCaptureAndSubmit() {
    context.read<AttendanceBloc>().add(
          SubmitFaceScanEvent(
            imagePath: 'mock_face_capture_${DateTime.now().millisecondsSinceEpoch}.jpg',
            type: widget.type,
          ),
        );
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

    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state.status == AttendanceProcessStatus.success && state.lastRecord != null) {
          _showSuccessReceipt(state.lastRecord!);
        } else if (state.status == AttendanceProcessStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Chấm công thất bại'),
              backgroundColor: colors.brickRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == AttendanceProcessStatus.submitting;
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
                      title: widget.type.isCheckIn
                          ? 'Chấm công Giờ vào'
                          : 'Chấm công Giờ ra',
                      currentTime: _currentTime,
                      onClose: () => context.pop(),
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
                          const SizedBox(height: 24),
                          FaceScanStepProgress(
                            isSubmitting: isSubmitting,
                            isSuccess: isSuccess,
                          ),
                        ],
                      ),
                    ),
                    _buildBottomControls(state, isSubmitting, isSuccess),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomControls(AttendanceState state, bool isSubmitting, bool isSuccess) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Column(
        children: [
          LocationStatusCard(
            locationName: state.locationName,
            isVerified: state.isWithinGeofence,
          ),
          const SizedBox(height: 14),
          AmberCtaButton(
            text: widget.type.isCheckIn ? 'Chụp ảnh & Chấm công Vào' : 'Chụp ảnh & Chấm công Ra',
            icon: Symbols.camera_alt,
            isLoading: isSubmitting,
            onPressed: isSuccess ? null : _onCaptureAndSubmit,
          ),
        ],
      ),
    );
  }
}
