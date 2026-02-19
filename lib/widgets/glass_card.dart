import 'package:flutter/material.dart';
import '../core/constants/constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: border ??
            Border.all(
              color: AppColors.surfaceLight.withOpacity(0.5),
              width: 1,
            ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}