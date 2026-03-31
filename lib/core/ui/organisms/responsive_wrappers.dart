import 'package:flutter/material.dart';

class ResponsiveScrollWrapper extends StatelessWidget {
  final Widget child;
  final double minWidth;

  const ResponsiveScrollWrapper({
    super.key,
    required this.child,
    this.minWidth = 800,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < minWidth) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                minHeight: constraints.maxHeight,
              ),
              child: child,
            ),
          );
        }
        return child;
      },
    );
  }
}

class ResponsiveFormRow extends StatelessWidget {
  final List<Widget> children;
  
  const ResponsiveFormRow({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 800) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((e) => Expanded(child: e)).toList(),
    );
  }
}
class ResponsiveFlexColumn {
  final int flex;
  final Widget child;
  const ResponsiveFlexColumn({this.flex = 1, required this.child});
}

class ResponsiveFlexRow extends StatelessWidget {
  final List<ResponsiveFlexColumn> columns;

  const ResponsiveFlexRow({super.key, required this.columns});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 900) {
      return SingleChildScrollView(
        child: Column(
          children: columns.map((col) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: col.child,
          )).toList(),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.map((col) => Expanded(flex: col.flex, child: col.child)).toList(),
    );
  }
}

class ResponsiveFormContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveFormContainer({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12.0 : 20.0),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(2, 2)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
