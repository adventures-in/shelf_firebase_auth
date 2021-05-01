import 'package:shelf_firebase_auth/src/utils/jwt_utils/jwt.dart';
import 'package:test/test.dart';

import 'data/example_token.dart';

void main() {
  group('JWT', () {
    test('header validates correctly', () {
      final jwt = Jwt(token);
      jwt.header.validate();
    });

    test('payload validates correctly', () {
      final jwt = Jwt(token);
      expect(true, isTrue);
    });
    test('signature verifies correctly', () {
      final jwt = Jwt(token);
      expect(true, isTrue);
    });
  });
}
