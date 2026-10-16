import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vstech_hrm/core/router/route_guards.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late MockBuildContext mockContext;
  late MockGoRouterState mockState;

  setUp(() {
    mockContext = MockBuildContext();
    mockState = MockGoRouterState();
  });

  void setPath(String path) {
    when(() => mockState.uri).thenReturn(Uri.parse(path));
  }

  group('authRedirectGuard Tests', () {
    test('keeps user on /login during AuthLoading without redirecting to splash', () {
      setPath(AppRoutes.login);
      final result = authRedirectGuard(mockContext, mockState, const AuthLoading());
      expect(result, isNull);
    });

    test('keeps user on /forgot-password during AuthLoading without redirecting to splash', () {
      setPath(AppRoutes.forgotPassword);
      final result = authRedirectGuard(mockContext, mockState, const AuthLoading());
      expect(result, isNull);
    });

    test('keeps user on /splash during AuthLoading', () {
      setPath(AppRoutes.splash);
      final result = authRedirectGuard(mockContext, mockState, const AuthLoading());
      expect(result, isNull);
    });

    test('redirects to /splash during AuthInitial when on other routes', () {
      setPath('/home');
      final result = authRedirectGuard(mockContext, mockState, const AuthInitial());
      expect(result, equals(AppRoutes.splash));
    });

    test('allows user to stay on /splash during AuthInitial', () {
      setPath(AppRoutes.splash);
      final result = authRedirectGuard(mockContext, mockState, const AuthInitial());
      expect(result, isNull);
    });

    test('allows user to stay on /login when Unauthenticated', () {
      setPath(AppRoutes.login);
      final result = authRedirectGuard(
        mockContext,
        mockState,
        const Unauthenticated(message: 'Wrong credentials'),
      );
      expect(result, isNull);
    });

    test('redirects to /login when Unauthenticated and accessing protected route', () {
      setPath(AppRoutes.home);
      final result = authRedirectGuard(
        mockContext,
        mockState,
        const Unauthenticated(),
      );
      expect(result, equals(AppRoutes.login));
    });

    test('redirects to /home when Authenticated employee is on /login', () {
      setPath(AppRoutes.login);
      const user = UserSession(
        id: '1',
        name: 'Nguyen Van An',
        email: 'an@vstech.vn',
        employeeCode: 'NV0142',
        department: 'Tech',
        role: UserRole.employee,
      );
      final result = authRedirectGuard(
        mockContext,
        mockState,
        const Authenticated(user: user, token: 'token123', role: UserRole.employee),
      );
      expect(result, equals(AppRoutes.home));
    });

    test('redirects non-manager away from manager routes to /home', () {
      setPath('${AppRoutes.approvals}/detail');
      const user = UserSession(
        id: '1',
        name: 'Nguyen Van An',
        email: 'an@vstech.vn',
        employeeCode: 'NV0142',
        department: 'Tech',
        role: UserRole.employee,
      );
      final result = authRedirectGuard(
        mockContext,
        mockState,
        const Authenticated(user: user, token: 'token123', role: UserRole.employee),
      );
      expect(result, equals(AppRoutes.home));
    });
  });
}
