import 'package:flutter_test/flutter_test.dart';
import 'package:vstech_hrm/core/errors/failures.dart';

void main() {
  group('Failure Equatable Props', () {
    test('ServerFailure props equality check', () {
      const f1 = ServerFailure(message: 'Internal Error', statusCode: 500);
      const f2 = ServerFailure(message: 'Internal Error', statusCode: 500);
      const f3 = ServerFailure(message: 'Different', statusCode: 400);

      expect(f1, equals(f2));
      expect(f1 == f3, isFalse);
    });

    test('NetworkFailure has default message', () {
      const f = NetworkFailure();
      expect(f.code, equals('NETWORK_ERROR'));
      expect(f.message, contains('Không thể kết nối'));
    });

    test('AuthFailure has status code 401', () {
      const f = AuthFailure(message: 'Unauthorized');
      expect(f.statusCode, equals(401));
    });
  });
}
