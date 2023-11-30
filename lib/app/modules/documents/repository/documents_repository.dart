import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hellocryptography/app/core/fp/nil.dart';
import 'package:hellocryptography/app/core/models/tokens_keys.dart';
import 'package:hellocryptography/app/core/models/tokens_rest.dart';
import 'package:hellocryptography/app/modules/documents/dto/send_document_dto.dart';
import 'package:hellocryptography/app/modules/documents/dto/send_document_encrypted_secure_dto.dart';
import 'package:hellocryptography/app/modules/documents/exceptions/documents_repository_exeption.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pem/pem.dart';
// ignore: depend_on_referenced_packages
import 'package:pointycastle/asymmetric/api.dart'
    show RSAPrivateKey, RSAPublicKey;

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
          "http://crypto-doc.eelixo.com/api/v1/document",
          options: Options(
              headers: {"Authorization": "Bearer ${tokensRest.acessToken}"}));
      final data = response.data;
      final listData = data!["content"] as List<dynamic>?;
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
      await _dio.post("https://crypto-doc.eelixo.com/api/v1/document/unsecure",
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

  Future<Either<DocumentsRepositoryExeption, Nil>> sendDocumentSecure(
      SendDocumentEncryptedSecureDto dto) async {
    try {
      final tokensString =
          await _secureStorage.readKeys(StorageKeys.keysTokens);
      final tokensJson = jsonDecode(tokensString!);
      final TokensRest tokensRest = TokensRest.fromMap(tokensJson);
      final response = await _dio.get<Map>(
        "https://crypto-doc.eelixo.com/api/v1/public-key",
        options: Options(
          headers: {"Authorization": "Bearer ${tokensRest.acessToken}"},
        ),
      );

      final tokensKeysString =
          await _secureStorage.readKeys(StorageKeys.keysEncryption);
      final tokensKeysJson = jsonDecode(tokensKeysString!);
      final TokensKeys tokensKeys = TokensKeys.fromMap(tokensKeysJson);

      List<int> privateKeyString = PemCodec(PemLabel.privateKey).decode("""
  -----BEGIN PRIVATE KEY-----
  ${tokensKeys.privateKey}
  -----END PRIVATE KEY-----
""");
      List<int> publicKeyString = PemCodec(PemLabel.publicKey).decode("""
  -----BEGIN PUBLIC KEY-----
  ${tokensKeys.publicKey}
  -----END PUBLIC KEY-----
""");
      Directory tempDir = await getTemporaryDirectory();
      File filePrivate = File("${tempDir.path}/private.pem");
      File filePublic = File("${tempDir.path}/public.pem");

      /* await filePublic.writeAsBytes(publicKeyString, mode: FileMode.append);
      await filePrivate.writeAsBytes(privateKeyString, mode: FileMode.append); */
      final parser = RSAKeyParser();

      final base64EncodedDataPrivate = await filePrivate.readAsString();
      final decodedDataPrivate = base64Decode(base64EncodedDataPrivate);

      final decodedBytes = base64.decode(base64EncodedDataPrivate);
      final decodedString = utf8.decode(decodedBytes);

      final privateKey = parser.parse(decodedString) as RSAPrivateKey?;

      final base64EncodedDataPublic = await filePublic.readAsString();
      final decodedDataPublic = base64Decode(base64EncodedDataPublic);

      final publicKey =
          parser.parse(utf8.decode(publicKeyString)) as RSAPublicKey?;

      final encrypter = Encrypter(
        RSA(publicKey: publicKey, privateKey: null),
      );

      final Map data = response.data!;
      data["aes_key"] = encrypter.decrypt(data["aes_key"]);
      data["iv_spec"] = encrypter.decrypt(data["iv_spec"]);

      final SendDocumentEncryptedSecureDto newDto =
          SendDocumentEncryptedSecureDto(
              dto.documentName, dto.document, data["aes_key"], data["iv_spec"]);
      final Map newMap = await newDto.toJson();

      await _dio.post(
        "https://crypto-doc.eelixo.com/api/v1/document",
        data: newMap,
        options: Options(
          headers: {"Authorization": "Bearer ${tokensRest.acessToken}"},
        ),
      );
      return Sucess(Nil());
    } catch (e, s) {
      log("Houve um erro inesperado em enviar um documento seguro",
          error: e, stackTrace: s);
      return Failure(DocumentsRepositoryExeption(
          "Houve um erro inesperado em enviar um documento seguro"));
    }
  }
}
