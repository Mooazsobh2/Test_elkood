import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../app/routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      final t = auth.token.value ?? '';
      final maskedToken = t.isEmpty ? '—' : '${t.substring(0, t.length.clamp(0, 12))}…';
      final username = auth.username.value?.isNotEmpty == true ? auth.username.value! : 'Guest';
      final email = auth.email.value?.isNotEmpty == true ? auth.email.value! : 'unknown@email.com';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(username: username, email: email),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('profile.title'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoBadge(icon: Icons.person_outline, label: 'ID', value: (auth.userId.value ?? '—').toString()),
                      const SizedBox(width: 10),
                      _InfoBadge(icon: Icons.alternate_email, label: 'Email', value: email),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _DetailTile(
                    icon: Icons.shield_moon_outlined,
                    title: 'profile.token'.tr,
                    subtitle: maskedToken,
                    trailing: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await auth.logout();
                        Get.offAllNamed(Routes.login);
                        showGlassSnack(context, 'profile.loggedOut'.tr);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DetailTile(
                    icon: Icons.settings_outlined,
                    title: 'nav.drawer.theme'.tr,
                    subtitle: 'nav.drawer.language'.tr,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Header extends StatelessWidget {
  final String username;
  final String email;
  const _Header({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: theme.colorScheme.primary.withOpacity(0.25), blurRadius: 30, offset: const Offset(0, 14)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: Text(username.isNotEmpty ? username[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const Spacer(),
              const Icon(Icons.verified_rounded, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 12),
          Text(username, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(email, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,

          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoBadge({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.dividerColor.withOpacity(0.16)),
          color: theme.colorScheme.surface.withOpacity(0.7),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65))),
                  const SizedBox(height: 2),
                  Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  const _DetailTile({required this.icon, required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.14)),
        color: theme.colorScheme.surface.withOpacity(0.6),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65))),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
