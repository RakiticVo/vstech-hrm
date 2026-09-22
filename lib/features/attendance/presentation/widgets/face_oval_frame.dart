import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Oval Face Detection Frame with 4 corner guide brackets, animated laser line, and camera feed.
class FaceOvalFrame extends StatefulWidget {
  const new({
    required this.cameraController,
    required this.isSuccess,
    this.isScanning = true,
    super.key,
  });

  final CameraController? cameraController;
  final bool isSuccess;
  final bool isScanning;

  @override
  State<FaceOvalFrame> createState() => _FaceOvalFrameState();
}

class _FaceOvalFrameState extends State<FaceOvalFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  late final Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.08, end: 0.92).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const frameWidth = 236.0;
    const frameHeight = 290.0;

    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Oval Camera Preview / Simulator Silhouette
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.elliptical(118, 145)),
            child: Container(
              width: frameWidth,
              height: frameHeight,
              color: const Color(0xFF08201E),
              child: _buildCameraContent(colors),
            ),
          ),

          // 2. Animated Amber Scan Laser Line
          if (widget.isScanning && !widget.isSuccess)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Positioned(
                  top: frameHeight * _scanAnimation.value,
                  left: 14,
                  right: 14,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: colors.accentAmber,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: colors.accentAmber.withValues(alpha: 0.8),
                          blurRadius: 16,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // 3. 4 Corner Bracket Guidelines
          Positioned.fill(
            child: CustomPaint(
              painter: _FaceBracketPainter(
                strokeColor: widget.isSuccess
                    ? colors.pineGreen
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),

          // 4. Success Checkmark Pop-up
          if (widget.isSuccess)
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: colors.pineGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.pineGreen.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Symbols.check,
                color: Colors.white,
                size: 52,
                weight: 600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraContent(AppColorsExtension colors) {
    if (widget.cameraController != null &&
        widget.cameraController!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: widget.cameraController!.value.previewSize?.height ?? 236,
          height: widget.cameraController!.value.previewSize?.width ?? 290,
          child: CameraPreview(widget.cameraController!),
        ),
      );
    }

    // High-Fidelity Silhouette Simulator
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0D3F3B),
                const Color(0xFF08201E).withValues(alpha: 0.95),
              ],
            ),
          ),
        ),
        Icon(
          Symbols.person,
          size: 140,
          color: Colors.white.withValues(alpha: 0.22),
        ),
        Positioned(
          bottom: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Camera Simulator',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaceBracketPainter extends CustomPainter {
  new({required this.strokeColor});

  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      // Top Left Corner
      ..moveTo(14, 78)
      ..lineTo(14, 44)
      ..arcToPoint(const Offset(44, 14), radius: const Radius.circular(30))
      ..lineTo(78, 14)
      // Top Right Corner
      ..moveTo(158, 14)
      ..lineTo(192, 14)
      ..arcToPoint(const Offset(222, 44), radius: const Radius.circular(30))
      ..lineTo(222, 78)
      // Bottom Right Corner
      ..moveTo(222, 212)
      ..lineTo(222, 246)
      ..arcToPoint(const Offset(192, 276), radius: const Radius.circular(30))
      ..lineTo(158, 276)
      // Bottom Left Corner
      ..moveTo(78, 276)
      ..lineTo(44, 276)
      ..arcToPoint(const Offset(14, 246), radius: const Radius.circular(30))
      ..lineTo(14, 212);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FaceBracketPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor;
  }
}
