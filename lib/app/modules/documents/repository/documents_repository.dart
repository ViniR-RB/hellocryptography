import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hellocryptography/app/core/fp/nil.dart';
import 'package:hellocryptography/app/core/models/tokens_rest.dart';
import 'package:hellocryptography/app/modules/documents/dto/send_document_dto.dart';
import 'package:hellocryptography/app/modules/documents/exceptions/documents_repository_exeption.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/fp/either.dart';
import '../../../core/models/document_model.dart';
import '../../../core/services/secure_storage.dart';

class DocumentsRepository {
  final SecureStorage _secureStorage;
  final Dio _dio = Dio();

  DocumentsRepository(this._secureStorage);

  Future<Either<DocumentsRepositoryExeption, List<DocumentModel>>>
      getAllDocuments() async {
    try {
      final tokensString =
          await _secureStorage.readKeys(StorageKeys.keysTokens);
      final tokensJson = jsonDecode(tokensString!);
      final TokensRest tokensRest = TokensRest.fromMap(tokensJson);
      final response = await _dio.get<Map<String, dynamic>>(
          "https://crypto-doc.eelixo.com/api/v1/document",
          options: Options(
              headers: {"Authorization": "Bearer ${tokensRest.acessToken}"}));
      final data = response.data;
      final listData = data!["content"] as List<Map<String, dynamic>>?;
      if (listData == null) {
        return Sucess([]);
      }
      final List<DocumentModel> documents =
          listData.map((e) => DocumentModel.fromMap(e)).toList();
      return Sucess(documents);
    } catch (e, s) {
      log("Houve um problema inesperado", error: e, stackTrace: s);
      return Failure(
        DocumentsRepositoryExeption(
            "Houve um problema inesperado em pegar os documentos"),
      );
    }
  }

  Future<Either<DocumentsRepositoryExeption, Nil>> sendDocumentInsecure(
      SendDocumentEncryptedDto sendDocumentEncryptedDto) async {
    try {
      final tokensString =
          await _secureStorage.readKeys(StorageKeys.keysTokens);
      final tokensJson = jsonDecode(tokensString!);
      final TokensRest tokensRest = TokensRest.fromMap(tokensJson);
      final Map map = await sendDocumentEncryptedDto.toJson();
      await _dio.post("http://crypto-doc.eelixo.com/api/v1/document/insecure",
          data: map,
          options: Options(
              headers: {"Authorization": "Bearer ${tokensRest.acessToken}"}));
      return Sucess(Nil());
    } catch (e, s) {
      log("Houve um erro inesperado em enviar o documento",
          error: e, stackTrace: s);
      return Failure(DocumentsRepositoryExeption(
          "Houve um erro inesperado em enviar o documento"));
    }
  }
}
