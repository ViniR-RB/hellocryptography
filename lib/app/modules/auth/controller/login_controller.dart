import 'package:flutter/material.dart';
import 'package:hellocryptography/app/modules/auth/states/login_state.dart';

class LoginController extends ValueNotifier<LoginState> {
  LoginController() : super(LoginInitialState());

  void emit(LoginState state) {
    super.value = state;
  }
}
