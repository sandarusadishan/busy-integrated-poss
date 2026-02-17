import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/ui/molecules/smart_table.dart';
import '../../../../core/ui/organisms/pos_header.dart'; // Import POSHeader
import '../../../../core/ui/organisms/shortcut_panel.dart'; // Import ShortcutPanel
import '../providers/items_provider.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isListView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ref.watch(itemsProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    final items = searchQuery.isEmpty
        ? allItems
        : allItems.where((item) {
            return item.name.toLowerCase().contains(searchQuery) ||
                item.alias.toLowerCase().contains(searchQuery) ||
                item.parentGroup.toLowerCase().contains(searchQuery);
          }).toList();

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
          backgroundColor: AppTheme.background,
          appBar: const POSHeader(),
          body: Column(
            children: [
              // Top Control Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: const Color(0xFFE0E0E0), // Legacy toolbar color
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.search,
                                  size: 16, color: Colors.grey),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search...',
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 12),
                                ),
                                style: const TextStyle(fontSize: 13),
                                onChanged: (value) {
                                  ref
                                      .read(searchQueryProvider.notifier)
                                      .setQuery(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildLegacyToolbarButton('Email - [M]'),
                    _buildLegacyToolbarButton('Print - [P]'),
                    _buildLegacyToolbarButton('Refresh - [R]'),
                    const SizedBox(width: 8),
                    // View Toggle
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          _isListView ? Icons.grid_view : Icons.list,
                          color: const Color(0xFF1565C0), // Blue
                          size: 20,
                        ),
                        tooltip: _isListView
                            ? 'Switch to Grid View'
                            : 'Switch to List View',
                        onPressed: () {
                          setState(() {
                            _isListView = !_isListView;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Colors.grey),

              // Main Content Area
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center Content (Table/Grid)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.white,
                        child: _isListView
                            ? _buildListView(items)
                            : _buildGridView(items),
                      ),
                    ),
                    // Right Sidebar (Shortcut Panel)
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey)),
                      ),
                      child: ShortcutPanel(
                        items: [
                          ShortcutItem(
                              keyLabel: 'F1', label: 'Help', onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'F2',
                              label: 'Add Item',
                              onTap: () => _handleAddItem(context)),
                          ShortcutItem(
                              keyLabel: 'F3',
                              label: 'Add Master',
                              onTap: () => _handleAddMaster(context)),
                          ShortcutItem(
                              keyLabel: 'F5', label: 'List', onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'F6',
                              label: 'Add Receipt',
                              onTap: () {}),
                          ShortcutItem(
                              keyLabel: 'F8',
                              label: 'Add Sales',
                              onTap: () => context.push('/sales-order')),
                          ShortcutItem(
                              keyLabel: 'F9',
                              label: 'Add Purchase',
                              onTap: () {}),
                          // Add more shortcuts as seen in image
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Status Bar
              Container(
                height: 24,
                color: const Color(0xFF3F51B5), // Status bar blue
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Busy',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('User: Busy',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegacyToolbarButton(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[900]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListView(List<dynamic> items) {
    // Map Items to Table Data
    int index = 1;
    final tableData = items.map((item) {
      return {
        'index': index++,
        'originalItem': item,
        'name': item.name,
        'alias': item.alias,
        'parentGroup': item.parentGroup,
        'quantity': item.quantity,
        'unit': item.unit,
        'price': item.price,
        // Calculate Op. Stock if needed, using quantity for now
        'opStock': item.quantity.toStringAsFixed(2),
      };
    }).toList();

    final columns = [
      const SmartTableColumn(title: 'No.', key: 'index', width: 22),
      const SmartTableColumn(title: 'Name', key: 'name'),
      const SmartTableColumn(title: 'Alias', key: 'alias'),
      const SmartTableColumn(title: 'Parent Group', key: 'parentGroup'),
      const SmartTableColumn(title: 'Op. Stock', key: 'opStock'),
      const SmartTableColumn(title: 'Unit', key: 'unit'),
    ];

    return SmartTable(
      data: tableData,
      columns: columns,
      isDense: true, // Use Dense mode
      showGrid: true, // Show Grid lines
      onRowTap: (row) {
        final item = row['originalItem'];
        context.push('/modify-item', extra: item);
      },
      cellRenderers: {
        'opStock': (value, row) => Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.right,
            )
      },
    );
  }

  Widget _buildGridView(List<dynamic> items) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Sidebar width is 140, so available width is less.
    int crossAxisCount;
    if (screenWidth > 1600) {
      crossAxisCount = 8;
    } else if (screenWidth > 1300) {
      crossAxisCount = 6;
    } else if (screenWidth > 1000) {
      crossAxisCount = 5;
    } else if (screenWidth > 700) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => context.push('/modify-item', extra: item),
          child: _buildItemCard(item),
        );
      },
    );
  }

  Widget _buildItemCard(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Info Section
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.parentGroup,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.price.toStringAsFixed(2),
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${item.quantity} ${item.unit}",
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
}
