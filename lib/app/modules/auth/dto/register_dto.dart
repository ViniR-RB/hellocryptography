class RegisterDto {
  final String userName;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  RegisterDto({
    required this.userName,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return {
      "user_name": userName,
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    };
  }
}
