import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/app_module.dart';
import 'package:hellocryptography/app/modules/auth/pages/login_page.dart';
import 'package:hellocryptography/app/modules/auth/pages/signup_page.dart';
import 'package:hellocryptography/app/modules/auth/repository/auth_repository.dart';
import 'package:hellocryptography/app/modules/auth/store/auth_store.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [AppModule()];
  @override
  void binds(i) {
    i.addSingleton(AuthStore.new);
    i.addSingleton(AuthRepository.new);
  }

  @override
  void routes(r) {
    r.child(Modular.initialRoute,
        child: (_) => LoginPage(
              store: Modular.get<AuthStore>(),
            ));
    r.child("/signup",
        child: (_) => SignUpPage(store: Modular.get<AuthStore>()));
  }
}
