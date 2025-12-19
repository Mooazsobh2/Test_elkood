import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'app/services/local_storage_service.dart';
import 'app/services/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-register theme + storage so GetMaterialApp can read them immediately.
  final sp = await SharedPreferences.getInstance();
  final storage = LocalStorageService(sp);
  if (!Get.isRegistered<LocalStorageService>()) {
    Get.put<LocalStorageService>(storage, permanent: true);
  }
  if (!Get.isRegistered<ThemeController>()) {
    Get.put<ThemeController>(ThemeController(storage), permanent: true);
  }
  runApp(const ShoplyApp());
}
