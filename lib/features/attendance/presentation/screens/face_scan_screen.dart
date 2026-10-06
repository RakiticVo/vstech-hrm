import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_state.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_oval_frame.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_bottom_controls.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_listener_helper.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_mode_toggle.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_offline_handler.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_step_progress.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_scan_top_bar.dart';

/// Screen performing AI Face Scan Attendance with Face API verification and offline support.
class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({
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

  String _getUserCode() {
    final authState = context.read<AuthCubit>().state;
    return authState is Authenticated ? authState.user.employeeCode : 'NV001';
  }

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceBloc>().add(
            PrepareFaceScanEvent(
              type: widget.type,
              employeeCode: _getUserCode(),
            ),
          );
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
    if (_cameraController != null) return;
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

  Future<void> _disposeCamera() async {
    final cam = _cameraController;
    _cameraController = null;
    if (mounted) setState(() {});
    await cam?.dispose();
  }

  Future<void> _handleGoToEnrollment() async {
    await _disposeCamera();
    if (!mounted) return;
    await context.push<bool>(AppRoutes.faceEnrollment);
    if (!mounted) return;
    context.read<AttendanceBloc>().add(
          PrepareFaceScanEvent(
            type: widget.type,
            employeeCode: _getUserCode(),
          ),
        );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    unawaited(_disposeCamera());
    super.dispose();
  }

  Future<void> _onCaptureAndSubmit() async {
    if (_isOfflineMode) {
      setState(() => _isOfflineProcessing = true);
      final record = await FaceScanOfflineHandler.processOfflinePunch(
        context: context,
        type: widget.type,
        employeeCode: _getUserCode(),
      );
      if (mounted) {
        setState(() => _isOfflineProcessing = false);
        if (record != null) {
          unawaited(FaceScanListenerHelper.showSuccessReceipt(context, record));
        }
      }
      return;
    }

    var capturePath = 'mock_capture_${DateTime.now().millisecondsSinceEpoch}.jpg';
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final xFile = await _cameraController!.takePicture();
        capturePath = xFile.path;
      } on Object catch (_) {}
    }

    if (!mounted) return;
    context.read<AttendanceBloc>().add(
          SubmitFaceScanEvent(
            imagePath: capturePath,
            type: widget.type,
            employeeCode: _getUserCode(),
          ),
        );
  }

  void _handleStateListener(BuildContext context, AttendanceState state) {
    FaceScanListenerHelper.handleState(
      context: context,
      state: state,
      isOfflineMode: _isOfflineMode,
      onInitCamera: _initCamera,
      onGoToEnrollment: _handleGoToEnrollment,
      onShowSuccess: (record) => FaceScanListenerHelper.showSuccessReceipt(context, record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listener: _handleStateListener,
      builder: (context, state) {
        final isChecking = state.status == AttendanceProcessStatus.loading;
        final isVerifying = state.status == AttendanceProcessStatus.faceVerifying;
        final isSubmitting = state.status == AttendanceProcessStatus.submitting ||
            isVerifying ||
            _isOfflineProcessing;
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
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    FaceScanTopBar(
                      title: widget.type.isCheckIn
                          ? l10n.faceScanCheckInTitle
                          : l10n.faceScanCheckOutTitle,
                      currentTime: _currentTime,
                      onClose: () => context.pop(),
                    ),
                    FaceScanModeToggle(
                      isOfflineMode: _isOfflineMode,
                      onToggle: () {
                        setState(() => _isOfflineMode = !_isOfflineMode);
                        if (_isOfflineMode && _cameraController == null) {
                          unawaited(_initCamera());
                        }
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaceOvalFrame(
                            cameraController: _cameraController,
                            isSuccess: isSuccess,
                            isScanning: !isSubmitting && !isSuccess && !isChecking,
                            isLoading: isChecking,
                            loadingMessage: l10n.faceCheckingRegistration,
                          ),
                          20.gapH,
                          FaceScanStepProgress(
                            isSubmitting: isSubmitting,
                            isSuccess: isSuccess,
                          ),
                        ],
                      ),
                    ),
                    FaceScanBottomControls(
                      type: widget.type,
                      state: state,
                      isOfflineMode: _isOfflineMode,
                      isSubmitting: isSubmitting,
                      isVerifying: isVerifying,
                      isSuccess: isSuccess,
                      isLoading: isChecking,
                      onCaptureAndSubmit: _onCaptureAndSubmit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
