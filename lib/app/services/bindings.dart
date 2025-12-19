import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_service.dart';
import 'api_service.dart';
import 'theme_controller.dart';

import '../../features/onboarding/controller/onboarding_controller.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/cart/controller/cart_controller.dart';
import '../../features/products/controller/products_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() async {
    // Storage
    if (!Get.isRegistered<LocalStorageService>()) {
      final sp = await SharedPreferences.getInstance();
      final storage = LocalStorageService(sp);
      Get.put<LocalStorageService>(storage, permanent: true);
    }

    // Theme controller (depends on storage)
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(Get.find()), permanent: true);
    }

    // API
    if (!Get.isRegistered<ApiService>()) {
      final dio = ApiService.buildDio(Get.find());
      Get.put<ApiService>(ApiService(dio), permanent: true);
    }

    // Feature controllers
    if (!Get.isRegistered<OnboardingController>()) {
      Get.put(OnboardingController(Get.find()), permanent: true);
    }
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(Get.find(), Get.find()), permanent: true);
    }
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(Get.find()), permanent: true);
    }

    // Products is not permanent (can be recreated if needed)
    if (!Get.isRegistered<ProductsController>()) {
      Get.lazyPut(() => ProductsController(Get.find()));
    }
  }
}
