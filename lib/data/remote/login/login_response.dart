class LoginResponse {
  String? token;
  String? tokenType;

  LoginResponse({this.token, this.tokenType});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}