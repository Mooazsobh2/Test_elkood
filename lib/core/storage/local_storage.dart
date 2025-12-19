import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKeys {
  static const seenOnboarding = 'shop_seen_onboarding_v1';
  static const authUser = 'shop_auth_v1';
  static const authToken = 'shop_token_v1';
  static const cart = 'shop_cart_v1';
}

class LocalStorage {
  final SharedPreferences prefs;
  LocalStorage(this.prefs);

  bool getSeenOnboarding() => prefs.getBool(LocalStorageKeys.seenOnboarding) ?? false;
  Future<void> setSeenOnboarding(bool v) => prefs.setBool(LocalStorageKeys.seenOnboarding, v);

  Map<String, dynamic>? getAuthUser() {
    final raw = prefs.getString(LocalStorageKeys.authUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> setAuthUser(Map<String, dynamic>? user) async {
    if (user == null) {
      await prefs.remove(LocalStorageKeys.authUser);
      return;
    }
    await prefs.setString(LocalStorageKeys.authUser, jsonEncode(user));
  }

  String? getToken() => prefs.getString(LocalStorageKeys.authToken);

  Future<void> setToken(String? token) async {
    if (token == null) {
      await prefs.remove(LocalStorageKeys.authToken);
      return;
    }
    await prefs.setString(LocalStorageKeys.authToken, token);
  }

  List<Map<String, dynamic>> getCart() {
    final raw = prefs.getString(LocalStorageKeys.cart);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> setCart(List<Map<String, dynamic>> items) async {
    await prefs.setString(LocalStorageKeys.cart, jsonEncode(items));
  }
}
