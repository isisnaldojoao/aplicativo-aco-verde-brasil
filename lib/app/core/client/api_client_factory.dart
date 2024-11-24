import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/models/user_model.dart';

class ApiClientFactory {
  static final table = Hive.openBox<UserModel>('user');

  static Dio create({
    required String baseUrl,
  }) {
    final dio = Dio();

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = 5000;

    dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final tokenBox = (await table).get(0);
        final token = tokenBox?.token;
        if (token != null) {
          options.headers['authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    return dio;
  }
}
