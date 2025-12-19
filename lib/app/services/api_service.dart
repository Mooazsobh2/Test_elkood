import 'package:dio/dio.dart';
import 'local_storage_service.dart';

class ApiService {
  final Dio dio;
  ApiService(this.dio);

  static Dio buildDio(LocalStorageService storage) {
    final d = Dio(BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      headers: {'Content-Type': 'application/json'},
    ));

    d.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = storage.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));

    return d;
  }
}
