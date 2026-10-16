import 'package:flutter/material.dart';

/// Placeholder displayed when camera permission is not granted or camera is initializing.
class FaceCameraPlaceholder extends StatelessWidget {
  const FaceCameraPlaceholder({
    required this.hasPermission,
    required this.onRetryPermission,
    super.key,
  });

  final bool hasPermission;
  final VoidCallback onRetryPermission;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            Text(
              !hasPermission ? 'Cần cấp quyền camera' : 'Đang tải camera...',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            if (!hasPermission) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetryPermission,
                child: const Text('Cấp quyền ngay'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
