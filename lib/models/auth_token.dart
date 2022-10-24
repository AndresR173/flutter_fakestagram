class AuthToken {
  String? idToken;
  String? refreshToken;
  String? expiresIn;

  AuthToken({
    this.idToken,
    this.refreshToken,
    this.expiresIn,
  });

  AuthToken.fromJson(Map<String, dynamic> json) {
    idToken = json['idToken'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() => {
        'idToken': idToken,
        'refreshToken': refreshToken,
        'expiresIn': expiresIn,
      };
}
