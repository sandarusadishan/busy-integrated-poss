import 'dart:math' as math;
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

class TreeLinePainter extends CustomPainter {
  final int depth;
  final bool isLast;
  final List<bool> parentIsLastList;

  TreeLinePainter(this.depth, this.isLast, this.parentIsLastList);

  @override
  void paint(Canvas canvas, Size size) {
    if (depth == 0) return;
    final paint = Paint()
      ..color = const Color(0xFF808080)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    void drawDottedLine(Offset p1, Offset p2) {
      final dx = p2.dx - p1.dx;
      final dy = p2.dy - p1.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      const dash = 1.0;
      const space = 2.0;
      double drawn = 0;
      while (drawn < dist) {
        double currentDash = (drawn + dash > dist) ? dist - drawn : dash;
        canvas.drawLine(
          Offset(p1.dx + dx * drawn / dist, p1.dy + dy * drawn / dist),
          Offset(p1.dx + dx * (drawn + currentDash) / dist,
              p1.dy + dy * (drawn + currentDash) / dist),
          paint,
        );
        drawn += dash + space;
      }
    }

    double levelWidth = 16.0;

    for (int i = 0; i < depth - 1; i++) {
      if (!parentIsLastList[i]) {
        double x = i * levelWidth + 8.0;
        drawDottedLine(Offset(x, 0), Offset(x, size.height));
      }
    }

    double currentX = (depth - 1) * levelWidth + 8.0;
    double currentY = size.height / 2;
    drawDottedLine(Offset(currentX, 0), Offset(currentX, currentY));
    drawDottedLine(
        Offset(currentX, currentY), Offset(currentX + 8.0, currentY));
    if (!isLast) {
      drawDottedLine(Offset(currentX, currentY), Offset(currentX, size.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BusyMenuHeaderState extends ConsumerState<BusyMenuHeader> {
  final Set<String> _expandedNodes = {};

  List<Widget> _buildFlattenedMenuChildren(
    BuildContext context,
    List<MenuNode> nodes, {
    int depth = 0,
    List<bool> parentIsLastList = const [],
    String pathPrefix = '',
  }) {
    List<Widget> items = [];
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final isLast = i == nodes.length - 1;
      final nodePath = '$pathPrefix/${node.title}';
      final isExpanded = _expandedNodes.contains(nodePath);

      items.add(_buildMenuItem(
        context,
        node,
        isRoot: false,
        depth: depth,
        isLast: isLast,
        parentIsLastList: parentIsLastList,
        nodePath: nodePath,
        isExpanded: isExpanded,
      ));

      if (isExpanded && node.children.isNotEmpty) {
        items.addAll(_buildFlattenedMenuChildren(
          context,
          node.children,
          depth: depth + 1,
          parentIsLastList: [...parentIsLastList, isLast],
          pathPrefix: nodePath,
        ));
      }
    }
    return items;
  }

  Widget _buildMenuItem(
    BuildContext context,
    MenuNode node, {
    bool isRoot = false,
    int depth = 0,
    bool isLast = true,
    List<bool> parentIsLastList = const [],
    String nodePath = '',
    bool isExpanded = false,
  }) {
    final itemStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFF9E9E9E);
        }
        if (states.contains(WidgetState.hovered) && !isRoot) {
          return Colors.white;
        }
        return Colors.black;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return Colors.transparent;
        if (states.contains(WidgetState.hovered) && !isRoot) {
          return const Color(0xFF3399FF);
        }
        if (states.contains(WidgetState.hovered) && isRoot) {
          return const Color(0xFFE5E5E5);
        }
        return Colors.transparent;
      }),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Tahoma',
        ),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.only(left: isRoot ? 8 : 4, right: 16),
      ),
      minimumSize: WidgetStateProperty.all(
        isRoot ? const Size(0, 26) : const Size(220, 28),
      ),
      maximumSize: WidgetStateProperty.all(
        isRoot ? const Size(double.infinity, 26) : const Size(280, 28),
      ),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );

    final authState = ref.watch(authProvider);
    final bool isDisabled =
        isRoot && node.title != 'Company' && !authState.isLoggedIn;
    final bool isSeparator = node.title == 'o';
    final bool isSpacer = node.title == '---';

    if (isSpacer) {
      return const SizedBox(height: 12); // Invisible vertical gap
    }

    Widget buildIcon(bool isExpanded) {
      if (isRoot) return const SizedBox.shrink();
      if (isSeparator) {
        return const SizedBox(
          width: 14,
          child:
              Icon(Icons.radio_button_unchecked, size: 7, color: Colors.black),
        );
      }
      if (node.children.isEmpty) {
        return const SizedBox(
          width: 14,
          child: Icon(
            Icons.circle,
            color: Color(0xFFA00000), // Dark red like busy ERP
            size: 6,
          ),
        );
      }
      return SizedBox(
        width: 14,
        child: Icon(
          isExpanded ? Icons.arrow_drop_down : Icons.play_arrow,
          color: const Color(0xFF008000), // Green for folders
          size: isExpanded ? 16 : 12,
        ),
      );
    }

    Widget buildTreeRow(bool isExpanded) {
      if (isRoot) return Text(node.title);

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (depth > 0)
            CustomPaint(
              size: Size(16.0 * depth, 28),
              painter: TreeLinePainter(depth, isLast, parentIsLastList),
            ),
          buildIcon(isExpanded),
          const SizedBox(width: 4),
          if (!isSeparator) Text(node.title),
        ],
      );
    }

    if (isDisabled) {
      return MenuItemButton(
        style: itemStyle,
        onPressed: null,
        child: buildTreeRow(false),
      );
    }

    if (node.children.isEmpty) {
      return MenuItemButton(
        style: itemStyle,
        onPressed: () {
          if (isSeparator) return;
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
                  duration: const Duration(seconds: 1)),
            );
          }
        },
        child: buildTreeRow(false),
      );
    }

    if (isRoot) {
      final FocusNode? fNode =
          (node.title == 'Company') ? BusyMenuHeader.companyFocusNode : null;
      return SubmenuButton(
        focusNode: fNode,
        style: itemStyle,
        menuChildren: (() {
          List<Widget> children = _buildFlattenedMenuChildren(
            context,
            node.children,
            depth: 0,
            pathPrefix: node.title,
          );
          if (node.title == 'Administration' || children.length > 5) {
             children.add(Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                border: Border(top: BorderSide(color: Color(0xFF808080))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFFF0F0F0),
                         foregroundColor: Colors.black,
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                         minimumSize: const Size(0, 22),
                         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                         side: const BorderSide(color: Color(0xFF808080)),
                         elevation: 0,
                         textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                     onPressed: () {},
                     child: const Text('Add To Favourites'),
                   ),
                   OutlinedButton(
                     style: OutlinedButton.styleFrom(
                         foregroundColor: const Color(0xFF808080),
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                         minimumSize: const Size(0, 22),
                         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                         side: const BorderSide(color: Color(0xFFC0C0C0)),
                         disabledForegroundColor: const Color(0xFFA0A0A0),
                         textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                     onPressed: null,
                     child: const Text('Create Shortcut'),
                   ),
                ],
              ),
            ));
          }
          return children;
        })(),
        child: buildTreeRow(false),
      );
    }

    // This is a flattened tree menu item (parent with children that toggles expansion rather than navigating)
    return MenuItemButton(
      closeOnActivate: false,
      style: itemStyle,
      onPressed: () {
        setState(() {
          if (_expandedNodes.contains(nodePath)) {
            _expandedNodes.remove(nodePath);
          } else {
            _expandedNodes.add(nodePath);
          }
        });
      },
      child: buildTreeRow(isExpanded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Color(0xFFA0A0A0), width: 1.0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          menuTheme: MenuThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(3),
              shadowColor: WidgetStateProperty.all(Colors.black),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFF808080))),
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
              shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero)),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: Text('>>',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: MenuBar(
                    children: appMenus.map((n) => _buildMenuItem(context, n, isRoot: true)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
