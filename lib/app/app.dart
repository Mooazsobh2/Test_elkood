import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';
import '../core/l10n/app_translations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/bindings.dart';
import 'services/theme_controller.dart';

class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shoply',
        theme: light.copyWith(textTheme: GoogleFonts.tajawalTextTheme(light.textTheme)),
        darkTheme: dark.copyWith(textTheme: GoogleFonts.tajawalTextTheme(dark.textTheme)),
        themeMode: themeController.themeMode.value,
        translations: AppTranslations(),
        locale: themeController.locale.value,
        fallbackLocale: const Locale('en', 'US'),
        initialBinding: AppBindings(),
        initialRoute: Routes.splash,
        getPages: AppPages.pages,
        defaultTransition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 260),
      ),
    );
  }
}
