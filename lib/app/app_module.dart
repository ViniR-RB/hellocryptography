import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/modules/auth/auth_module.dart';
import 'package:hellocryptography/app/modules/documents/documents_module.dart';
import 'package:hellocryptography/app/modules/splash/splash_page.dart';

import 'core/services/open_file_service.dart';
import 'core/services/secure_storage.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => const [];

  @override
  void binds(Injector i) {
    i.addLazySingleton(SecureStorage.new);
    i.addLazySingleton(OpenFileService.new);
  }

  @override
  void exportedBinds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child("/", child: (_) => const SplashPage());
    r.module("/auth", module: AuthModule());
    r.module("/documents", module: DocumentsModule());
  }
}
