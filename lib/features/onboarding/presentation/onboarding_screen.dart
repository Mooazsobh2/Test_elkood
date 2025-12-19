import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../core/ui/animated_page.dart';
import '../../../app/routes/app_routes.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int idx = 0;

  late final List<_Slide> slides = [
    _Slide('onboarding.slide1.title'.tr, 'onboarding.slide1.desc'.tr, 'onboarding.slide1.badge'.tr),
    _Slide('onboarding.slide2.title'.tr, 'onboarding.slide2.desc'.tr, 'onboarding.slide2.badge'.tr),
    _Slide('onboarding.slide3.title'.tr, 'onboarding.slide3.desc'.tr, 'onboarding.slide3.badge'.tr),
  ];

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final c = Get.find<OnboardingController>();
    await c.complete();
    Get.offAllNamed(Routes.login);
    showGlassSnack(Get.context!, 'onboarding.start'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeSlide(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text('onboarding.title'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          const Spacer(),
                          TextButton(onPressed: _finish, child: Text('onboarding.skip'.tr, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.w700))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 320,
                        child: PageView.builder(
                          controller: _page,
                          onPageChanged: (v) => setState(() => idx = v),
                          itemCount: slides.length,
                          itemBuilder: (context, i) {
                            final s = slides[i];
                            return Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _Pill(text: s.badge),
                                  const SizedBox(height: 12),
                                  Text(s.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 8),
                                  Text(s.desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.4)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: idx == 0 ? null : () => _page.previousPage(duration: const Duration(milliseconds: 220), curve: Curves.easeOutCubic),
                              style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                              child: Text('common.prev'.tr),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GradientButton(
                              onPressed: () async {
                                if (idx < slides.length - 1) {
                                  _page.nextPage(duration: const Duration(milliseconds: 220), curve: Curves.easeOutCubic);
                                } else {
                                  await _finish();
                                }
                              },
                              child: Text(idx < slides.length - 1 ? 'common.next'.tr : 'onboarding.start'.tr),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          slides.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: i == idx ? 34 : 16,
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(i == idx ? 0.8 : 0.25), borderRadius: BorderRadius.circular(999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary])),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

class _Slide {
  final String title;
  final String desc;
  final String badge;
  const _Slide(this.title, this.desc, this.badge);
}
