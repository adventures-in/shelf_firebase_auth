import 'dart:convert';

import 'jwt_header.dart';
import 'jwt_payload.dart';
import 'jwt_signature.dart';

class Jwt {
  Jwt(this.tokenString) {
    // Split the token string into it's 3 component parts
    final splitToken = tokenString.split('.');
    if (splitToken.length != 3) {
      throw FormatException('Invalid token');
    }

    header = JwtHeader.fromJson(_decodeFromBase64(splitToken[0]));
    payload = JwtPayload.fromJson(_decodeFromBase64(splitToken[1]));
    signature = JwtSignature(splitToken[2]);
  }

  final tokenString;

  late final JwtHeader header;
  late final JwtPayload payload;
  late final JwtSignature signature;

  bool validate(String projectId) {
    // Check that the header has the expected values.
    header.validate();

    // Check that the payload has the expected values.
    payload.validate(projectId);

    return true;
  }

  bool verify() {
    signature.verify();

    return true;
  }

  Map<String, dynamic> _decodeFromBase64(String base64String) =>
      jsonDecode(utf8.decode(base64.decode(base64.normalize(base64String))));
}
