import 'package:equatable/equatable.dart';

/// Abstract base class for all failure representations in the domain layer.
abstract class Failure extends Equatable {
  const new({
    required this.message,
    this.code,
    this.statusCode,
  });

  /// User-friendly or debug message describing the failure.
  final String message;

  /// Optional machine-readable error code (e.g., 'AUTH_001', 'TIMEOUT').
  final String? code;

  /// Optional HTTP or system status code.
  final int? statusCode;

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Server or API failure returned from the backend.
class ServerFailure extends Failure {
  const new({
    required super.message,
    super.code,
    super.statusCode,
  });
}

/// Network connectivity failure (e.g. no internet, timeout, DNS failure).
class NetworkFailure extends Failure {
  const new({
    super.message = 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.',
    super.code = 'NETWORK_ERROR',
    super.statusCode,
  });
}

/// Authentication & session failure (e.g. 401, token expired, invalid credentials).
class AuthFailure extends Failure {
  const new({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.statusCode = 401,
  });
}

/// Validation failure for form inputs or request parameters.
class ValidationFailure extends Failure {
  const new({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.statusCode = 422,
  });
}

/// Biometric authentication failure (e.g. local biometric canceled or failed).
class BiometricFailure extends Failure {
  const new({
    required super.message,
    super.code = 'BIOMETRIC_ERROR',
    super.statusCode,
  });
}

/// Security violation failure (e.g. root/jailbreak or mock location detected).
class SecurityFailure extends Failure {
  const new({
    required super.message,
    super.code = 'SECURITY_ALERT',
    super.statusCode,
  });
}

/// Cache or local secure storage failure.
class CacheFailure extends Failure {
  const new({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.statusCode,
  });
}

/// Unknown or unhandled exception failure.
class UnknownFailure extends Failure {
  const new({
    super.message = 'Đã có lỗi không xác định xảy ra.',
    super.code = 'UNKNOWN_ERROR',
    super.statusCode,
  });
}
