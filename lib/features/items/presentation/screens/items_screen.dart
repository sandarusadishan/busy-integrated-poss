import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../providers/items_provider.dart';
import '../providers/view_mode_provider.dart';
import '../widgets/busy_app_bar.dart';
import '../widgets/busy_status_bar.dart';
import '../widgets/item_filter_bar.dart';
import '../widgets/item_grid_view.dart';
import '../widgets/item_table.dart';
import '../widgets/operations_panel.dart';

class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data Filtering Logic
    final allItems = ref.watch(itemsProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    final items = searchQuery.isEmpty
        ? allItems
        : allItems.where((item) {
            return item.name.toLowerCase().contains(searchQuery) ||
                item.alias.toLowerCase().contains(searchQuery) ||
                item.parentGroup.toLowerCase().contains(searchQuery);
          }).toList();

    // UI State
    final viewMode = ref.watch(viewModeProvider);
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f2): () =>
            _handleAddItem(context),
        const SingleActivator(LogicalKeyboardKey.f3): () =>
            _handleAddMaster(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BusyAppBar(),
          body: Row(
            children: [
              // 1. Main Content Area
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        // Top Filter Bar
                        const ItemFilterBar(),
                        // Content (Table or Grid)
                        Expanded(
                          child: viewMode == ViewMode.normal
                              ? ItemTable(
                                  items: items,
                                  onItemTap: (item) =>
                                      _showItemDetail(context, item))
                              : ItemGridView(
                                  items: items,
                                  isWideScreen: isWideScreen,
                                  onItemTap: (item) =>
                                      _showItemDetail(context, item),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 2. Right Operations Panel (Wide Screen only)
              if (isWideScreen)
                OperationsPanel(
                  isDark: isDark,
                  onAddItem: () => _handleAddItem(context),
                  onAddGroup: () => _handleAddMaster(context),
                ),
            ],
          ),
          bottomNavigationBar: BusyStatusBar(items: items, isDark: isDark),
        ),
      ),
    );
  }

  void _handleAddItem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("F2: Add Item Dialog Open")));
  }

  void _handleAddMaster(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("F3: Add Master Dialog Open")));
  }

  void _showItemDetail(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Text(
            "Current Stock: ${item.quantity} ${item.unit}\nGroup: ${item.parentGroup}"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }
}
