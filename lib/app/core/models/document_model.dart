class DocumentModel {
  final int id;
  final String name;

  DocumentModel(this.id, this.name);

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "id": final int id,
        "name": final String name,
      } =>
        DocumentModel(id, name),
      _ =>
        throw ArgumentError("Houve um problema em transoformar os dados da api")
    };
  }
}
