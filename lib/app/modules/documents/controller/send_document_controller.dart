import 'package:flutter/material.dart';
import 'package:hellocryptography/app/modules/documents/states/send_document_state.dart';

class SendDocumentController extends ValueNotifier<SendDocumentState> {
  SendDocumentController() : super(SendDocumentInitialState());

  emit(SendDocumentState state) {
    super.value = state;
  }
}
