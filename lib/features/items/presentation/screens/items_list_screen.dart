import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../data/dummy/dummy_items.dart';
import '../../data/models/item.dart';

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGroup = 'All';
  List<String> _groups = ['All'];
  late List<Item> _allItems;
  int? _selectedRowIndex;

  @override
  void initState() {
    super.initState();
    _allItems = getDummyItems();
    _groups = [
      'All',
      ..._allItems.map((e) => e.parentGroup).toSet().toList()..sort()
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> get _filteredItems {
    return _allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.alias.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.itemCode.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGroup =
          _selectedGroup == 'All' || item.parentGroup == _selectedGroup;
      return matchesSearch && matchesGroup;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f2): () =>
            _handleAddItem(context),
        const SingleActivator(LogicalKeyboardKey.f3): () =>
            _handleAddMaster(context),
        const SingleActivator(LogicalKeyboardKey.f5): () => setState(() {}),
        const SingleActivator(LogicalKeyboardKey.escape): () => context.pop(),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: const Color(0xFFE3F2FD),
          appBar: const BusyMenuHeader(),
          body: Column(
            children: [
              // Page Title Bar
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: const Color(0xFF1565C0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  child: const Text(
                    'Items List',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ),

              // Toolbar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Search
                    Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
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
                                  hintText: 'Search by Name, Alias, Code...',
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(bottom: 12),
                                ),
                                style: const TextStyle(fontSize: 12),
                                onChanged: (value) =>
                                    setState(() => _searchQuery = value),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.close,
                                    size: 14, color: Colors.grey),
                                padding: const EdgeInsets.only(right: 4),
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Group Filter Dropdown
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGroup,
                          isDense: true,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                          items: _groups
                              .map((g) =>
                                  DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedGroup = val ?? 'All'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildToolbarButton('Email - [M]', Icons.email_outlined),
                    _buildToolbarButton('Print - [P]', Icons.print_outlined),
                    _buildToolbarButton('Refresh - [R]', Icons.refresh),
                    const SizedBox(width: 4),
                    // Items count badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                const Color(0xFF1565C0).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '${items.length} items',
                        style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Table Area
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            _buildTableHeader(),
                            const Divider(height: 1, color: Color(0xFFBBDEFB)),
                            // Table Body
                            Expanded(
                              child: items.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      itemCount: items.length,
                                      itemBuilder: (context, index) =>
                                          _buildTableRow(items[index], index),
                                    ),
                            ),
                            // Footer Summary
                            _buildTableFooter(items),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Right Shortcut Panel
                    Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
                                label: 'Item Master',
                                onTap: () => _handleAddMaster(context)),
                            ShortcutItem(
                                keyLabel: 'F5',
                                label: 'Refresh',
                                onTap: () => setState(() {})),
                            ShortcutItem(
                                keyLabel: 'F8',
                                label: 'Add Sales',
                                onTap: () =>
                                    context.push('/transaction/Sales-Order')),
                            ShortcutItem(
                                keyLabel: 'F9',
                                label: 'Add Purchase',
                                onTap: () =>
                                    context.push('/transaction/Purchase')),
                            ShortcutItem(
                                keyLabel: 'Esc',
                                label: 'Back',
                                onTap: () => context.pop()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Status Bar
              Container(
                height: 24,
                color: const Color(0xFF3F51B5),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Busy',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                    Text(
                      'Items: ${_filteredItems.length} of ${_allItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    const Text('User: Busy',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFF1565C0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: const Row(
        children: [
          SizedBox(
            width: 40,
            child: Text('No.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 80,
            child: Text('Code',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text('Name',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('Alias',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('Group',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 80,
            child: Text('Unit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 90,
            child: Text('Op. Stock',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 90,
            child: Text('Price',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Item item, int index) {
    final isSelected = _selectedRowIndex == index;
    final isEven = index % 2 == 0;

    return InkWell(
      onTap: () {
        setState(() => _selectedRowIndex = index);
        context.push('/item-master', extra: item);
      },
      child: Container(
        color: isSelected
            ? const Color(0xFF1565C0).withValues(alpha: 0.15)
            : isEven
                ? Colors.white
                : const Color(0xFFF5F9FF),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                item.itemCode,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.name,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                item.alias,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: _groupColor(item.parentGroup).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.parentGroup,
                  style: TextStyle(
                      fontSize: 10,
                      color: _groupColor(item.parentGroup),
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                item.unit,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(
              width: 90,
              child: Text(
                item.quantity.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              width: 90,
              child: Text(
                item.price.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableFooter(List<Item> items) {
    final totalStock = items.fold<int>(0, (sum, i) => sum + i.quantity);
    final totalValue =
        items.fold<double>(0, (sum, i) => sum + (i.price * i.quantity));

    return Container(
      color: const Color(0xFFE3F2FD),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          const Spacer(),
          Text(
            'Total Stock: $totalStock',
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          Text(
            'Total Value: ${totalValue.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('No items found',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[900]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Icon(icon, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _groupColor(String group) {
    final colors = {
      'Pulses': const Color(0xFF6A1B9A),
      'Grains': const Color(0xFFE65100),
      'Flours': const Color(0xFF00796B),
      'Groceries': const Color(0xFF1565C0),
      'Spices': const Color(0xFFB71C1C),
      'Oils': const Color(0xFFF57F17),
      'Beverages': const Color(0xFF0277BD),
      'Dairy': const Color(0xFF558B2F),
      'Poultry': const Color(0xFF4527A0),
      'Meat': const Color(0xFFC62828),
      'Seafood': const Color(0xFF01579B),
      'Vegetables': const Color(0xFF2E7D32),
    };
    return colors[group] ?? const Color(0xFF455A64);
  }

  void _handleAddItem(BuildContext context) {
    context.push('/item-master');
  }

  void _handleAddMaster(BuildContext context) {
    context.push('/item-master');
  }
}
