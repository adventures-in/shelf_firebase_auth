import 'dart:convert';

import 'package:shelf_firebase_auth/src/utils/jwt_utils/jwt.dart';
import 'package:test/test.dart';

import 'data/example_token.dart';
import 'data/public_keys.dart';

/// I have been testing with a valid token from another project (id  = the-process-tool)
/// If a test fails due to an old token, just run the_process and copy the token into
/// test/data/example_token.dart
void main() {
  group('JWT', () {
    test('header validation works on a valid token', () async {
      final publicKeys = json.decode(publicKeysString);
      Jwt(token).validateHeader(publicKeys);
    });

    test('payload validation works on a valid token', () {
      Jwt(token).validatePayload('the-process-tool');
    });

    test('signature verification works on a valid token', () {
      final publicKeys = json.decode(publicKeysString);
      Jwt(token).verifySignature(publicKeys);
    });
  });
}
