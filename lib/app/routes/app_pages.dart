import 'package:get/get.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/products/presentation/product_details_screen.dart';

import 'app_routes.dart';
import '../services/bindings.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: AppBindings(),
    ),
    GetPage(name: Routes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.register, page: () => const RegisterScreen()),
    GetPage(name: Routes.shell, page: () => const AppShell()),
    GetPage(
      name: Routes.details,
      page: () => const ProductDetailsScreen(),
    ),
  ];
}
