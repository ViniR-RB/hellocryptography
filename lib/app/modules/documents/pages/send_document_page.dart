import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hellocryptography/app/modules/documents/dto/send_document_dto.dart';
import 'package:hellocryptography/app/modules/documents/store/document_store.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/services/open_file_service.dart';
import '../../../core/widgets/text_field_custom.dart';

class SendDocumentPage extends StatefulWidget {
  final DocumentStore store;
  const SendDocumentPage({super.key, required this.store});

  @override
  State<SendDocumentPage> createState() => _SendDocumentPageState();
}

class _SendDocumentPageState extends State<SendDocumentPage> {
  bool light = true;
  final _documentNameEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _filePicked = File("");
  final OpenFileService _openFileService = OpenFileService();
  openFile() async {
    final result = await _openFileService.pickFiles();
    if (result == null) {
    } else {
      setState(() {
        _filePicked = result;
      });
      _documentNameEC.text =
          _filePicked.path.split("file_picker/")[1].split(".")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Document")),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldCustom(
              controller: _documentNameEC,
              onTap: () async => await openFile(),
              labelText: "Nome do Documento",
              validator: Validatorless.required("Campo requerido"),
            ),
            light == true ? const Text("Via Https") : const Text("Via Http"),
            Switch(
                value: light,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  setState(() {
                    light = value;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async => await openFile(),
                  child: const Text("Selecione o Arquivo"),
                ),
                ElevatedButton(
                  onPressed: () async =>
                      await widget.store.sendDocumentInsecure(
                    SendDocumentEncryptedDto(
                        _documentNameEC.value.text, _filePicked),
                  ),
                  child: const Text("Enviar Arquivo"),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
