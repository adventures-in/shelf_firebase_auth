import 'dart:convert';

import 'package:http/http.dart';

class JwtHeader {
  JwtHeader(this.alg, this.kid);

  final String alg;
  final String kid;

  // Verify id token following rules in:
  // https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
  Future<void> validate() async {
    // Algorithm "RS256"
    if (alg != 'RS256') throw 'Algorithm must be RS256';

    // Check the kid againt the public keys - we may want to use the value of
    // max-age in the Cache-Control header to know when to refresh the public keys
    final response = await Client().get(Uri.parse(
        'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'));
    final Map<String, dynamic> publicKeysMap = jsonDecode(response.body);

    if (!publicKeysMap.keys.contains(kid)) throw 'KeyId not in allowed list';
  }

  static JwtHeader fromJson(Map<String, dynamic> json) =>
      JwtHeader(json['alg'] as String, json['kid'] as String);

  Map<String, dynamic> toJson(JwtHeader instance) =>
      <String, dynamic>{'alg': alg, 'kid': kid};
}
