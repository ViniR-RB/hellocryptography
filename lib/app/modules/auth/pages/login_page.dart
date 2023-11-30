import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/modules/auth/dto/login_dto.dart';
import 'package:hellocryptography/app/modules/auth/states/login_state.dart';
import 'package:hellocryptography/app/modules/auth/store/auth_store.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/widgets/text_field_custom.dart';

class LoginPage extends StatefulWidget {
  final AuthStore store;
  const LoginPage({super.key, required this.store});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.store.loginState,
      builder: (context, value, child) {
        return switch (value) {
          LoginInitialState() => LoginInitialPage(store: widget.store),
          LoginLoadingState() => const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          LoginErrorState() => Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Text(value.message),
                    ElevatedButton(
                      onPressed: () => widget.store.restoreLoginState(),
                      child: const Text("Tentar Novamente"),
                    )
                  ],
                ),
              ),
            ),
        };
      },
    );
  }
}

class LoginInitialPage extends StatefulWidget {
  final AuthStore store;
  const LoginInitialPage({super.key, required this.store});

  @override
  State<LoginInitialPage> createState() => _LoginInitialPageState();
}

class _LoginInitialPageState extends State<LoginInitialPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameEC = TextEditingController();
  final _passwordEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldCustom(
                  labelText: "Nome do Usuário",
                  controller: _userNameEC,
                  validator: Validatorless.multiple([
                    Validatorless.required("Username é requerido"),
                  ]),
                ),
                TextFieldCustom(
                  labelText: "Password",
                  controller: _passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.min(
                        6, "Senha precisa no minímo 6 Caracteres"),
                    Validatorless.required("Senha é requerido"),
                  ]),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    switch (_formKey.currentState!.validate()) {
                      case true:
                        widget.store.login(
                          LoginDto(
                              userName: _userNameEC.value.text,
                              password: _passwordEC.value.text),
                        );
                      case false:
                        _formKey.currentState!.activate();
                    }
                  },
                  child: const Text("Fazer Login"),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Modular.to.pushNamed("/auth/signup"),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text.rich(
                TextSpan(
                  text: "Você ainda  não tem conta?",
                  children: [
                    TextSpan(
                      text: " Registre-se",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
