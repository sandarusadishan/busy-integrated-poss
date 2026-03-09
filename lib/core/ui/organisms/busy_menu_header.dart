import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import 'menu_config.dart';
import 'open_company_dialog.dart';

class BusyMenuHeader extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  static final FocusNode companyFocusNode = FocusNode();

  const BusyMenuHeader({super.key});

  @override
  ConsumerState<BusyMenuHeader> createState() => _BusyMenuHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(26);
}

class _BusyMenuHeaderState extends ConsumerState<BusyMenuHeader> {
  List<Widget> _buildMenuChildren(
    BuildContext context,
    List<MenuNode> nodes, {
    bool isRoot = false,
    int depth = 0,
  }) {
    return nodes
        .map((node) =>
            _buildMenuItem(context, node, isRoot: isRoot, depth: depth))
        .toList();
  }

  Widget _buildMenuItem(
    BuildContext context,
    MenuNode node, {
    bool isRoot = false,
    int depth = 0,
  }) {
    final itemStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFF9E9E9E); // Grey text for disabled menus
        }
        if (states.contains(WidgetState.hovered) && !isRoot) {
          return Colors.white;
        }
        return Colors.black;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.hovered) && !isRoot) {
          return const Color(0xFF3399FF); // Classic selection blue
        }
        if (states.contains(WidgetState.hovered) && isRoot) {
          return const Color(0xFFE5E5E5); // Classic root hover
        }
        return Colors.transparent;
      }),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight
              .w600, // Makes text sharp and slightly bold like classic UI
          fontFamily: 'Tahoma',
        ),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.only(
          left: isRoot ? 8 : (16 + (depth * 20.0)),
          right: 16,
        ),
      ),
      minimumSize: WidgetStateProperty.all(
        isRoot ? const Size(0, 26) : const Size(220, 28),
      ),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );

    final authState = ref.watch(authProvider);
    final bool isDisabled =
        isRoot && node.title != 'Company' && !authState.isLoggedIn;

    final Widget? leadingIcon = !isRoot
        ? (node.children.isNotEmpty
            ? const Icon(
                Icons.play_arrow,
                color: Color(0xFF008000), // Dark green
                size: 14,
              )
            : const Icon(
                Icons.circle,
                color: Color(0xFFAA0000), // Dark red dot for leaves
                size: 5,
              ))
        : null;

    if (isDisabled) {
      return MenuItemButton(
        style: itemStyle,
        onPressed: null,
        child: Text(node.title),
      );
    }

    if (node.children.isEmpty) {
      return MenuItemButton(
        style: itemStyle,
        leadingIcon: leadingIcon,
        onPressed: () {
          if (node.title == 'Open Company') {
            if (authState.isLoggedIn) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(content: Text('A company is already open!')),
              );
              return;
            }
            showDialog(
              context: this.context,
              barrierDismissible: false,
              builder: (_) => const OpenCompanyDialog(),
            ).then((_) {
              if (ref.read(authProvider).isLoggedIn) {
                // Return focus to menu after dialog closes (with delay to prevent layout crash)
                Future.delayed(const Duration(milliseconds: 100), () {
                  BusyMenuHeader.companyFocusNode.requestFocus();
                });
              }
            });
          } else if (node.title == 'Close Company') {
            ref.read(authProvider.notifier).logout();
            GoRouter.of(this.context).go('/');
          } else if (node.route != null) {
            GoRouter.of(this.context).push(node.route!);
          } else {
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(
                content: Text('Navigating to ${node.title}'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        child: Text(node.title),
      );
    }

    if (isRoot) {
      final FocusNode? fNode =
          (node.title == 'Company') ? BusyMenuHeader.companyFocusNode : null;

      return SubmenuButton(
        focusNode: fNode,
        style: itemStyle,
        leadingIcon: leadingIcon,
        menuChildren:
            _buildMenuChildren(context, node.children, isRoot: false, depth: 0),
        child: Text(node.title),
      );
    }

    return _TreeMenuItem(
      node: node,
      itemStyle: itemStyle,
      depth: depth,
      buildChild: (childContext, childNode, childDepth) => _buildMenuItem(
          childContext, childNode,
          isRoot: false, depth: childDepth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFA0A0A0), width: 1.0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          menuTheme: MenuThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(3),
              shadowColor: WidgetStateProperty.all(Colors.black),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 2),
              ),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF808080)),
                ),
              ),
            ),
          ),
        ),
        child: MenuBarTheme(
          data: MenuBarThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              elevation: WidgetStateProperty.all(0),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: Text(
                  '>>',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: MenuBar(
                  children: _buildMenuChildren(context, appMenus, isRoot: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TreeMenuItem extends StatefulWidget {
  final MenuNode node;
  final ButtonStyle itemStyle;
  final Widget Function(BuildContext, MenuNode, int) buildChild;
  final int depth;

  const _TreeMenuItem({
    required this.node,
    required this.itemStyle,
    required this.buildChild,
    required this.depth,
  });

  @override
  State<_TreeMenuItem> createState() => _TreeMenuItemState();
}

class _TreeMenuItemState extends State<_TreeMenuItem> {
  bool _isExpanded = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Define focus node to capture key events before the MenuItemButton handles them natively
    _focusNode = FocusNode(debugLabel: widget.node.title);
    _focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight && !_isExpanded) {
          setState(() => _isExpanded = true);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
            _isExpanded) {
          setState(() => _isExpanded = false);
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuItemButton(
          focusNode: _focusNode,
          style: widget.itemStyle,
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          closeOnActivate: false, // Don't close the dropdown Menu
          leadingIcon: Icon(
            _isExpanded ? Icons.arrow_drop_down : Icons.play_arrow,
            color: const Color(0xFF008000), // Dark green
            size: 14,
          ),
          child: Text(widget.node.title),
        ),
        if (_isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: widget.node.children.map((childNode) {
              return widget.buildChild(context, childNode, widget.depth + 1);
            }).toList(),
          ),
      ],
    );
  }
}
