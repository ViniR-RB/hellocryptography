import 'package:hellocryptography/app/core/models/document_model.dart';

sealed class DocumentState {}

final class DocumentInitialState extends DocumentState {}

final class DocumentLoadginState extends DocumentState {}

final class DocumentLoadedState extends DocumentState {
  final List<DocumentModel> documents;
  DocumentLoadedState(this.documents);
}

final class DocumentLoadedEmptyListState extends DocumentState {}

final class DocumentErrorState extends DocumentState {
  final String message;
  DocumentErrorState(this.message);
}
