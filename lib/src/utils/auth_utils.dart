import 'package:shelf_firebase_auth/src/utils/jwt_utils/jwt.dart';

bool validateAuthHeader(String? authHeader) {
  if (authHeader == null) throw 'No auth header';
  final splitHeader = authHeader.split(' ');
  if (splitHeader.first != 'Bearer') throw 'Auth header must be Bearer';

  final jwt = Jwt(splitHeader.last);

  return true;
}
