import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/check_face_registration_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/register_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/update_face_usecase.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_camera_placeholder.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_enrollment_header.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/face_oval_frame.dart';

/// Screen for employee face biometric registration and updates in Profile.
class FaceEnrollmentScreen extends StatefulWidget {
  const FaceEnrollmentScreen({super.key});

  @override
  State<FaceEnrollmentScreen> createState() => _FaceEnrollmentScreenState();
}

class _FaceEnrollmentScreenState extends State<FaceEnrollmentScreen> {
  CameraController? _cameraController;
  bool _hasPermission = false;
  bool _isChecking = true;
  bool _isSubmitting = false;
  bool _isRegistered = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initScreen());
    });
  }

  Future<void> _initScreen() async {
    final granted = await AppPermissionHandler.requestCamera(context);
    if (!mounted) return;
    setState(() => _hasPermission = granted);

    final authState = context.read<AuthCubit>().state;
    final code = authState is Authenticated ? authState.user.employeeCode : 'NV001';

    final regResult = await sl<CheckFaceRegistrationUseCase>()(code: code);
    if (!mounted) return;

    regResult.fold(
      (failure) {
        setState(() {
          _isChecking = false;
          _errorMessage = failure.message;
        });
      },
      (entity) {
        setState(() {
          _isChecking = false;
          _isRegistered = entity.isRegistered;
        });
      },
    );

    if (granted) {
      await _initCamera();
    }
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
    } on Object catch (e) {
      if (mounted) setState(() => _errorMessage = 'Không thể khởi động camera: $e');
    }
  }

  @override
  void dispose() {
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  Future<void> _onCaptureAndSubmit() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera chưa sẵn sàng, vui lòng thử lại')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final xFile = await _cameraController!.takePicture();
      if (!mounted) return;

      final authState = context.read<AuthCubit>().state;
      final code = authState is Authenticated ? authState.user.employeeCode : 'NV001';

      final outcome = _isRegistered
          ? await sl<UpdateFaceUseCase>()(code: code, imagePath: xFile.path)
          : await sl<RegisterFaceUseCase>()(code: code, imagePath: xFile.path);

      if (!mounted) return;
      outcome.fold(
        (failure) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = failure.message;
          });
        },
        (msg) {
          setState(() {
            _isSubmitting = false;
            _isRegistered = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF0F766E),
              content: Text(msg),
            ),
          );
          Future<void>.delayed(const Duration(milliseconds: 600), () {
            if (mounted) context.pop(true);
          });
        },
      );
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Lỗi khi chụp và xử lý ảnh: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          _isRegistered ? 'Cập nhật khuôn mặt' : 'Đăng ký khuôn mặt',
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(16)),
          child: Column(
            children: [
              12.gapH,
              FaceEnrollmentHeader(
                isChecking: _isChecking,
                isRegistered: _isRegistered,
              ),
              16.gapH,
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_cameraController != null && _cameraController!.value.isInitialized)
                        Center(
                          child: FaceOvalFrame(
                            cameraController: _cameraController,
                            isSuccess: _isRegistered,
                            isScanning: !_isSubmitting,
                          ),
                        )
                      else
                        FaceCameraPlaceholder(
                          hasPermission: _hasPermission,
                          onRetryPermission: _initScreen,
                        ),
                      if (_isSubmitting)
                        const ColoredBox(
                          color: Colors.black54,
                          child: Center(
                            child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              16.gapH,
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              AmberCtaButton(
                text: _isSubmitting
                    ? 'Đang xử lý...'
                    : (_isRegistered ? 'Chụp & Cập nhật khuôn mặt' : 'Chụp & Đăng ký khuôn mặt'),
                onPressed: _isSubmitting ? null : _onCaptureAndSubmit,
              ),
              16.gapH,
            ],
          ),
        ),
      ),
    );
  }
}
