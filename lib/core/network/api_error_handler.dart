import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';

/// Central parser for backend API error responses and DioExceptions.
/// Extracts clean, user-friendly messages from response body (e.g. `{"message": "..."}`).
class ApiErrorHandler {
  const new _();

  /// Extracts the cleanest, human-readable error message from an API error or response.
  static String extractErrorMessage(dynamic error, [String? fallback]) {
    if (error is DioException) {
      final responseData = error.response?.data;
      final extracted = _extractFromData(responseData);
      if (extracted != null && extracted.isNotEmpty) {
        return extracted;
      }

      // Check network / timeout issues
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Kết nối máy chủ quá thời gian. Vui lòng thử lại.';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.';
      }

      // Check HTTP status code fallback
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.';
      }
      if (statusCode == 403) {
        return 'Bạn không có quyền thực hiện thao tác này.';
      }
      if (statusCode == 404) {
        return 'Không tìm thấy dữ liệu yêu cầu.';
      }
      if (statusCode != null && statusCode >= 500) {
        return 'Hệ thống đang bận hoặc xảy ra lỗi ($statusCode). Vui lòng thử lại sau.';
      }
    }

    if (error is AppException) {
      return error.message;
    }

    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }

    return 'Đã có lỗi xảy ra. Vui lòng thử lại.';
  }

  /// Parses error data payload from Map, List, or raw JSON string.
  static String? _extractFromData(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      // 1. Standard backend response: {"message": "..."}
      final msg = data['message']?.toString().trim();
      if (msg != null && msg.isNotEmpty) return msg;

      // 2. Alternative error key: {"error": "..."}
      final err = data['error']?.toString().trim();
      if (err != null && err.isNotEmpty) return err;

      // 3. ASP.NET Core Validation Problem Details: {"errors": {"field": ["msg"]}}
      final errors = data['errors'];
      if (errors is Map) {
        for (final val in errors.values) {
          if (val is List && val.isNotEmpty) {
            final first = val.first.toString().trim();
            if (first.isNotEmpty) return first;
          } else if (val is String && val.trim().isNotEmpty) {
            return val.trim();
          }
        }
      }

      // 4. Problem Details: {"detail": "..."} or {"title": "..."}
      final detail = data['detail']?.toString().trim();
      if (detail != null && detail.isNotEmpty) return detail;

      final title = data['title']?.toString().trim();
      if (title != null && title.isNotEmpty) return title;
    } else if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;

      // Check if string is serialized JSON
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          final decoded = jsonDecode(trimmed);
          return _extractFromData(decoded);
        } on Object {
          // Fall through to plain text
        }
      }
      return trimmed;
    }

    return null;
  }

  /// Creates a ServerException with the extracted message and status code.
  static ServerException toServerException(dynamic error, [String? fallback]) {
    final msg = extractErrorMessage(error, fallback);
    final statusCode = error is DioException ? error.response?.statusCode : null;
    return ServerException(message: msg, statusCode: statusCode);
  }
}
