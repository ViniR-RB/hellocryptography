import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/modules/auth/dto/register_dto.dart';
import 'package:hellocryptography/app/modules/auth/states/signup_state.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/widgets/text_field_custom.dart';
import '../store/auth_store.dart';

class SignUpPage extends StatefulWidget {
  final AuthStore store;
  const SignUpPage({super.key, required this.store});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.store.signUpState,
      builder: (context, value, child) {
        return switch (value) {
          SignUpInitialState() => SignUpInitialPage(
              store: widget.store,
            ),
          SignUpSucessState() => Scaffold(
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Cadastro bem Sucedido"),
                      ElevatedButton(
                        onPressed: () => Modular.to.pop(),
                        child: const Text("Ir para página de Entrar"),
                      )
                    ]),
              ),
            ),
          SignUpErrorState() => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(value.message),
                    ElevatedButton(
                      onPressed: () => widget.store.restoreSignUpState(),
                      child: const Text("Tentar Novamente"),
                    ),
                  ],
                ),
              ),
            ),
          SignUpLoadginState() => const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            )
        };
      },
    );
  }
}

class SignUpInitialPage extends StatefulWidget {
  final AuthStore store;
  const SignUpInitialPage({super.key, required this.store});

  @override
  State<SignUpInitialPage> createState() => _SignUpInitialPageState();
}

class _SignUpInitialPageState extends State<SignUpInitialPage> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastre-se"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFieldCustom(
                  labelText: "Nome do Usuário", controller: _userName),
              TextFieldCustom(
                controller: _email,
                labelText: "E-mail",
                validator: Validatorless.multiple([
                  Validatorless.email(
                      "Esse campo não está no formato de um E-mail")
                ]),
              ),
              TextFieldCustom(
                labelText: "Senha",
                controller: _password,
              ),
              TextFieldCustom(
                labelText: "Confirme a Senha",
                validator: (String? value) {
                  if (value == _password.value.text) {
                    return null;
                  } else {
                    return "Senhas não conferem";
                  }
                },
              ),
              TextFieldCustom(
                labelText: "Primeiro Nome",
                controller: _firstName,
              ),
              TextFieldCustom(
                labelText: "Segundo Nome",
                controller: _lastName,
              ),
              ElevatedButton(
                onPressed: () {
                  switch (_formKey.currentState!.validate()) {
                    case true:
                      widget.store.register(RegisterDto(
                          userName: _userName.value.text,
                          email: _email.value.text,
                          password: _password.value.text,
                          firstName: _firstName.value.text,
                          lastName: _lastName.value.text));
                    case false:
                  }
                },
                child: const Text("Cadastrar-se"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
