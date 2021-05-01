import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/signers/rsa_signer.dart';

class JwtSignature {
  JwtSignature(this.signatureString);

  final String signatureString;

  bool verify() {
    // looking at the crypto package README utf8.encode seems to be first step
    // final signatureAsInts = utf8.encode(signatureString);
    return true;
  }

  /// [signedData] - data that was supposedly signed
  bool rsaVerify(
      RSAPublicKey publicKey, Uint8List signedData, Uint8List signature) {
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
