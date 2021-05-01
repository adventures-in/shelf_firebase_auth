class JwtSignature {
  JwtSignature(this.signatureString);

  final String signatureString;

  bool verify() {
    // looking at the crypto package README utf8.encode seems to be first step
    // final signatureAsInts = utf8.encode(signatureString);
    return true;
  }
}
