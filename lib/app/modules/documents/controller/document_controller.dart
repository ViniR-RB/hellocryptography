import 'package:flutter/foundation.dart';

import '../states/document_state.dart';

class DocumentController extends ValueNotifier<DocumentState> {
  DocumentController() : super(DocumentInitialState());

  emit(DocumentState state) {
    super.value = state;
  }
}
