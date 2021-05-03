import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/pointycastle.dart'
    hide ASN1Parser, ASN1Sequence, ASN1Integer;

import 'jwt_header.dart';
import 'jwt_payload.dart';

class Jwt {
  Jwt(this._tokenString) {
    // Split the token string into it's 3 component parts
    final splitToken = _tokenString.split('.');
    if (splitToken.length != 3) {
      throw FormatException('Invalid token');
    }

    _headerString = splitToken[0];
    _payloadString = splitToken[1];
    _bodyString = '$_headerString.$_payloadString';
    _signatureString = splitToken[2];

    _header = JwtHeader.fromJson(_decodeFromBase64(_headerString));
    _payload = JwtPayload.fromJson(_decodeFromBase64(_payloadString));
  }

  final String _tokenString;
  late final String _headerString;
  late final String _payloadString;
  late final String _bodyString;
  late final String _signatureString;
  late final JwtHeader _header;
  late final JwtPayload _payload;

  // Check that the header has the expected values.
  // The publicKeys could come from different sources, in production from a
  // live endpoint.
  bool validateHeader(Map<String, String> publicKeys) =>
      _header.validate(publicKeys);

  // Check that the payload has the expected values.
  bool validatePayload(String projectId) => _payload.validate(projectId);

  Future<bool> verifySignature(Map<String, String> publicKeys) async {
    final pem = publicKeys[_header.kid]!;

    // RSAKeyPair(_publicKey(lines), _privateKey(lines))

    // _publicKey(List<String> lines)

    final keyString = (pem.split('\n')
          ..removeAt(0)
          ..removeLast())
        .join('');

    final keyBytes = base64.decode(keyString);
    var p = ASN1Parser(keyBytes);
    var seq = p.nextObject() as ASN1Sequence;

    // _pkcs8CertificatePrivateKey(ASN1Sequence seq)

    if (seq.elements.length != 3) throw 'Bad certificate format';
    final certificate = seq.elements.first as ASN1Sequence;

    seq = certificate.elements[6] as ASN1Sequence;

    // _pkcs8PublicKey(ASN1Sequence seq)

    p = ASN1Parser(seq.elements[1].valueBytes().sublist(1));

    // _pkcs1PublicKey(ASN1Sequence seq)

    seq = p.nextObject() as ASN1Sequence;
    final asn1Ints = seq.elements.cast<ASN1Integer>();

    final modulus = asn1Ints[0].valueAsBigInteger!;
    final exponent = asn1Ints[1].valueAsBigInteger!;

    final s = Signer('SHA-256/RSA');
    final key = RSAPublicKey(modulus, exponent);
    final param = ParametersWithRandom(
      PublicKeyParameter<RSAPublicKey>(key),
      SecureRandom('AES/CTR/PRNG'),
    );

    // bool verify(JWTSigner signer)

    final body = utf8.encode(_bodyString);
    final signature = base64.decode(_signatureString);

    s.init(false, param);
    final rsaSignature = RSASignature(signature);
    return s.verifySignature(Uint8List.fromList(body), rsaSignature);
  }

  Map<String, dynamic> _decodeFromBase64(String base64String) =>
      jsonDecode(utf8.decode(base64.decode(base64.normalize(base64String))));
}
