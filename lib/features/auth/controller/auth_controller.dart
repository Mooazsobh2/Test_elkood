import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../app/services/local_storage_service.dart';
import '../../../app/services/api_service.dart';
import '../domain/entities/register_request.dart';

class AuthController extends GetxController {
  final LocalStorageService storage;
  final ApiService api;
  AuthController(this.storage, this.api);

  final loading = false.obs;
  final token = RxnString();
  final username = RxnString();
  final email = RxnString();
  final userId = RxnInt();

  bool get isLoggedIn => (token.value ?? '').isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    final u = storage.user;
    if (u != null) {
      userId.value = u['id'] as int?;
      username.value = (u['username'] as String?) ?? '';
      email.value = (u['email'] as String?) ?? '';
    }
    token.value = storage.token;
  }

  Future<void> login({required String username, required String password}) async {
    loading.value = true;
    try {
      final res = await api.dio.post('/auth/login', data: {'username': username, 'password': password});
      final t = (res.data as Map)['token'] as String?;
      if (t == null || t.isEmpty) throw DioException(requestOptions: res.requestOptions, error: 'Missing token');
      await storage.setToken(t);
      token.value = t;

      // Persist minimal user
      final existing = storage.user ?? {'id': null, 'email': '', 'username': username};
      existing['username'] = username;
      await storage.setUser(Map<String, dynamic>.from(existing));
      this.username.value = username;
    } finally {
      loading.value = false;
    }
  }

  Future<void> registerAndLogin(RegisterRequest req) async {
    loading.value = true;
    try {
      final res = await api.dio.post('/users', data: req.toJson());
      final m = (res.data as Map).cast<String, dynamic>();

      // Save user basics
      final u = {
        'id': (m['id'] as num?)?.toInt(),
        'email': (m['email'] as String?) ?? req.email,
        'username': (m['username'] as String?) ?? req.username,
      };
      await storage.setUser(u);
      userId.value = u['id'] as int?;
      email.value = u['email'] as String?;
      username.value = u['username'] as String?;

      await login(username: req.username, password: req.password);
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await storage.setUser(null);
    await storage.setToken(null);
    userId.value = null;
    username.value = null;
    email.value = null;
    token.value = null;
  }
}
