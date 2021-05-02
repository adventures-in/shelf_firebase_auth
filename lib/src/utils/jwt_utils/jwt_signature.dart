import 'dart:convert';

import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/signers/rsa_signer.dart';

/// [sigendDataString] - data that was supposedly signed
class JwtSignature {
  JwtSignature(this.signedDataString, this.signatureString);

  final String signedDataString;
  final String signatureString;

  bool verify() {
    // looking at the crypto package README utf8.encode seems to be first step
    // final signatureAsInts = utf8.encode(signatureString);

    // RSA Signature verification

    // modulus and exponent
    final publicKey = RSAPublicKey(BigInt.from(1), BigInt.from(2));

    final signedData = base64.decode(base64.normalize(signedDataString));
    final signature = base64.decode(base64.normalize(signatureString));
    final sig = RSASignature(signature);

    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');

    verifier.init(
        false, PublicKeyParameter<RSAPublicKey>(publicKey)); // false=verify

    try {
      return verifier.verifySignature(signedData, sig);
    } on ArgumentError {
      return false; // for Pointy Castle 1.0.2 when signature has been modified
    }
  }
}
