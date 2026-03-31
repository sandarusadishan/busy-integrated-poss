import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BusyKeyboardHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback onEscape;
  final VoidCallback? onF2;
  final FocusNode? customFocusNode;

  const BusyKeyboardHandler({
    super.key,
    required this.child,
    required this.onEscape,
    this.onF2,
    this.customFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: customFocusNode,
      autofocus: false,
      skipTraversal: true,
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            onEscape();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.f2) {
            if (onF2 != null) onF2!();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            FocusManager.instance.primaryFocus?.nextFocus();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            FocusManager.instance.primaryFocus?.previousFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
