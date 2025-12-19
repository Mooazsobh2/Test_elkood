import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_storage_service.dart';

class ThemeController extends GetxController {
  final LocalStorageService storage;
  ThemeController(this.storage);

  final themeMode = ThemeMode.dark.obs;
  final locale = const Locale('ar', 'EG').obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = storage.themeMode;
    locale.value = storage.locale ?? const Locale('ar', 'EG');
  }

  Future<void> toggleTheme() => setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await storage.setThemeMode(mode);
    Get.changeThemeMode(mode);
  }

  Future<void> setLocale(Locale l) async {
    locale.value = l;
    await storage.setLocale(l);
    Get.updateLocale(l);
  }

  bool get isDark => themeMode.value == ThemeMode.dark;
}
