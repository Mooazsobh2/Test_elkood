import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../core/ui/animated_page.dart';
import '../../../core/ui/brand.dart';
import '../../../app/routes/app_routes.dart';
import '../../onboarding/controller/onboarding_controller.dart';
import '../../auth/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 950), () {
      if (!mounted) return;
      final onboarding = Get.find<OnboardingController>();
      final auth = Get.find<AuthController>();

      if (!onboarding.seenOnboarding.value) {
        Get.offAllNamed(Routes.onboarding);
        return;
      }
      if (!auth.isLoggedIn) {
        Get.offAllNamed(Routes.login);
        return;
      }
      Get.offAllNamed(Routes.shell);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeSlide(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Hero(tag: 'brand', child: BrandMark(size: 52)),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('app.tagline'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('app.title'.tr, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text('splash.subtitle'.tr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                          const SizedBox(width: 12),
                          Text('splash.loading'.tr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
