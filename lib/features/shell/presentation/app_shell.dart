import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../core/ui/animated_page.dart';
import '../../../core/ui/brand.dart';
import '../../../app/services/theme_controller.dart';
import '../../cart/controller/cart_controller.dart';
import '../../products/presentation/products_screen.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int idx = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final theme = Get.find<ThemeController>();

    final isWide = MediaQuery.of(context).size.width >= 920;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isWide
          ? null
          : AppBar(
              title: Text('app.title'.tr),
              leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
              actions: [
                IconButton(
                  tooltip: theme.isDark ? 'nav.drawer.light'.tr : 'nav.drawer.dark'.tr,
                  onPressed: theme.toggleTheme,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, key: ValueKey(theme.isDark)),
                  ),
                ),
                IconButton(
                  tooltip: 'nav.drawer.language'.tr,
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.translate),
                ),
              ],
            ),
      drawer: LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth >= 920;
        if (wide) return const SizedBox.shrink();
        return Drawer(
          child: SafeArea(
            child: _DrawerContent(
              idx: idx,
              cartCount: cart.count,
              onTapNav: (i) {
                setState(() => idx = i);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      }),
      body: SafeArea(
        child: FadeSlide(
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 920;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: wide
                    ? Row(
                        children: [
                          SizedBox(
                            width: 320,
                            child: Obx(() => _SideNav(idx: idx, cartCount: cart.count, onTap: (i) => setState(() => idx = i))),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: _Body(idx: idx)),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(child: _Body(idx: idx)),
                          const SizedBox(height: 12),
                          Obx(() => _BottomNav(idx: idx, cartCount: cart.count, onTap: (i) => setState(() => idx = i))),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final int idx;
  const _Body({required this.idx});

  @override
  Widget build(BuildContext context) {
    switch (idx) {
      case 0:
        return const ProductsScreen();
      case 1:
        return const CartScreen();
      default:
        return const ProfileScreen();
    }
  }
}

class _SideNav extends StatelessWidget {
  final int idx;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _SideNav({required this.idx, required this.cartCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Hero(tag: 'brand', child: BrandMark(size: 44, withGlow: false)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('app.title'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    Text('app.tagline'.tr, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            _NavItem(active: idx == 0, label: 'nav.products'.tr, icon: Icons.search, onTap: () => onTap(0)),
            const SizedBox(height: 8),
            _NavItem(active: idx == 1, label: 'nav.cart'.tr, icon: Icons.shopping_cart_outlined, badge: cartCount.toString(), onTap: () => onTap(1)),
            const SizedBox(height: 8),
            _NavItem(active: idx == 2, label: 'nav.profile'.tr, icon: Icons.person_outline, onTap: () => onTap(2)),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  tooltip: themeController.isDark ? 'nav.drawer.light'.tr : 'nav.drawer.dark'.tr,
                  onPressed: themeController.toggleTheme,
                  icon: Icon(themeController.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: Text('nav.drawer.ar'.tr),
                  selected: themeController.locale.value.languageCode == 'ar',
                  onSelected: (_) => themeController.setLocale(const Locale('ar', 'EG')),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: Text('nav.drawer.en'.tr),
                  selected: themeController.locale.value.languageCode == 'en',
                  onSelected: (_) => themeController.setLocale(const Locale('en', 'US')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
                color: theme.colorScheme.surface.withOpacity(0.7),
              ),
              child: Text(
                'app.tagline'.tr,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final bool active;
  final String label;
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;

  const _NavItem({required this.active, required this.label, required this.icon, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = active ? theme.colorScheme.primary.withOpacity(0.08) : theme.colorScheme.surface.withOpacity(0.6);
    final border = theme.dividerColor.withOpacity(active ? 0.25 : 0.12);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: border), color: bg),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.85)),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
            if (badge != null) Text(badge!, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int idx;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.idx, required this.cartCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: Row(
        children: [
          Expanded(child: _BItem(active: idx == 0, icon: Icons.search, label: 'nav.products'.tr, onTap: () => onTap(0))),
          Expanded(child: _BItem(active: idx == 1, icon: Icons.shopping_cart_outlined, label: '${'nav.cart'.tr} ($cartCount)', onTap: () => onTap(1))),
          Expanded(child: _BItem(active: idx == 2, icon: Icons.person_outline, label: 'nav.profile'.tr, onTap: () => onTap(2))),
        ],
      ),
    );
  }
}

class _BItem extends StatelessWidget {
  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BItem({required this.active, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: active ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.onSurface),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _DrawerContent extends StatelessWidget {
  final int idx;
  final int cartCount;
  final ValueChanged<int> onTapNav;

  const _DrawerContent({required this.idx, required this.cartCount, required this.onTapNav});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const BrandMark(size: 34, withGlow: false),
            title: Text('app.title'.tr, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text('app.tagline'.tr),
            trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
          ),
          const Divider(),
          _DrawerNavTile(label: 'nav.products'.tr, icon: Icons.search, selected: idx == 0, onTap: () => onTapNav(0)),
          _DrawerNavTile(label: 'nav.cart'.tr, icon: Icons.shopping_cart_outlined, selected: idx == 1, trailing: Text(cartCount.toString()), onTap: () => onTapNav(1)),
          _DrawerNavTile(label: 'nav.profile'.tr, icon: Icons.person_outline, selected: idx == 2, onTap: () => onTapNav(2)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Text('nav.drawer.theme'.tr, style: Theme.of(context).textTheme.labelMedium),
          ),
          SwitchListTile(
            title: Text(themeController.isDark ? 'nav.drawer.dark'.tr : 'nav.drawer.light'.tr),
            value: themeController.isDark,
            onChanged: (_) => themeController.toggleTheme(),
            secondary: Icon(themeController.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Text('nav.drawer.language'.tr, style: Theme.of(context).textTheme.labelMedium),
          ),
          Row(
            children: [
              const SizedBox(width: 12),
              ChoiceChip(
                label: Text('nav.drawer.ar'.tr),
                selected: themeController.locale.value.languageCode == 'ar',
                onSelected: (_) => themeController.setLocale(const Locale('ar', 'EG')),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text('nav.drawer.en'.tr),
                selected: themeController.locale.value.languageCode == 'en',
                onSelected: (_) => themeController.setLocale(const Locale('en', 'US')),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _DrawerNavTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DrawerNavTile({required this.label, required this.icon, required this.selected, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      leading: Icon(icon),
      trailing: trailing,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      onTap: onTap,
    );
  }
}
