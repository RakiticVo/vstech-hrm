import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_cubit.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_state.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/widgets/qr_confirmation_bottom_sheet.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/widgets/qr_sample_payloads_sheet.dart';

/// Screen presenting the live camera QR scanner, animated laser frame, and confirmation flow.
class QrScannerScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  late AnimationController _laserAnimController;

  @override
  void initState() {
    super.initState();
    _laserAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    unawaited(_initCamera());
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final backCam = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
        _cameraController = CameraController(
          backCam,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          context.read<QrScannerCubit>().setCameraInitialized(isInitialized: true);
          setState(() {});
        }
      }
    } on Object {
      if (mounted) {
        context.read<QrScannerCubit>().setCameraInitialized(isInitialized: false);
      }
    }
  }

  @override
  void dispose() {
    _laserAnimController.dispose();
    if (_cameraController != null) {
      unawaited(_cameraController!.dispose());
    }
    super.dispose();
  }

  void _showSamplePayloads(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (bottomSheetContext) => QrSamplePayloadsSheet(
          onSelectPayload: (payload) {
            unawaited(context.read<QrScannerCubit>().onPayloadDetected(payload));
          },
        ),
      ),
    );
  }

  void _showConfirmationSheet(BuildContext context, QrScannerState state) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (sheetCtx) => QrConfirmationBottomSheet(
          request: state.activeRequest!,
          isProcessing: state.isProcessing,
          onApprove: () {
            Navigator.of(sheetCtx).pop();
            unawaited(context.read<QrScannerCubit>().approveLogin());
          },
          onReject: () {
            Navigator.of(sheetCtx).pop();
            unawaited(context.read<QrScannerCubit>().rejectLogin());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocConsumer<QrScannerCubit, QrScannerState>(
      listener: (context, state) {
        if (state.isConfirming && state.activeRequest != null) {
          _showConfirmationSheet(context, state);
        } else if (state.status == QrScannerFlowStatus.approved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.statusMessage ?? l10n.qrLoginApprovedSuccess),
              backgroundColor: colors.pineGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == QrScannerFlowStatus.rejected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.statusMessage ?? l10n.qrLoginRejectedMsg),
              backgroundColor: colors.textSecondary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<QrScannerCubit>().reset();
        } else if (state.status == QrScannerFlowStatus.error && state.errorMessage != null) {
          unawaited(
            showDialog<void>(
              context: context,
              builder: (dialogCtx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Row(
                  children: [
                    Icon(Symbols.error, color: Color(0xFFDC2626)),
                    SizedBox(width: 8),
                    Text('Thông báo quét mã', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                content: Text(state.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogCtx).pop();
                      context.read<QrScannerCubit>().reset();
                    },
                    child: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Symbols.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.qrScannerTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  state.isTorchOn ? Symbols.flash_on : Symbols.flash_off,
                  color: Colors.white,
                ),
                onPressed: () => context.read<QrScannerCubit>().toggleTorch(),
              ),
              4.gapW,
            ],
          ),
          body: Stack(
            children: [
              // 1. Camera Viewfinder or Fallback
              if (_cameraController != null && _cameraController!.value.isInitialized)
                Center(child: CameraPreview(_cameraController!))
              else
                const ColoredBox(
                  color: Color(0xFF1E293B),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Symbols.camera_enhance, size: 54, color: Colors.white54),
                        SizedBox(height: 12),
                        Text(
                          'Khung ngắm quét mã QR (Simulator Ready)',
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Viewfinder Mask & Target Box
              _buildScanOverlay(context),

              // 3. Bottom controls (Demo Payloads trigger)
              Positioned(
                bottom: 32,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryIndigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => _showSamplePayloads(context),
                      icon: const Icon(Symbols.qr_code, size: 20),
                      label: Text(
                        l10n.qrSamplePayloadsButton,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
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

  Widget _buildScanOverlay(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _laserAnimController,
              builder: (context, child) {
                return Positioned(
                  top: _laserAnimController.value * 230 + 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          context.colors.amberGold,
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.amberGold.withValues(alpha: 0.8),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
