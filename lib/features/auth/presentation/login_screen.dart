import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../core/ui/animated_page.dart';
import '../../../app/routes/app_routes.dart';
import '../controller/auth_controller.dart';
import 'widgets/animated_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController(text: 'mor_2314');
  final pass = TextEditingController(text: '83r5^_');
  bool touched = false;

  String? _userErr(String v) {
    if (v.trim().isEmpty) return 'auth.usernameRequired'.tr;
    if (v.trim().length < 3) return 'auth.usernameShort'.tr;
    return null;
  }

  String? _passErr(String v) {
    if (v.isEmpty) return 'auth.passwordRequired'.tr;
    if (v.length < 3) return 'auth.passwordShort'.tr;
    return null;
  }

  @override
  void dispose() {
    username.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeSlide(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: GlassCard(
                child: Obx(() {
                  final uErr = touched ? _userErr(username.text) : null;
                  final pErr = touched ? _passErr(pass.text) : null;
                  final can = _userErr(username.text) == null && _passErr(pass.text) == null;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('auth.login'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AnimatedField(
                        child: TextField(
                          controller: username,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(labelText: 'auth.username'.tr, hintText: 'mor_2314', errorText: uErr, prefixIcon: const Icon(Icons.person_outline)),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedField(
                        child: TextField(
                          controller: pass,
                          obscureText: true,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(labelText: 'auth.password'.tr, hintText: '••••••', errorText: pErr, prefixIcon: const Icon(Icons.lock_outline)),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        loading: auth.loading.value,
                        onPressed: auth.loading.value
                            ? null
                            : () async {
                                setState(() => touched = true);
                                if (!can) return;
                                try {
                                  await auth.login(username: username.text.trim(), password: pass.text);
                                  Get.offAllNamed(Routes.shell);
                                  showGlassSnack(context, 'auth.loginSuccess'.tr);
                                } catch (e) {
                                  showGlassSnack(context, 'auth.loginFail'.tr, desc: e.toString());
                                }
                              },
                        child: Text('auth.loginCta'.tr),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('auth.noAccount'.tr, style: Theme.of(context).textTheme.bodySmall),
                          TextButton(onPressed: () => Get.toNamed(Routes.register), child: Text('auth.registerCta'.tr, style: const TextStyle(fontWeight: FontWeight.w800))),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
