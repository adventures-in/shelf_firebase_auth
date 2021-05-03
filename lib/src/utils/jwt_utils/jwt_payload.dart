class JwtPayload {
  JwtPayload(this.exp, this.iat, this.aud, this.iss, this.sub, this.auth_time);

  final int exp;
  final int iat;
  final String aud;
  final String iss;
  final String sub;
  final int auth_time;

  // getters
  DateTime get expirationTime =>
      DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  DateTime get issuedAtTime => DateTime.fromMillisecondsSinceEpoch(iat * 1000);
  DateTime get authenticationTime =>
      DateTime.fromMillisecondsSinceEpoch(auth_time * 1000);
  Duration get tokenLifetime => Duration(seconds: exp - iat);

  // Check token components and throws if anything is invalid.
  //  + 5 minutes for clock skew ?
  bool validate(String projectId) {
    final currentDate = DateTime.now();

    // If the current date is after the expiration date, token is expired
    if (currentDate.isAfter(expirationTime)) throw 'Token is old.';
    // If the the Issued-at time is not in the past, token is invalid
    if (currentDate.isBefore(issuedAtTime)) throw 'Token is from the future.';

    // aud = Audience
    // Must be your Firebase project ID, the unique identifier for your Firebase project, which can be found in the URL of that project's console.
    if (aud != projectId) throw 'Token audience != projectId.';

    // iss = Issuer
    // Must be "https://securetoken.google.com/<projectId>", where <projectId> is the same project ID used for aud above.
    if (iss != 'https://securetoken.google.com/$aud') throw 'invalid Issuer';

    // sub = Subject
    // Must be a non-empty string and must be the uid of the user or device.
    // TODO: compare to the final uid

    // auth_time Authentication time
    // Must be in the past. The time when the user authenticated.
    if (currentDate.isBefore(authenticationTime)) {
      throw 'User authenticated in the future.';
    }

    return true;
  }

  String get projectId => aud;

  static JwtPayload fromJson(Map<String, dynamic> json) => JwtPayload(
        json['exp'] as int,
        json['iat'] as int,
        json['aud'] as String,
        json['iss'] as String,
        json['sub'] as String,
        json['auth_time'] as int,
      );

  Map<String, dynamic> toJson(JwtPayload instance) => <String, dynamic>{
        'exp': instance.exp,
        'iat': instance.iat,
        'aud': instance.aud,
        'iss': instance.iss,
        'sub': instance.sub,
        'auth_time': instance.auth_time,
      };
}
