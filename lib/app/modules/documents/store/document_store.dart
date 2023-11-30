import 'package:flutter/foundation.dart';
import 'package:hellocryptography/app/modules/documents/controller/document_controller.dart';
import 'package:hellocryptography/app/modules/documents/controller/send_document_controller.dart';
import 'package:hellocryptography/app/modules/documents/dto/send_document_dto.dart';
import 'package:hellocryptography/app/modules/documents/repository/documents_repository.dart';
import 'package:hellocryptography/app/modules/documents/states/document_state.dart';
import 'package:hellocryptography/app/modules/documents/states/send_document_state.dart';

import '../../../core/fp/either.dart';

class DocumentStore {
  final DocumentController _documentState = DocumentController();
  final SendDocumentController _sendDocumentState = SendDocumentController();
  final DocumentsRepository _repository;

  DocumentStore(this._repository);

  getAllDocuments() async {
    _documentState.emit(DocumentLoadginState());
    final result = await _repository.getAllDocuments();

    switch (result) {
      case Sucess(:final value):
        value.isEmpty
            ? _documentState.emit(DocumentLoadedEmptyListState())
            : _documentState.emit(DocumentLoadedState(value));
      case Failure(:final exception):
        _documentState.emit(DocumentErrorState(exception.message));
    }
  }

  Future<void> sendDocumentInsecure(
      SendDocumentEncryptedDto sendDocumentEncryptedDto) async {
    _sendDocumentState.emit(SendDocumentLoadignState());
    final result =
        await _repository.sendDocumentInsecure(sendDocumentEncryptedDto);

    switch (result) {
      case Sucess():
        _sendDocumentState.emit(SendDocumentSucessState());
      case Failure(:final exception):
        _sendDocumentState.emit(SendDocumentErrorState(exception.message));
    }
  }

  ValueNotifier<DocumentState> get documentState => _documentState;
}
