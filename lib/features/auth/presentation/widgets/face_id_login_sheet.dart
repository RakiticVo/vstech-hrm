import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
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
  final LocalAuthentication _localAuth = LocalAuthentication();
  CameraController? _cameraController;
  late final AnimationController _animController;
  late final Animation<double> _scanAnimation;

  UserRole _selectedRole = UserRole.employee;
  bool _isSuccess = false;
  String _statusText = 'Đang nhận diện khuôn mặt...';
  bool _isHardwareBiometricAvailable = false;

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
    // 1. Check system biometrics support
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (mounted) setState(() => _isHardwareBiometricAvailable = isSupported && canCheck);
    } on Object {
      // Local biometrics unsupported fallback
    }

    if (!mounted) return;

    // 2. Request Camera permission & initialize front camera if granted
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

    if (_isHardwareBiometricAvailable) {
      await _trySystemBiometric();
    } else {
      await _runSimulatedFaceScan();
    }
  }

  Future<void> _trySystemBiometric() async {
    try {
      final didAuth = await _localAuth.authenticate(
        localizedReason: 'Xác thực sinh trắc học để đăng nhập vào vstech-hrm',
      );
      if (didAuth && mounted) {
        await _onAuthSuccess();
        return;
      }
    } on Object {
      // Local authentication failure fallback
    }
    await _runSimulatedFaceScan();
  }

  Future<void> _runSimulatedFaceScan() async {
    if (!mounted || _isSuccess) return;
    setState(() => _statusText = 'Đang căn chỉnh góc mặt...');
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _isSuccess) return;
    setState(() => _statusText = 'Đối soát dữ liệu sinh trắc học...');
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _isSuccess) return;
    await _onAuthSuccess();
  }

  Future<void> _onAuthSuccess() async {
    if (!mounted) return;
    setState(() {
      _isSuccess = true;
      _statusText = _selectedRole.isManager
          ? 'Nhận diện thành công! Chào Quản lý (Trần Thị Mai)'
          : 'Nhận diện thành công! Chào Nguyễn Văn An';
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    Navigator.of(context).pop();
    await authCubit.loginAsDemo(_selectedRole);
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

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Đăng nhập bằng Face ID',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nhận diện khuôn mặt bảo mật thông minh',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Role selection chips
          _buildRoleSelector(colors),
          const SizedBox(height: 18),

          // Face Scanner Frame
          FaceScanFrame(
            isSuccess: _isSuccess,
            scanAnimation: _scanAnimation,
            cameraController: _cameraController,
          ),
          const SizedBox(height: 16),

          // Status message
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSuccess)
                Icon(Symbols.check_circle, color: colors.pineGreen, size: 20)
              else
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primaryIndigo,
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _statusText,
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
          const SizedBox(height: 18),

          // System Biometric button (if available)
          if (_isHardwareBiometricAvailable && !_isSuccess)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                  side: BorderSide(color: colors.primaryIndigo),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _trySystemBiometric,
                icon: const Icon(Symbols.fingerprint, size: 18),
                label: const Text('Xác thực vân tay / Face ID hệ thống', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Đăng nhập bằng mã nhân viên / mật khẩu',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector(AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleChip('Nhân viên', UserRole.employee, colors),
          const SizedBox(width: 6),
          _buildRoleChip('Quản lý', UserRole.manager, colors),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, UserRole role, AppColorsExtension colors) {
    final isSelected = _selectedRole == role;
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: _isSuccess ? null : () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryIndigo : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? const Color(0xFFFFF8EC) : colors.textSecondary),
        ),
      ),
    );
  }
}
