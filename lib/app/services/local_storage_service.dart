import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalKeys {
  static const seenOnboarding = 'shop_seen_onboarding_v1';
  static const authUser = 'shop_auth_v1';
  static const authToken = 'shop_token_v1';
  static const cart = 'shop_cart_v1';
  static const themeMode = 'shop_theme_v1';
  static const locale = 'shop_locale_v1';
}

class LocalStorageService {
  final SharedPreferences prefs;
  LocalStorageService(this.prefs);

  bool get seenOnboarding => prefs.getBool(LocalKeys.seenOnboarding) ?? false;
  Future<void> setSeenOnboarding(bool v) => prefs.setBool(LocalKeys.seenOnboarding, v);

  Map<String, dynamic>? get user {
    final raw = prefs.getString(LocalKeys.authUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> setUser(Map<String, dynamic>? u) async {
    if (u == null) {
      await prefs.remove(LocalKeys.authUser);
      return;
    }
    await prefs.setString(LocalKeys.authUser, jsonEncode(u));
  }

  String? get token => prefs.getString(LocalKeys.authToken);

  Future<void> setToken(String? t) async {
    if (t == null) {
      await prefs.remove(LocalKeys.authToken);
      return;
    }
    await prefs.setString(LocalKeys.authToken, t);
  }

  List<Map<String, dynamic>> get cart {
    final raw = prefs.getString(LocalKeys.cart);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> setCart(List<Map<String, dynamic>> items) async {
    await prefs.setString(LocalKeys.cart, jsonEncode(items));
  }

  ThemeMode get themeMode {
    final raw = prefs.getString(LocalKeys.themeMode);
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) => prefs.setString(LocalKeys.themeMode, mode.name);

  Locale? get locale {
    final lang = prefs.getString(LocalKeys.locale);
    if (lang == null) return null;
    final parts = lang.split('_');
    if (parts.isEmpty) return null;
    if (parts.length == 1) return Locale(parts.first);
    return Locale(parts[0], parts[1]);
  }

  Future<void> setLocale(Locale l) {
    final country = l.countryCode;
    final suffix = country == null || country.isEmpty ? '' : '_$country';
    return prefs.setString(LocalKeys.locale, '${l.languageCode}$suffix');
  }
}
