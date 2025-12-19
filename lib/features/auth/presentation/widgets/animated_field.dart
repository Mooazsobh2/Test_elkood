import 'package:flutter/material.dart';

class AnimatedField extends StatefulWidget {
  final Widget child;
  const AnimatedField({super.key, required this.child});

  @override
  State<AnimatedField> createState() => _AnimatedFieldState();
}

class _AnimatedFieldState extends State<AnimatedField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          boxShadow: _focused
              ? [
                  BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 8)),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
