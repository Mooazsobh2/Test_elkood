import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient(this.dio);

  static Dio buildDio() {
    return Dio(BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
    ));
  }
}
