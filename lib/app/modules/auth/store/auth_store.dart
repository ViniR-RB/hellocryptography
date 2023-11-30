import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/modules/auth/controller/login_controller.dart';
import 'package:hellocryptography/app/modules/auth/dto/login_dto.dart';
import 'package:hellocryptography/app/modules/auth/dto/register_dto.dart';
import 'package:hellocryptography/app/modules/auth/repository/auth_repository.dart';
import 'package:hellocryptography/app/modules/auth/states/login_state.dart';
import 'package:hellocryptography/app/modules/auth/states/signup_state.dart';

import '../../../core/fp/either.dart';
import '../controller/singup_controller.dart';
import '../exceptions/auth_repository_exception.dart';

class AuthStore {
  final AuthRepository _repository;
  final LoginController _loginController = LoginController();
  final SingupController _signUpController = SingupController();
  AuthStore(this._repository);

  Future<void> login(LoginDto login) async {
    _loginController.emit(LoginLoadingState());
    final result = await _repository.login(login);
    switch (result) {
      case Sucess():
        Modular.to.navigate("/documents/");
      case Failure(:final AuthRepositoryException exception):
        _loginController.emit(LoginErrorState(exception.message));
    }
  }

  Future<void> register(RegisterDto register) async {
    _signUpController.emit(SignUpLoadginState());
    final result = await _repository.register(register);
    switch (result) {
      case Sucess():
        _signUpController.emit(SignUpSucessState());
      case Failure(:final exception):
        _signUpController.emit(SignUpErrorState(exception.message));
    }
  }

  ValueNotifier<LoginState> get loginState => _loginController;
  ValueNotifier<SignUpState> get signUpState => _signUpController;

  restoreLoginState() {
    _loginController.emit(LoginInitialState());
  }

  restoreSignUpState() {
    _signUpController.emit(SignUpInitialState());
  }
}
