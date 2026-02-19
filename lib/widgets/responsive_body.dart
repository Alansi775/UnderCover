import 'package:flutter/material.dart';
import '../core/constants/constants.dart';

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveBody({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxContentWidth = width * 0.9 > 1000 ? 1000.0 : width * 0.9;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDimens.paddingLG),
          child: child,
        ),
      ),
    );
  }
}
