class LoginDto {
  final String userName;
  final String password;

  LoginDto({required this.userName, required this.password});

  toLogin() {
    return {
      "login": userName,
      "password": password,
    };
  }
}
