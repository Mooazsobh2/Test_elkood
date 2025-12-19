import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../core/ui/animated_page.dart';
import '../../../app/routes/app_routes.dart';
import '../domain/entities/register_request.dart';
import '../controller/auth_controller.dart';
import 'widgets/animated_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  bool touched = false;

  String? _req(String v, String msg) => v.trim().isEmpty ? msg : null;

  String? _emailErr(String v) {
    if (v.trim().isEmpty) return 'auth.emailRequired'.tr;
    final ok = RegExp(r'^\\S+@\\S+\\.\\S+$').hasMatch(v.trim());
    return ok ? null : 'auth.emailInvalid'.tr;
  }

  @override
  void dispose() {
    for (final c in [email, username, password]) {
      c.dispose();
    }
    super.dispose();
  }

  RegisterRequest _buildReq() => RegisterRequest(
        email: email.text.trim(),
        username: username.text.trim(),
        password: password.text,
      );

  bool get _valid {
    return _emailErr(email.text) == null &&
        _req(username.text, 'auth.usernameRequired'.tr) == null &&
        _req(password.text, 'auth.passwordRequired'.tr) == null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    InputDecoration dec(
      String label, {
      String? err,
      IconData? icon,
      String? hint,
    }) =>
        InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: err,
          prefixIcon: icon == null ? null : Icon(icon),
        );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeSlide(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.offNamed(Routes.login),
                            icon: const Icon(Icons.chevron_right),
                          ),
                          Text(
                            'auth.register'.tr,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              gradient: LinearGradient(
                                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, c) {
                          final two = c.maxWidth >= 760;
                          return two
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _Left(
                                        dec: dec,
                                        touched: touched,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(child: _Right()),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _Left(
                                      dec: dec,
                                      touched: touched,
                                    ),
                                    const SizedBox(height: 12),
                                    const _Right(),
                                  ],
                                );
                        },
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => GradientButton(
                          loading: auth.loading.value,
                          onPressed: auth.loading.value
                              ? null
                              : () async {
                                  setState(() => touched = true);
                                  if (!_valid) return;
                                  try {
                                    await auth.registerAndLogin(_buildReq());
                                    Get.offAllNamed(Routes.shell);
                                    showGlassSnack(
                                      context,
                                      'auth.registerSuccess'.tr,
                                      desc: 'common.added'.tr,
                                    );
                                  } catch (e) {
                                    showGlassSnack(
                                      context,
                                      'auth.registerFail'.tr,
                                      desc: e.toString(),
                                    );
                                  }
                                },
                          child: Text('auth.create'.tr),
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

  Widget _Left({
    required InputDecoration Function(
      String, {
      String? err,
      IconData? icon,
      String? hint,
    })
        dec,
    required bool touched,
  }) {
    return Column(
      children: [
        AnimatedField(
          child: TextField(
            controller: email,
            textDirection: TextDirection.ltr,
            decoration: dec(
              'auth.email'.tr,
              err: touched ? _emailErr(email.text) : null,
              icon: Icons.email_outlined,
              hint: 'name@email.com',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedField(
          child: TextField(
            controller: username,
            textDirection: TextDirection.ltr,
            decoration: dec(
              'auth.username'.tr,
              err: touched ? _req(username.text, 'auth.usernameRequired'.tr) : null,
              icon: Icons.person_outline,
              hint: 'mor_2314',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedField(
          child: TextField(
            controller: password,
            obscureText: true,
            textDirection: TextDirection.ltr,
            decoration: dec(
              'auth.password'.tr,
              err: touched ? _req(password.text, 'auth.passwordRequired'.tr) : null,
              icon: Icons.lock_outline,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }
}

class _Right extends StatelessWidget {
  const _Right();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('app.tagline'.tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
      ],
    );
  }
}
