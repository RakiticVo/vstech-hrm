import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vstech_hrm/core/constants/app_constants.dart';
import 'package:vstech_hrm/core/network/logging_interceptor.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/features/auth/domain/entities/login_params.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vstech_hrm/features/auth/domain/usecases/login_usecase.dart';

/// Cubit managing app-wide authentication, user session, and current role.
class AuthCubit extends Cubit<AuthState> {
  new({
    required FlutterSecureStorage secureStorage,
    LoginUseCase? loginUseCase,
    CheckAuthUseCase? checkAuthUseCase,
  })  : _secureStorage = secureStorage,
        _loginUseCase = loginUseCase,
        _checkAuthUseCase = checkAuthUseCase,
        super(const AuthInitial());

  final FlutterSecureStorage _secureStorage;
  final LoginUseCase? _loginUseCase;
  final CheckAuthUseCase? _checkAuthUseCase;

  static const String _userSessionKey = 'vstech_user_session';
  static const String _tokenValidToKey = 'vstech_token_valid_to';

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final token = await _secureStorage.read(key: AppConstants.tokenStorageKey);
      final userJsonStr = await _secureStorage.read(key: _userSessionKey);

      if (token != null && token.isNotEmpty && userJsonStr != null) {
        if (_checkAuthUseCase != null) {
          final result = await _checkAuthUseCase.call();
          final isValid = result.getOrElse((_) => false);
          if (!isValid) {
            await logout();
            return;
          }
        }
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
            id: '2',
            name: 'Trần Thị Mai',
            email: 'tran.mai@vstech.vn',
            employeeCode: 'NV0089',
            department: 'Phòng Kỹ thuật & Sản phẩm',
            role: UserRole.manager,
          )
        : const UserSession(
            id: '1',
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
    String? deviceId,
    String? model,
    String? brand,
    String? platform,
    String? versionRelease,
    String? versionApp,
    bool checkMobile = true,
  }) async {
    emit(const AuthLoading());

    if (_loginUseCase != null) {
      final params = LoginParams(
        username: username,
        password: password,
        deviceId: deviceId ?? 'device_simulator_001',
        model: model ?? 'Simulator',
        brand: brand ?? 'Apple/Android',
        platform: platform ?? 'mobile',
        versionRelease: versionRelease ?? '18.0',
        versionApp: versionApp ?? '1.0.0',
        checkMobile: checkMobile,
        root: '0',
      );

      final result = await _loginUseCase.call(params);
      await result.fold(
        (failure) async {
          emit(Unauthenticated(message: failure.message));
        },
        (authResult) async {
          final isManager = authResult.claims.contains('manager.approve') ||
              username.toLowerCase().contains('manager') ||
              username.toLowerCase().contains('ql');
          final role = isManager ? UserRole.manager : UserRole.employee;

          final user = UserSession(
            id: authResult.userId?.toString() ?? authResult.employeeCode,
            name: authResult.employeeName,
            email: authResult.email ?? '',
            employeeCode: authResult.employeeCode,
            department: isManager
                ? 'Phòng Kỹ thuật & Quản lý'
                : 'Bộ phận Phát triển Mobile',
            role: role,
            avatarUrl: authResult.avatar,
          );

          await _secureStorage.write(
            key: AppConstants.tokenStorageKey,
            value: authResult.token,
          );
          await _secureStorage.write(
            key: _userSessionKey,
            value: jsonEncode(user.toJson()),
          );
          await _secureStorage.write(
            key: _tokenValidToKey,
            value: authResult.validTo,
          );
          await _secureStorage.write(
            key: AppConstants.keySavedUsername,
            value: username,
          );
          await _secureStorage.write(
            key: AppConstants.keySavedPassword,
            value: password,
          );

          emit(Authenticated(user: user, token: authResult.token, role: role));
        },
      );
    } else {
      final isManager = username.toLowerCase().contains('manager') ||
          username.toLowerCase().contains('ql');
      final role = isManager ? UserRole.manager : UserRole.employee;
      await loginAsDemo(role);
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.tokenStorageKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenStorageKey);
    await _secureStorage.delete(key: _userSessionKey);
    await _secureStorage.delete(key: _tokenValidToKey);
    emit(const Unauthenticated());
  }
}
