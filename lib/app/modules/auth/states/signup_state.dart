sealed class SignUpState {}

final class SignUpInitialState extends SignUpState {}

final class SignUpLoadginState extends SignUpState {}

final class SignUpSucessState extends SignUpState {}

final class SignUpErrorState extends SignUpState {
  final String message;
  SignUpErrorState(this.message);
}
