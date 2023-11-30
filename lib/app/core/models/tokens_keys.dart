import 'dart:convert';

class TokensKeys {
  final String privateKey;
  final String publicKey;

  TokensKeys({required this.privateKey, required this.publicKey});

  toJson() {
    return """{"publicKey": "$publicKey", "privateKey": "$privateKey"}""";
  }

  factory TokensKeys.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "publicKey": final String privateKey,
        "privateKey": final String publicKey,
      } =>
        TokensKeys(privateKey: privateKey, publicKey: publicKey),
      _ => throw ArgumentError(
          "Houve um problema com a transformação dos dados da api"),
    };
  }

  factory TokensKeys.fromString(String values) {
    final Map<String, dynamic> jsonString = jsonDecode(values);
    return TokensKeys.fromMap(jsonString);
  }
}
