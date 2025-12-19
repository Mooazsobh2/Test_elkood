import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  final double size;
  final bool withGlow;
  const BrandMark({super.key, this.size = 46, this.withGlow = true});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: const [AppColors.primary, AppColors.primaryBright],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        if (withGlow)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.28), blurRadius: size * 0.7, spreadRadius: size * 0.12),
              ],
            ),
          ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
          ),
          child: Icon(Icons.shopping_bag_rounded, color: Colors.white, size: size * 0.5),
        ),
      ],
    );
  }
}
