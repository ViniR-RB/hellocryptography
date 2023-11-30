import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/app_module.dart';
import 'package:hellocryptography/app/modules/documents/pages/document_page.dart';
import 'package:hellocryptography/app/modules/documents/pages/send_document_page.dart';
import 'package:hellocryptography/app/modules/documents/repository/documents_repository.dart';
import 'package:hellocryptography/app/modules/documents/store/document_store.dart';

class DocumentsModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton(DocumentStore.new);
    i.addLazySingleton(DocumentsRepository.new);
  }

  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      child: (_) => DocumentPage(
        store: Modular.get<DocumentStore>(),
      ),
    );
    r.child("/send-document",
        child: (_) => SendDocumentPage(
              store: Modular.get<DocumentStore>(),
            ));
  }
}
