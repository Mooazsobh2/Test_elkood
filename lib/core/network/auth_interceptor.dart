import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage storage;
  AuthInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}
