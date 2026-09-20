import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';

/// Cubit managing app-wide authentication, user session, and current role.
class AuthCubit extends Cubit<AuthState> {
  new({
    required this._secureStorage,
  })  : super(const AuthInitial());

  final FlutterSecureStorage _secureStorage;

  static const String _userSessionKey = 'vstech_user_session';

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final token = await _secureStorage.read(key: AppConstants.tokenStorageKey);
      final userJsonStr = await _secureStorage.read(key: _userSessionKey);

      if (token != null && token.isNotEmpty && userJsonStr != null) {
        final userMap = jsonDecode(userJsonStr) as Map<String, dynamic>;
        final user = UserSession.fromJson(userMap);
        emit(Authenticated(user: user, token: token, role: user.role));
      } else {
        emit(const Unauthenticated());
      }
    } on Object catch (e, stackTrace) {
      appLogger.e('checkAuthStatus error', error: e, stackTrace: stackTrace);
      emit(const Unauthenticated(message: 'Không thể khôi phục phiên đăng nhập'));
    }
  }

  Future<void> loginAsDemo(UserRole role) async {
    emit(const AuthLoading());
    final isManager = role.isManager;
    final user = isManager
        ? const UserSession(
            id: 'usr_mgr_001',
            name: 'Trần Thị Mai',
            email: 'tran.mai@vstech.vn',
            employeeCode: 'NV0089',
            department: 'Phòng Kỹ thuật & Sản phẩm',
            role: UserRole.manager,
          )
        : const UserSession(
            id: 'usr_emp_001',
            name: 'Nguyễn Văn An',
            email: 'nguyen.an@vstech.vn',
            employeeCode: 'NV0142',
            department: 'Bộ phận Phát triển Mobile',
            role: UserRole.employee,
          );

    final token = 'mock_jwt_${role.name}_${DateTime.now().millisecondsSinceEpoch}';

    await _secureStorage.write(key: AppConstants.tokenStorageKey, value: token);
    await _secureStorage.write(
      key: _userSessionKey,
      value: jsonEncode(user.toJson()),
    );

    emit(Authenticated(user: user, token: token, role: role));
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    final isManager = username.toLowerCase().contains('manager') ||
        username.toLowerCase().contains('ql');
    final role = isManager ? UserRole.manager : UserRole.employee;
    await loginAsDemo(role);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.tokenStorageKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenStorageKey);
    await _secureStorage.delete(key: _userSessionKey);
    emit(const Unauthenticated());
  }
}
