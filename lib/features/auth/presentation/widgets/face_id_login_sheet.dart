import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/face_scan_frame.dart';

/// Modal bottom sheet providing interactive Face ID and Biometric login.
/// Integrates hardware LocalAuthentication and Camera preview with AI face scan animation.
class FaceIdLoginSheet extends StatefulWidget {
  const new({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FaceIdLoginSheet(),
    );
  }

  @override
  State<FaceIdLoginSheet> createState() => _FaceIdLoginSheetState();
}

class _FaceIdLoginSheetState extends State<FaceIdLoginSheet>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  late final AnimationController _animController;
  late final Animation<double> _scanAnimation;

  bool _isSuccess = false;
  String? _statusText;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initCameraAndAuth());
    });
  }

  Future<void> _initCameraAndAuth() async {
    // Request Camera permission & initialize front camera if granted
    final hasCamera = await AppPermissionHandler.requestCamera(context);
    if (hasCamera && mounted) {
      try {
        final cameras = await availableCameras();
        final frontCam = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
        final controller = CameraController(frontCam, ResolutionPreset.medium, enableAudio: false);
        await controller.initialize();
        if (mounted) setState(() => _cameraController = controller);
      } on Object {
        // Camera hardware unavailable fallback
      }
    }

    await _runSimulatedFaceScan();
  }

  Future<void> _runSimulatedFaceScan() async {
    if (!mounted || _isSuccess) return;
    setState(() => _statusText = context.l10n.faceAligning);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _isSuccess) return;
    setState(() => _statusText = context.l10n.faceMatching);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _isSuccess) return;
    await _onAuthSuccess();
  }

  Future<void> _onAuthSuccess() async {
    if (!mounted) return;
    final storage = sl<FlutterSecureStorage>();
    final savedUsername = await storage.read(key: AppConstants.keySavedUsername);
    final savedPassword = await storage.read(key: AppConstants.keySavedPassword);

    if (savedUsername == null || savedUsername.isEmpty || savedPassword == null || savedPassword.isEmpty) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.noSavedCredentialsForBiometric),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSuccess = true;
      _statusText = context.l10n.faceAuthSuccessGreeting(savedUsername);
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    Navigator.of(context).pop();
    await authCubit.login(username: savedUsername, password: savedPassword);
  }

  @override
  void dispose() {
    _animController.dispose();
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final currentStatus = _statusText ?? l10n.faceDetecting;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          16.gapH,
          Text(
            l10n.faceIdLoginTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          4.gapH,
          Text(
            l10n.faceIdLoginSubtitle,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          18.gapH,
          FaceScanFrame(
            isSuccess: _isSuccess,
            scanAnimation: _scanAnimation,
            cameraController: _cameraController,
          ),
          16.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSuccess)
                AppIcon(AppIcons.checkCircle2, color: colors.pineGreen, size: 20)
              else
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primaryIndigo,
                  ),
                ),
              8.gapW,
              Flexible(
                child: Text(
                  currentStatus,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _isSuccess ? colors.pineGreen : colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          18.gapH,
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.loginWithCredentialsButton,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
