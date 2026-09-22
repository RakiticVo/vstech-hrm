/// Base class for all application exceptions thrown in data layer.
abstract class AppException implements Exception {
  const new({
    required this.message,
    this.code,
    this.statusCode,
  });

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => 'AppException(message: $message, code: $code, statusCode: $statusCode)';
}

/// Thrown when backend API returns non-2xx error or payload failure.
class ServerException extends AppException {
  const new({
    required super.message,
    super.code,
    super.statusCode,
  });
}

/// Thrown when socket connection, timeout, or DNS lookup fails.
class NetworkException extends AppException {
  const new({
    super.message = 'Network connection failed',
    super.code = 'NETWORK_ERROR',
    super.statusCode,
  });
}

/// Thrown when authentication fails (invalid token, 401, refresh failed).
class AuthException extends AppException {
  const new({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.statusCode = 401,
  });
}

/// Thrown when local cache or secure storage operations fail.
class CacheException extends AppException {
  const new({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.statusCode,
  });
}

/// Thrown when root/jailbreak or mock GPS checks detect tampering.
class SecurityException extends AppException {
  const new({
    required super.message,
    super.code = 'SECURITY_VIOLATION',
    super.statusCode,
  });
}

/// Thrown when local biometric authentication fails or is unavailable.
class BiometricException extends AppException {
  const new({
    required super.message,
    super.code = 'BIOMETRIC_ERROR',
    super.statusCode,
  });
}
