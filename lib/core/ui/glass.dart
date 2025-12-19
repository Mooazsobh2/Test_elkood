import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 32, offset: Offset(0, 14))],
          ),
          child: child,
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool loading;

  const GradientButton({super.key, required this.onPressed, required this.child, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.6 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: loading ? null : onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryBright, AppColors.primaryDeep]),
            boxShadow: const [BoxShadow(color: Color(0x5501796F), blurRadius: 26, offset: Offset(0, 12))],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: loading
                  ? const SizedBox(key: ValueKey('loading'), height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : DefaultTextStyle.merge(
                      key: const ValueKey('child'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

void showGlassSnack(BuildContext context, String title, {String? desc}) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                if (desc != null) Text(desc, style: const TextStyle(color: Color(0xE6FFFFFF), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
