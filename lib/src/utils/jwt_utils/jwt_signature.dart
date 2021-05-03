/// [sigendDataString] - data that was supposedly signed
class JwtSignature {
  JwtSignature(this._originalData, this._signatureString, this._publicKey);

  final String _originalData;
  final String _signatureString;
  // The "corsac_jwt" packge requires a public key in PEM format but luckily
  // that's the same format that firebase provides
  final String _publicKey;

  void verify() {}
}

// Pointy Castle RSA Signature verification

//   // modulus and exponent
//   final publicKey = RSAPublicKey(BigInt.from(1), BigInt.from(2));

//   final signedData = base64.decode(base64.normalize(signedDataString));
//   final signature = base64.decode(base64.normalize(signatureString));
//   final sig = RSASignature(signature);

//   final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');

//   verifier.init(
//       false, PublicKeyParameter<RSAPublicKey>(publicKey)); // false=verify

//   try {
//     return verifier.verifySignature(signedData, sig);
//   } on ArgumentError {
//     return false; // for Pointy Castle 1.0.2 when signature has been modified
//   }
// }
