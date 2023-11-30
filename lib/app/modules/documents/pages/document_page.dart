import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hellocryptography/app/core/models/document_model.dart';
import 'package:hellocryptography/app/modules/documents/store/document_store.dart';

import '../states/document_state.dart';

class DocumentPage extends StatefulWidget {
  final DocumentStore store;
  const DocumentPage({super.key, required this.store});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  @override
  void initState() {
    widget.store.getAllDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.store.documentState,
      builder: (context, value, child) {
        return switch (value) {
          DocumentInitialState() => const Scaffold(
              body: SizedBox.shrink(),
            ),
          DocumentLoadginState() => const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          DocumentLoadedState() => DocumentLoadedPage(
              documents: value.documents,
            ),
          DocumentLoadedEmptyListState() =>
            const DocumentLoadedPage(documents: []),
          DocumentErrorState() => Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(value.message),
                  ElevatedButton(
                      onPressed: () async =>
                          await widget.store.getAllDocuments(),
                      child: const Text("Tentar Novamente"))
                ],
              ),
            )
        };
      },
    );
  }
}

class DocumentLoadedPage extends StatelessWidget {
  final List<DocumentModel> documents;
  const DocumentLoadedPage({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents"),
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => Modular.to.pushNamed("/documents/send-document"),
        child: const Icon(Icons.add),
      ),
      body: documents.isEmpty
          ? const Center(
              child: Text("Não há nenhum documento, envie agora mesmo"),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              padding: const EdgeInsets.all(20),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(document.name),
                );
              },
            ),
    );
  }
}
