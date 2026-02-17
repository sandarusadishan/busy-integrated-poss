import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

/// A dynamic table widget based on the React 'CommonTable' logic.
///
/// Features:
/// - Accepts [data] as List<Map<String, dynamic>>
/// - Resolves nested paths (e.g., 'customer.profile.name')
/// - Supports custom cell renderers via [cellRenderers]
/// - Horizontal scrolling and fixed column widths
/// - Supports [isDense] for tighter rows (Legacy style)
/// - Supports [showGrid] for visible grid lines
class SmartTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<SmartTableColumn> columns;
  final Map<String, Widget Function(dynamic value, Map<String, dynamic> row)>?
      cellRenderers;
  final void Function(Map<String, dynamic> row)? onRowTap;
  final bool isDense;
  final bool showGrid;

  const SmartTable({
    super.key,
    required this.data,
    required this.columns,
    this.cellRenderers,
    this.onRowTap,
    this.isDense = false,
    this.showGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    // Legacy styling constants
    final double rowHeight = isDense ? 28.0 : 48.0;
    final TextStyle headerStyle = isDense
        ? const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)
        : AppTheme.labelLarge.copyWith(fontWeight: FontWeight.bold);
    final TextStyle cellStyle = isDense
        ? const TextStyle(fontSize: 12, color: Colors.black87)
        : AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary);
    final Color headerColor =
        isDense ? const Color(0xFFE0E0E0) : AppTheme.background;
    final Color rowColor = isDense ? Colors.white : AppTheme.surface;

    return Card(
      elevation: isDense ? 0 : 0, // No elevation for legacy look
      color: rowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isDense ? 0 : 12),
        side: isDense
            ? const BorderSide(color: Colors.grey)
            : const BorderSide(color: AppTheme.border, width: 0.5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: showGrid ? Colors.grey[300] : null),
                  child: DataTable(
                    headingRowHeight: rowHeight + 4,
                    dataRowMinHeight: rowHeight,
                    dataRowMaxHeight: rowHeight,
                    headingRowColor: WidgetStateProperty.all(headerColor),
                    dataRowColor: WidgetStateProperty.all(rowColor),
                    columnSpacing: isDense ? 10 : 20,
                    horizontalMargin: isDense ? 8 : 20,
                    showCheckboxColumn: false,
                    border: showGrid
                        ? TableBorder.all(color: Colors.grey[400]!, width: 0.5)
                        : null,
                    columns: columns.map((col) {
                      return DataColumn(
                        label: SizedBox(
                          width: col.width,
                          child: Text(
                            col.title,
                            style: headerStyle,
                          ),
                        ),
                      );
                    }).toList(),
                    rows: data.map((row) {
                      return DataRow(
                        onSelectChanged:
                            onRowTap != null ? (_) => onRowTap!(row) : null,
                        cells: columns.map((col) {
                          final cellValue = _resolvePath(row, col.key);
                          final renderer = cellRenderers?[col.key];

                          final cellWidget = renderer != null
                              ? renderer(cellValue, row)
                              : Text(
                                  cellValue?.toString() ??
                                      '', // Empty string for null in legacy
                                  style: cellStyle,
                                );

                          return DataCell(
                            col.width != null
                                ? SizedBox(width: col.width, child: cellWidget)
                                : cellWidget,
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Helper function to resolve nested paths
  dynamic _resolvePath(Map<String, dynamic> map, String path) {
    if (!path.contains('.')) {
      return map[path];
    }

    final keys = path.split('.');
    dynamic current = map;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }
}

class SmartTableColumn {
  final String title;
  final String key;
  final double? width;

  const SmartTableColumn({
    required this.title,
    required this.key,
    this.width,
  });
}
