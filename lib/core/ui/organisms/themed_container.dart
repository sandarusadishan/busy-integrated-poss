import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

/// A wrapper with standard padding, shadows, and background colors that changes based on Dark/Light mode.
///
/// Features:
/// - Consistent padding (16.0)
/// - Adaptive background color (Card color)
/// - Subtle shadow for depth
/// - Rounded corners
class ThemedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;

  const ThemedContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
