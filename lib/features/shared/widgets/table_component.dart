import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;

  /// If provided, must match headers length.
  /// Example: [120, 80, 150]
  final List<double>? columnWidths;

  /// Same height for header and body rows.
  final double rowHeight;

  final Color headerColor;
  final Color bodyColor;

  /// Optional: alternate row colors
  final bool zebra;
  final Color? zebraColor;

  final double cellPadding;
  final double borderRadius;
  final Color borderColor;

  final TextStyle? headerTextStyle;
  final TextStyle? cellTextStyle;

  const AppTable({
    super.key,
    required this.headers,
    required this.rows,
    this.columnWidths,
    this.rowHeight = 48,
    this.headerColor = const Color(0xFFF3F4F6),
    this.bodyColor = Colors.white,
    this.zebra = false,
    this.zebraColor,
    this.cellPadding = 12,
    this.borderRadius = 12,
    this.borderColor = const Color(0xFFE5E7EB),
    this.headerTextStyle,
    this.cellTextStyle,
  }) : assert(headers.length > 0, "Headers cannot be empty"),
       assert(
         columnWidths == null || columnWidths.length == headers.length,
         "columnWidths length must match headers length",
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hStyle = headerTextStyle ??
        theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);

    final cStyle = cellTextStyle ?? theme.textTheme.bodyMedium;

    final widths = _buildColumnWidths();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: bodyColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            columnWidths: widths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.symmetric(
              inside: BorderSide(color: borderColor),
            ),
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(color: headerColor),
                children: headers.map((h) {
                  return _cell(
                    text: h,
                    height: rowHeight,
                    padding: cellPadding,
                    style: hStyle,
                    align: TextAlign.start,
                  );
                }).toList(),
              ),

              // Body rows
              ...List.generate(rows.length, (rowIndex) {
                final bg = _rowColor(rowIndex);

                final fixedRow = List<String>.generate(
                  headers.length,
                  (i) => (i < rows[rowIndex].length) ? rows[rowIndex][i] : "",
                );

                return TableRow(
                  decoration: BoxDecoration(color: bg),
                  children: fixedRow.map((cell) {
                    return _cell(
                      text: cell,
                      height: rowHeight,
                      padding: cellPadding,
                      style: cStyle,
                      align: TextAlign.start,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> _buildColumnWidths() {
    if (columnWidths == null) return const {}; // auto widths
    return {
      for (int i = 0; i < columnWidths!.length; i++)
        i: FixedColumnWidth(columnWidths![i]),
    };
  }

  Color _rowColor(int rowIndex) {
    if (!zebra) return bodyColor;
    final alt = zebraColor ?? bodyColor.withOpacity(0.6);
    return rowIndex.isEven ? bodyColor : alt;
  }

  Widget _cell({
    required String text,
    required double height,
    required double padding,
    required TextStyle? style,
    required TextAlign align,
  }) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: style,
            textAlign: align,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

