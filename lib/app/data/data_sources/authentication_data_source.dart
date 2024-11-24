import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../helpers/helpers.dart';
import '../models/models.dart';

class AuthenticationDataSource {
  final Dio client;

  AuthenticationDataSource({
    required this.client,
  });

  final table = Hive.openBox<UserModel>('user');

  bool enableMock = false;

  Future<Either<String?, UserModel>> singIn({
    required String password,
    required String email,
    required int tried,
  }) async {
    try {
      final box = await Hive.openBox<String>('trial');
      final date = DateTime.tryParse(box.get(0) ?? '');
      if (date != null && DateTime.now().difference(date).inMinutes < 15) {
        return const Left(
            'Limite de tentativas de login excedido, por favor aguarde 15 minutos para tentar novamente.');
      }
      await box.clear();

      if (!enableMock) {
        final result = await client.post('/login', data: {
          'username': email,
          'password': password,
        });

        var user = UserModel.fromMap(result.data);

        await (await table).put(0, user);
        return Right(user);
      } else {
        final user =
            UserModel(email: email, token: 'token', username: 'username');

        await (await table).put(0, user);
        return Right(user);
      }
    } on DioError catch (e) {
      final box = await Hive.openBox<String>('trial');

      if (tried >= 3 && box.values.isEmpty) {
        final box = await Hive.openBox<String>('trial');
        await box.put(0, DateTime.now().toString());
      }
      return Left(e.message.toString());
    } catch (e) {
      return const Left(null);
    }
  }

  Future<Either<CommonError, UserModel>> getUser() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      UserModel? result = (await table).getAt(0);
      return Right(result!);
    } catch (e) {
      return const Left(CommonError.unauthenticated());
    }
  }

  Future<Either<CommonError, bool>> resetPassword({
    required String email,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      // ignore: void_checks
      return const Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }
}
