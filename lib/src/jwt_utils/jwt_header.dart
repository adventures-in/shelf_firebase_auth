import 'dart:convert';

import 'package:shelf_firebase_auth/src/jwt_utils/public_keys.dart';

class JwtHeader {
  JwtHeader(this.alg, this.kid);

  final String alg;
  final String kid;

  // Verify id token following rules in:
  // https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
  void validate() {
    // Algorithm "RS256"
    if (alg != 'RS256') throw 'Algorithm must be RS256';

    // checking the kid againt the public keys at https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com
    // not sure if the keys could change so may need to retrieve the keys each time (or preferably cache them somewhere)
    final Map<String, dynamic> publicKeysMap = jsonDecode(publicKeysString);
    if (!publicKeysMap.keys.contains(kid)) throw 'KeyId not in allowed list';
  }

  static JwtHeader fromJson(Map<String, dynamic> json) =>
      JwtHeader(json['alg'] as String, json['kid'] as String);

  Map<String, dynamic> toJson(JwtHeader instance) =>
      <String, dynamic>{'alg': alg, 'kid': kid};
}
