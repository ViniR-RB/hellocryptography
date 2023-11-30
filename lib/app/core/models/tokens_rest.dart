class TokensRest {
  final String acessToken;
  final String refreshToken;

  TokensRest({required this.acessToken, required this.refreshToken});

  factory TokensRest.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "access_token": final String acessToken,
        "refresh_token": final String refreshToken,
      } =>
        TokensRest(acessToken: acessToken, refreshToken: refreshToken),
      _ => throw ArgumentError(
          "Houve um problema em transformar os tokens rest da api"),
    };
  }
  String toJson() {
    return """{"access_token":"$acessToken","refresh_token": "$refreshToken"}""";
  }
}
