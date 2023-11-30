import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hellocryptography/app/core/constants/storage_keys.dart';
import 'package:hellocryptography/app/core/models/tokens_keys.dart';
import 'package:hellocryptography/app/core/models/tokens_rest.dart';
import 'package:hellocryptography/app/core/services/secure_storage.dart';
import 'package:hellocryptography/app/modules/auth/exceptions/auth_repository_exception.dart';

import '../../../core/fp/either.dart';
import '../dto/login_dto.dart';
import '../dto/register_dto.dart';

class AuthRepository {
  final SecureStorage _storage;

  final Dio dio = Dio();
  AuthRepository(this._storage);
  Future<Either<AuthRepositoryException, TokensKeys>> register(
      RegisterDto registerDto) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        "https://crypto-doc.eelixo.com/api/v1/auth/register",
        data: registerDto.toMap(),
      );
      final data = response.data;
      final tokensApi = TokensKeys.fromMap(data!);
      await _storage.addKeys(tokensApi.toJson(), StorageKeys.keysEncryption);
      return Sucess(tokensApi);
    } on DioException catch (e, s) {
      log("Houve algum problema com o cadastro tente novamente mais tarde",
          error: e, stackTrace: s);
      return Failure(AuthRepositoryException(
          "Houve algum problema com o cadastro tente novamente depois", s));
    } catch (e, s) {
      log("Houve um problema inesperado", error: e, stackTrace: s);
      return Failure(AuthRepositoryException("Houve um problema inesperado"));
    }
  }

  Future<Either<AuthRepositoryException, TokensRest>> login(
      LoginDto login) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
          "https://crypto-doc.eelixo.com/api/v1/auth/token",
          data: login.toLogin());
      final data = response.data;
      final tokensRest = TokensRest.fromMap(data!);
      await _storage.addKeys(tokensRest.toJson(), StorageKeys.keysTokens);
      return Sucess(tokensRest);
    } on DioException catch (e, s) {
      log("Houve algum problema com o login tente novamente mais tarde",
          error: e, stackTrace: s);
      return Failure(AuthRepositoryException(
          "Houve algum problema com o login tente novamente mais tarde"));
    } catch (e, s) {
      log("Houve um problema inesperado", error: e, stackTrace: s);
      return Failure(AuthRepositoryException("Houve um problema inesperado"));
    }
  }
}
