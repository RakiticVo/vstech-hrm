import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';

enum QrScannerFlowStatus {
  idle,
  processing,
  confirming,
  approved,
  rejected,
  error;
}

class QrScannerState extends Equatable {
  const new({
    this.status = QrScannerFlowStatus.idle,
    this.isCameraInitialized = false,
    this.isTorchOn = false,
    this.activeRequest,
    this.statusMessage,
    this.errorMessage,
  });

  final QrScannerFlowStatus status;
  final bool isCameraInitialized;
  final bool isTorchOn;
  final QrLoginRequestEntity? activeRequest;
  final String? statusMessage;
  final String? errorMessage;

  bool get isConfirming => status == QrScannerFlowStatus.confirming;
  bool get isProcessing => status == QrScannerFlowStatus.processing;

  QrScannerState copyWith({
    QrScannerFlowStatus? status,
    bool? isCameraInitialized,
    bool? isTorchOn,
    QrLoginRequestEntity? activeRequest,
    String? statusMessage,
    String? errorMessage,
    bool clearActiveRequest = false,
  }) {
    return QrScannerState(
      status: status ?? this.status,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isTorchOn: isTorchOn ?? this.isTorchOn,
      activeRequest: clearActiveRequest ? null : (activeRequest ?? this.activeRequest),
      statusMessage: statusMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isCameraInitialized,
        isTorchOn,
        activeRequest,
        statusMessage,
        errorMessage,
      ];
}
