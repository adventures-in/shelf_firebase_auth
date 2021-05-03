class JwtHeader {
  JwtHeader(this.alg, this.kid);

  final String alg;
  final String kid;

  // Verify id token following rules in:
  // https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
  //
  // If valid, return the public key.
  bool validate(Map<String, String> publicKeys) {
    // Algorithm "RS256"
    if (alg != 'RS256') throw 'Algorithm must be RS256';

    if (!publicKeys.containsKey(kid)) throw 'KeyId not in allowed list';

    return true;
  }

  static JwtHeader fromJson(Map<String, dynamic> json) =>
      JwtHeader(json['alg'] as String, json['kid'] as String);

  Map<String, dynamic> toJson(JwtHeader instance) =>
      <String, dynamic>{'alg': alg, 'kid': kid};
}
