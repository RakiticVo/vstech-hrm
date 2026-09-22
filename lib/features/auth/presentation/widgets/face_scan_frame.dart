import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Oval face scanning target frame with live camera feed and animated scanning laser.
class FaceScanFrame extends StatelessWidget {
  const new({
    required this.isSuccess,
    required this.scanAnimation,
    this.cameraController,
    super.key,
  });

  final bool isSuccess;
  final Animation<double> scanAnimation;
  final CameraController? cameraController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final frameColor = isSuccess ? colors.pineGreen : colors.primaryIndigo;

    return Container(
      width: 170,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(85),
        border: Border.all(color: frameColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: frameColor.withValues(alpha: 0.18),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(83),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Camera feed or Simulated Face Icon
            if (cameraController != null && cameraController!.value.isInitialized)
              Transform.scale(
                scale: 1.3,
                child: Center(child: CameraPreview(cameraController!)),
              )
            else
              ColoredBox(
                color: colors.cardSecondary,
                child: Center(
                  child: Icon(
                    isSuccess ? Symbols.face : Symbols.face_retouching_natural,
                    size: 80,
                    color: frameColor.withValues(alpha: 0.6),
                  ),
                ),
              ),

            // Animated Scanning Beam
            if (!isSuccess)
              AnimatedBuilder(
                animation: scanAnimation,
                builder: (context, _) {
                  return Align(
                    alignment: Alignment(0, (scanAnimation.value * 2) - 1),
                    child: Container(
                      width: double.infinity,
                      height: 3,
                      decoration: BoxDecoration(
                        color: colors.accentAmber,
                        boxShadow: [
                          BoxShadow(
                            color: colors.accentAmber.withValues(alpha: 0.8),
                            blurRadius: 10,
                            spreadRadius: 3,
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
