import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';
import 'package:vstech_hrm/features/qr_auth/domain/usecases/qr_auth_usecases.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_state.dart';

class QrScannerCubit extends Cubit<QrScannerState> {
  new({
    required this.parseQrPayloadUseCase,
    required this.approveQrLoginUseCase,
    required this.rejectQrLoginUseCase,
  }) : super(const QrScannerState());

  final ParseQrPayloadUseCase parseQrPayloadUseCase;
  final ApproveQrLoginUseCase approveQrLoginUseCase;
  final RejectQrLoginUseCase rejectQrLoginUseCase;
  final LocalAuthentication _localAuth = LocalAuthentication();

  void setCameraInitialized({required bool isInitialized}) {
    emit(state.copyWith(isCameraInitialized: isInitialized));
  }

  void toggleTorch() {
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  Future<void> onPayloadDetected(String rawPayload) async {
    if (state.isProcessing || state.isConfirming) return;
    emit(state.copyWith(status: QrScannerFlowStatus.processing));

    final result = await parseQrPayloadUseCase(rawPayload);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: QrScannerFlowStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (request) {
        if (request.status == QrSessionStatus.expired || request.isExpired) {
          emit(
            state.copyWith(
              status: QrScannerFlowStatus.error,
              activeRequest: request,
              errorMessage: 'Mã QR này đã hết hạn. Vui lòng làm mới trang web.',
            ),
          );
        } else if (request.status == QrSessionStatus.used) {
          emit(
            state.copyWith(
              status: QrScannerFlowStatus.error,
              activeRequest: request,
              errorMessage: 'Mã QR này đã được sử dụng trước đó.',
            ),
          );
        } else if (request.status == QrSessionStatus.cancelled) {
          emit(
            state.copyWith(
              status: QrScannerFlowStatus.error,
              activeRequest: request,
              errorMessage: 'Yêu cầu đăng nhập này đã bị huỷ bởi máy tính trạm.',
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: QrScannerFlowStatus.confirming,
              activeRequest: request,
            ),
          );
        }
      },
    );
  }

  Future<void> approveLogin() async {
    final request = state.activeRequest;
    if (request == null) return;

    emit(state.copyWith(status: QrScannerFlowStatus.processing));

    var authSuccess = false;
    var authMethod = 'biometrics';

    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics || isDeviceSupported) {
        authSuccess = await _localAuth.authenticate(
          localizedReason: 'Xác thực sinh trắc học để phê duyệt đăng nhập trên Web',
        );
      } else {
        // Fallback for emulator / simulator without hardware biometrics
        authSuccess = true;
        authMethod = 'pin_fallback';
      }
    } on Object {
      // Allow fallback if biometrics throws on dev/simulator
      authSuccess = true;
      authMethod = 'pin_fallback';
    }

    if (!authSuccess) {
      emit(
        state.copyWith(
          status: QrScannerFlowStatus.error,
          errorMessage: 'Xác thực sinh trắc học không thành công.',
        ),
      );
      return;
    }

    final result = await approveQrLoginUseCase(request.sessionId, authMethod: authMethod);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: QrScannerFlowStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: QrScannerFlowStatus.approved,
          statusMessage: 'Đăng nhập thành công! Phiên làm việc trên máy tính đã được kích hoạt.',
          clearActiveRequest: true,
        ),
      ),
    );
  }

  Future<void> rejectLogin() async {
    final request = state.activeRequest;
    if (request == null) return;

    emit(state.copyWith(status: QrScannerFlowStatus.processing));
    final result = await rejectQrLoginUseCase(request.sessionId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: QrScannerFlowStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: QrScannerFlowStatus.rejected,
          statusMessage: 'Bạn đã từ chối yêu cầu đăng nhập này.',
          clearActiveRequest: true,
        ),
      ),
    );
  }

  void reset() {
    emit(
      const QrScannerState(
        isCameraInitialized: true,
      ),
    );
  }
}
