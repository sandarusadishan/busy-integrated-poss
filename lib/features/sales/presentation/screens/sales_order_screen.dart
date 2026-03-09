import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../items/data/dummy/dummy_items.dart';
import '../../../items/data/models/item.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart'; // Import BusyMenuHeader
import '../../data/models/sales_order_item.dart';

class SalesOrderScreen extends StatefulWidget {
  final String title;
  const SalesOrderScreen({super.key, this.title = 'Sales Order'});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  // --- State ---

  // Header Controllers
  final _dateController = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  final _voucherNoController = TextEditingController(text: '1');
  final _partyController = TextEditingController(text: 'Cash');
  final _narrationController = TextEditingController();

  // Grid State
  final List<SalesOrderItem> _items = [];
  final int _initialRows = 10;
  bool _isPosMode = false; // POS toggle layout mode
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  // Data Source
  late List<Item> _dummyItems;

  // Focus Management
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _dummyItems = getDummyItems();
    _categories = ['All', ..._dummyItems.map((e) => e.parentGroup).toSet()];
    _initializeGrid();
  }

  void _initializeGrid() {
    // Start with some empty rows
    for (int i = 0; i < _initialRows; i++) {
      _addItemRow();
    }
  }

  void _addItemRow({int? atIndex}) {
    final newItem = SalesOrderItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            _items.length.toString());
    if (atIndex != null) {
      _items.insert(atIndex, newItem);
    } else {
      _items.add(newItem);
    }
    _rebuildControllersAndFocus();
  }

  void _removeItemRow(int index) {
    if (_items.length <= 1) {
      return; // Keep at least one row
    }
    setState(() {
      _items.removeAt(index);
      _rebuildControllersAndFocus();
    });
  }

  // Efficiently manage controllers/focus to avoid leaks/stale state
  void _rebuildControllersAndFocus() {
    // Logic placeholder
  }

  // Helper to get controller for a cell, creating if needed
  TextEditingController _getController(int row, int col) {
    String key = '${row}_$col';
    if (!_controllers.containsKey(key)) {
      String text = '';
      final item = _items[row];
      if (col == 0) {
        text = item.itemCode;
      }
      if (col == 1) {
        text = item.itemName;
      }
      if (col == 2) {
        text = item.quantity == 0 ? '' : item.quantity.toStringAsFixed(2);
      }
      if (col == 3) {
        text = item.unit;
      }
      if (col == 4) {
        text = item.altQty == 0 ? '' : item.altQty.toStringAsFixed(2);
      }
      if (col == 5) {
        text = item.discount == 0 ? '' : item.discount.toStringAsFixed(2);
      }
      if (col == 6) {
        text = item.price == 0 ? '' : item.price.toStringAsFixed(2);
      }
      if (col == 7) {
        text = item.amount == 0 ? '' : item.amount.toStringAsFixed(2);
      }

      _controllers[key] = TextEditingController(text: text);
    }
    return _controllers[key]!;
  }

  FocusNode _getFocusNode(int row, int col) {
    String key = '${row}_$col';
    if (!_focusNodes.containsKey(key)) {
      _focusNodes[key] = FocusNode(
        onKeyEvent: (node, event) => _handleGridKey(node, event, row, col),
      );
    }
    return _focusNodes[key]!;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _voucherNoController.dispose();
    _partyController.dispose();
    _narrationController.dispose();
    for (var c in _controllers.values) {
      c.dispose();
    }
    for (var f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  // --- Logic ---

  void _calculateRow(int row) {
    final item = _items[row];
    double subtotal = item.quantity * item.price;
    item.amount = subtotal - (subtotal * (item.discount / 100));
    // Update Amount Controller state
    _getController(row, 7).text = item.amount.toStringAsFixed(2);
    setState(() {}); // Trigger rebuild for totals
  }

  void _onItemSelect(int row, Item selectedItem) {
    final item = _items[row];
    item.itemCode = selectedItem.itemCode;
    item.itemName = selectedItem.name;
    item.price = selectedItem.price;
    item.unit = selectedItem.unit;
    item.altUnit = selectedItem.altUnit;
    item.imageUrl = selectedItem.imageUrl;

    _getController(row, 0).text = selectedItem.itemCode;
    _getController(row, 1).text = selectedItem.name;
    _getController(row, 3).text = selectedItem.unit;
    _getController(row, 6).text = selectedItem.price.toStringAsFixed(2);
    _calculateRow(row);

    // Move Focus to Qty
    FocusScope.of(context).requestFocus(_getFocusNode(row, 2));
  }

  Future<void> _showItemDetailsDialog(Item catalogItem) async {
    double quantity = 0;
    double discount = 0.0;
    final TextEditingController qtyController =
        TextEditingController(text: '0');
    final TextEditingController discountController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Image
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: SizedBox(
                        height: 150,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              catalogItem.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image,
                                          size: 50, color: Colors.grey)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7)
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      catalogItem.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${catalogItem.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 24),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quantity Selector
                          const Text('Quantity',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // Creative Quantity Input
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                                left: Radius.circular(11)),
                                        onTap: () {
                                          if (quantity > 0) {
                                            setState(() {
                                              quantity--;
                                              qtyController.text =
                                                  quantity.toStringAsFixed(
                                                      quantity.truncateToDouble() ==
                                                              quantity
                                                          ? 0
                                                          : 2);
                                            });
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Icon(Icons.remove,
                                              color: Colors.black87, size: 20),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF1565C0),
                                            width: 2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: TextField(
                                        controller: qtyController,
                                        autofocus: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (val) {
                                          final q = double.tryParse(val);
                                          if (q != null && q > 0) {
                                            setState(() {
                                              quantity = q;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                                right: Radius.circular(11)),
                                        onTap: () {
                                          setState(() {
                                            quantity++;
                                            qtyController.text =
                                                quantity.toStringAsFixed(
                                                    quantity.truncateToDouble() ==
                                                            quantity
                                                        ? 0
                                                        : 2);
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Icon(Icons.add,
                                              color: Colors.black87, size: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(catalogItem.unit,
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Discount Presets and Manual Entry
                          const Text('Discount Setup',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ...[0.0, 5.0, 10.0, 15.0, 20.0].map((preset) {
                                final isSelected = discount == preset;
                                return ChoiceChip(
                                  label: Text(preset == 0
                                      ? 'None'
                                      : '${preset.toStringAsFixed(0)}%'),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFF1565C0)
                                      .withValues(alpha: 0.2),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF1565C0)
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        discount = preset;
                                        discountController.clear();
                                      });
                                    }
                                  },
                                );
                              }),
                              // Manual Discount Input Creative
                              SizedBox(
                                width: 90,
                                height: 40,
                                child: TextField(
                                  controller: discountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText: 'Custom ...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.normal),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Round pill shape
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF1565C0), width: 2),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    final d = double.tryParse(val) ?? 0.0;
                                    setState(() {
                                      discount = d;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Action Buttons
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                  'Add to Order - Rs. ${((catalogItem.price * quantity) * (1 - discount / 100)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == true) {
      _processItemToOrder(catalogItem, quantity.toDouble(), discount);
    }
  }

  void _processItemToOrder(
      Item catalogItem, double qtyToAdd, double discountPercentage) {
    // Check if item already exists in the active rows
    int existingIndex =
        _items.indexWhere((element) => element.itemName == catalogItem.name);

    if (existingIndex != -1) {
      // Aggregate existing item
      final existingItem = _items[existingIndex];
      existingItem.quantity += qtyToAdd;
      existingItem.discount =
          discountPercentage; // Overwrite or apply new discount

      _getController(existingIndex, 2).text =
          existingItem.quantity.toStringAsFixed(2);
      _calculateRow(existingIndex);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Updated ${catalogItem.name} quantity to ${existingItem.quantity.toStringAsFixed(2)}'),
        duration: const Duration(seconds: 1),
      ));
    } else {
      // Find the first empty row
      int targetRow = -1;
      for (int i = 0; i < _items.length; i++) {
        if (_items[i].itemName.isEmpty) {
          targetRow = i;
          break;
        }
      }

      if (targetRow == -1) {
        // If no empty row exists, add a new one
        _addItemRow();
        targetRow = _items.length - 1;
      }

      // Populate the row
      final item = _items[targetRow];
      item.itemCode = catalogItem.itemCode;
      item.itemName = catalogItem.name;
      item.price = catalogItem.price;
      item.unit = catalogItem.unit;
      item.altUnit = catalogItem.altUnit;
      item.imageUrl = catalogItem.imageUrl;
      item.quantity = qtyToAdd;
      item.discount = discountPercentage;

      _getController(targetRow, 0).text = catalogItem.itemCode;
      _getController(targetRow, 1).text = catalogItem.name;
      _getController(targetRow, 2).text = qtyToAdd.toStringAsFixed(2);
      _getController(targetRow, 3).text = catalogItem.unit;
      _getController(targetRow, 6).text = catalogItem.price.toStringAsFixed(2);

      _calculateRow(targetRow);
    }
  }

  bool _validateCurrentRow(int row) {
    final currentItem = _items[row];
    if (currentItem.itemName.isNotEmpty &&
        (currentItem.quantity <= 0 || currentItem.unit.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Quantity and Unit for the item.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  // Key Handler for Grid Navigation
  KeyEventResult _handleGridKey(
      FocusNode node, KeyEvent event, int row, int col) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // Let Autocomplete handle arrow down if typing an item
        if (col == 0 && _getController(row, col).text.isNotEmpty) {
          return KeyEventResult.ignored;
        }

        if (!_validateCurrentRow(row)) return KeyEventResult.handled;

        if (row < _items.length - 1) {
          FocusScope.of(context).requestFocus(_getFocusNode(row + 1, col));
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // Let Autocomplete handle arrow up if typing an item
        if (col == 0 && _getController(row, col).text.isNotEmpty) {
          return KeyEventResult.ignored;
        }
        if (row > 0) {
          FocusScope.of(context).requestFocus(_getFocusNode(row - 1, col));
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // Let Autocomplete handle enter if typing an item
        if (col == 0 && _getController(row, col).text.isNotEmpty) {
          return KeyEventResult.ignored;
        }
        // Enter: Move Right. If last col, Move Next Row First Col.
        if (col < 3) {
          FocusScope.of(context).requestFocus(_getFocusNode(row, col + 1));
          return KeyEventResult.handled;
        } else {
          // End of row
          if (!_validateCurrentRow(row)) return KeyEventResult.handled;

          if (row < _items.length - 1) {
            FocusScope.of(context).requestFocus(_getFocusNode(row + 1, 0));
            return KeyEventResult.handled;
          } else {
            // Add new row if at very end
            setState(() {
              _addItemRow();
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                FocusScope.of(context).requestFocus(_getFocusNode(row + 1, 0));
              }
            });
            return KeyEventResult.handled;
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.f9) {
        // F9: Delete Row
        _removeItemRow(row);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.insert) {
        setState(() {
          _addItemRow(atIndex: row);
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // Totals Calculation
    double totalQty = _items.fold(0, (sum, item) => sum + item.quantity);
    double totalAmount = _items.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light Blue 50
      appBar: const BusyMenuHeader(),
      body: Column(
        children: [
          // 2. Page Title (Blue)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              color: const Color(0xFF1565C0), // Blue 800
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              child: Text('Add ${widget.title}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),

          // 3. Header Form
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 50,
                        child: Text('Series',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54))),
                    const SizedBox(
                        width: 90,
                        child: Text('Main',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF1565C0)))),
                    const SizedBox(
                        width: 40,
                        child: Text('Date',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54))),
                    _buildHeaderInput(
                      _dateController,
                      width: 120, // Slightly wider to look nice
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month,
                            size: 16, color: Colors.blue),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(right: 8),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const SizedBox(
                      width: 50,
                      child: Text('Vch No.',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54)),
                    ),
                    _buildHeaderInput(_voucherNoController,
                        width: 70, align: TextAlign.right),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(
                        width: 50,
                        child: Text('Party',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54))),
                    SizedBox(
                        width: 280, // Even shorter
                        child: _buildHeaderInput(_partyController,
                            align: TextAlign.left,
                            prefixIcon: const Icon(Icons.person_outline,
                                size: 16, color: Colors.black38))),
                    const SizedBox(width: 32),
                    const Text('Mat. Centre',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                    const SizedBox(width: 12),
                    const SizedBox(
                        width: 140,
                        child: Text('Main Store',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87))),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(
                        width: 70,
                        child: Text('Narration',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54))),
                    SizedBox(
                        width:
                            260, // Matching the shortened width (280 - 20 for label diff)
                        child: _buildHeaderInput(_narrationController,
                            align: TextAlign.left,
                            prefixIcon: const Icon(Icons.notes,
                                size: 16, color: Colors.black38))),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isPosMode = !_isPosMode;
                        });
                      },
                      icon: Icon(
                          _isPosMode ? Icons.table_chart : Icons.point_of_sale,
                          size: 18,
                          color: const Color(0xFF1565C0)),
                      label: Text(
                          _isPosMode
                              ? 'Switch to Grid Mode'
                              : 'Switch to POS Mode',
                          style: const TextStyle(
                              color: Color(0xFF1565C0),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1565C0).withValues(alpha: 0.08),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Grid Area (Main Content)
          Expanded(
            child: Row(
              children: [
                // Grid
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _isPosMode
                        ? _buildItemCatalogPanel()
                        : Column(
                            children: [
                              // Grid Header
                              Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0)
                                      .withValues(alpha: 0.08),
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300)),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                        width: 35,
                                        child: Center(
                                            child: Text('No',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 90,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text('Item Code',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text('Item Name',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 50,
                                        child: Center(
                                            child: Text('Qty',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 45,
                                        child: Center(
                                            child: Text('Unit',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 90,
                                        child: Center(
                                            child: Text('Alt Qty',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 60,
                                        child: Center(
                                            child: Text('Disc.',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 80,
                                        child: Center(
                                            child: Text('Price',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    SizedBox(
                                        width: 95,
                                        child: Center(
                                            child: Text('Amount',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF1565C0),
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                  ],
                                ),
                              ),
                              // Grid Rows
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _items.length,
                                  itemBuilder: (context, index) {
                                    return _buildGridRow(index);
                                  },
                                ),
                              ),
                              // Grid Footer (Item Footer)
                              Container(
                                height: 24,
                                color: const Color(0xFFE0F7FA), // Match BG
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  children: [
                                    const Text('(Cur. Stock = 100.00 Kgs.)',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.purple)),
                                    const Spacer(),
                                    SizedBox(
                                        width: 60,
                                        child: Text(totalQty.toStringAsFixed(2),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12))),
                                    const SizedBox(
                                        width: 130), // Spacing for unit + price
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                            totalAmount.toStringAsFixed(2),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13))),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ),

                // Sidebar (Selected Items Info)
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _isPosMode
                        ? _buildPosReceiptList(totalQty, totalAmount)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0)
                                      .withValues(alpha: 0.05),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.image,
                                        size: 18, color: Color(0xFF1565C0)),
                                    SizedBox(width: 8),
                                    Text('Selected Items',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1565C0))),
                                  ],
                                ),
                              ),
                              Expanded(child: _buildSelectedItemsImagesPanel()),
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),

          // 5. Bill Sundry (Simplified)
          Container(
            height: 125, // Lower section height
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Bill Sundry Table (Left)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1565C0).withValues(alpha: 0.08),
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                  width: 35,
                                  child: Center(
                                      child: Text('S.N.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1565C0),
                                              fontWeight: FontWeight.bold)))),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text('Bill Sundry',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1565C0),
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 45,
                                  child: Center(
                                      child: Text('@',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1565C0),
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 85,
                                  child: Center(
                                      child: Text('Amount',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1565C0),
                                              fontWeight: FontWeight.bold)))),
                            ],
                          ),
                        ),
                        // Empty rows for now
                        Expanded(
                          child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (c, i) => Container(
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: i % 2 == 0
                                            ? Colors.white
                                            : Colors.blue
                                                .withValues(alpha: 0.02),
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1))),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 35,
                                            child: Center(
                                                child: Text('${i + 1}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontWeight:
                                                            FontWeight.w500)))),
                                        Container(
                                            width: 1,
                                            color: Colors.grey.shade300),
                                      ],
                                    ),
                                  )),
                        ),
                        // Grand Total
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1565C0).withValues(alpha: 0.08),
                            border: Border(
                                top: BorderSide(color: Colors.grey.shade300)),
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(
                              'Total: Rs. ${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1565C0))),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Buttons (Right)
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(children: [
                        Expanded(
                            child: _buildFooterButton('Save', primary: true))
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: _buildFooterButton('Quit',
                                onPressed: () => context.pop(), primary: false))
                      ]),
                    ],
                  ),
                )
              ],
            ),
          ),

          // 6. Bottom Status Bar (Black)
          Container(
            height: 24,
            width: double.infinity,
            color: const Color(0xFF1565C0), // Blue 800
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildStatusText('[ Esc - Quit ]'),
                _buildStatusText('[ F2 - Done ]'),
                _buildStatusText('[ F4 - Std.Nar./BOM ]'),
                _buildStatusText('[ F9 - Del. Line ]'),
                const Spacer(),
                _buildStatusText('User : Busy'),
                const SizedBox(width: 16),
                _buildStatusText('Country : Sri Lanka'),
              ],
            ),
          ),

          // 7. Company Footer (White)
          Container(
            height: 30,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Row(
              children: [
                Text('Busy',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Spacer(),
                Text('Savibala Hardware', style: TextStyle(fontSize: 11)),
                Spacer(),
                Text('F.Y. : 2026-27', style: TextStyle(fontSize: 11)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- Grid Widgets ---

  Widget _buildGridRow(int index) {
    // Alternating background colors
    final bgColor =
        index % 2 == 0 ? Colors.white : Colors.blue.withValues(alpha: 0.02);

    return Container(
      height:
          28, // Down from 32 to ensure exactly 10 items fit perfectly in the viewport without scrolling
      decoration: BoxDecoration(
        color: bgColor,
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          // S.N.
          SizedBox(
            width: 35,
            child: GestureDetector(
              onSecondaryTapDown: (details) {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                  items: [
                    const PopupMenuItem(
                      value: 'insert',
                      height: 32,
                      child: Row(children: [
                        Icon(Icons.add, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Insert Row', style: TextStyle(fontSize: 12)),
                      ]),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      height: 32,
                      child: Row(children: [
                        Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Row',
                            style: TextStyle(fontSize: 12, color: Colors.red)),
                      ]),
                    ),
                  ],
                ).then((value) {
                  if (value == 'insert') {
                    setState(() {
                      _addItemRow(atIndex: index);
                    });
                  } else if (value == 'delete') {
                    _removeItemRow(index);
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                color:
                    Colors.transparent, // Ensures the whole area is clickable
                child: Text('${index + 1}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          Container(width: 1, color: Colors.grey.shade300),
          // Item Code
          _buildCell(index, 0, width: 90, align: TextAlign.left),
          Container(width: 1, color: Colors.grey.shade300),
          // Item Name (Autocomplete)
          Expanded(
            flex: 2,
            child: LayoutBuilder(builder: (context, constraints) {
              return RawAutocomplete<Item>(
                textEditingController: _getController(index, 1),
                focusNode:
                    _getFocusNode(index, 1), // Listener attached to this node
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<Item>.empty();
                  }
                  return _dummyItems.where((Item option) {
                    final query = textEditingValue.text.toLowerCase();
                    return option.name.toLowerCase().contains(query) ||
                        option.itemCode.toLowerCase().contains(query) ||
                        option.alias.toLowerCase().contains(query);
                  });
                },
                onSelected: (Item selection) {
                  _onItemSelect(index, selection);
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<Item> onSelected,
                    Iterable<Item> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200.0,
                        width: constraints.maxWidth, // Match width
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int optionIndex) {
                            final Item option = options.elementAt(optionIndex);
                            return Builder(
                              builder: (BuildContext context) {
                                final bool highlight =
                                    AutocompleteHighlightedOption.of(context) ==
                                        optionIndex;
                                return InkWell(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: Container(
                                    color: highlight
                                        ? Theme.of(context).focusColor
                                        : null,
                                    child: ListTile(
                                      title: Text(option.name,
                                          style: const TextStyle(fontSize: 12)),
                                      dense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onSubmitted: (String value) {
                      onFieldSubmitted();
                      if (context.mounted && focusNode.hasFocus) {
                        FocusScope.of(context)
                            .requestFocus(_getFocusNode(index, 2));
                      }
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  );
                },
              );
            }),
          ),
          Container(width: 1, color: Colors.grey.shade300),
          // Qty
          _buildCell(index, 2, width: 50, align: TextAlign.right),
          Container(width: 1, color: Colors.grey.shade300),
          // Unit
          _buildCell(index, 3, width: 45, align: TextAlign.center),
          Container(width: 1, color: Colors.grey.shade300),
          // Alt Qty
          _buildCell(index, 4, width: 90, align: TextAlign.right),
          Container(width: 1, color: Colors.grey.shade300),
          // Discount
          _buildCell(index, 5, width: 60, align: TextAlign.right),
          Container(width: 1, color: Colors.grey.shade300),
          // Price
          _buildCell(index, 6, width: 80, align: TextAlign.right),
          Container(width: 1, color: Colors.grey.shade300),
          // Amount (Read Only)
          _buildCell(index, 7,
              width: 95, align: TextAlign.right, readOnly: true),
        ],
      ),
    );
  }

  Widget _buildCell(int row, int col,
      {double? width,
      TextAlign align = TextAlign.left,
      bool readOnly = false}) {
    Widget child = TextField(
      controller: _getController(row, col),
      focusNode: _getFocusNode(row, col), // Listener attached to this node
      readOnly: readOnly,
      textAlign: align,
      style: TextStyle(
          fontSize: 12,
          fontWeight: col == 7 ? FontWeight.bold : FontWeight.normal,
          color: readOnly ? Colors.blue.shade900 : Colors.black87),
      onChanged: (val) {
        // Update State
        final item = _items[row];
        double v = double.tryParse(val) ?? 0;
        if (col == 2) {
          item.quantity = v;
        }
        if (col == 4) {
          item.altQty = v;
        }
        if (col == 5) {
          item.discount = v;
        }
        if (col == 6) {
          item.price = v;
        }
        if (col == 2 || col == 5 || col == 6) {
          _calculateRow(row); // Recalc amount
        }
      },
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5)),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return Expanded(child: child);
  }

  // --- Helper Widgets ---

  Widget _buildHeaderInput(TextEditingController controller,
      {double? width,
      TextAlign align = TextAlign.left,
      Widget? suffixIcon,
      Widget? prefixIcon}) {
    return SizedBox(
      width: width,
      height: 32, // Slightly taller for a more premium look
      child: TextField(
        controller: controller,
        textAlign: align,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          filled: true,
          fillColor: Colors.grey.shade50, // Subtle background
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          suffixIconConstraints: const BoxConstraints(maxHeight: 32),
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 32, minWidth: 36),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8), // Modern slightly rounded corners
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black87, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Widget _buildSelectedItemsImagesPanel() {
    final selectedItems = _items
        .where((item) => item.itemName.isNotEmpty && item.imageUrl != null)
        .toList();

    if (selectedItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_not_supported_outlined,
                size: 48, color: Colors.black26),
            SizedBox(height: 12),
            Text('No items selected',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: selectedItems.length,
      itemBuilder: (context, index) {
        final item = selectedItems[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade200, width: 1)),
                  color: Colors.grey.shade50,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Qty: ${item.quantity.toStringAsFixed(0)} ${item.unit}',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemCatalogPanel() {
    final filteredItems = _dummyItems.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.alias.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || item.parentGroup == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        // Search and Filters Header
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            children: [
              // Search Bar
              SizedBox(
                height: 38,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items by name or alias...',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.search,
                        size: 20, color: Color(0xFF1565C0)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Categories
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor:
                          const Color(0xFF1565C0).withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF1565C0)
                            : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Items Grid
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(
                  child: Text('No items found',
                      style: TextStyle(color: Colors.black45, fontSize: 13)),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // 6 items per row as requested
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return InkWell(
                      onTap: () {
                        _showItemDetailsDialog(item);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                          child: Icon(
                                              Icons.inventory_2_outlined,
                                              color: Colors.grey,
                                              size: 24)),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey.shade200, width: 1)),
                                color: Colors.grey.shade50,
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(8)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Rs. ${item.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1565C0)), // Store blue
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }

  Widget _buildPosReceiptList(double totalQty, double totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.05),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: const Row(
            children: [
              Icon(Icons.receipt_long, size: 18, color: Color(0xFF1565C0)),
              SizedBox(width: 8),
              Text('Current Order',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0))),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _items.where((e) => e.itemName.isNotEmpty).length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activeItems =
                  _items.where((e) => e.itemName.isNotEmpty).toList();
              final item = activeItems[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.itemName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black87)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // Inline +/- qty control
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        int origIdx = _items.indexOf(item);
                                        if (item.quantity > 1) {
                                          item.quantity--;
                                          _getController(origIdx, 1).text =
                                              item.quantity.toStringAsFixed(2);
                                          _calculateRow(origIdx);
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        child: Icon(Icons.remove, size: 14),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.grey.shade100,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: Text(
                                          item.quantity.toStringAsFixed(0),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        int origIdx = _items.indexOf(item);
                                        item.quantity++;
                                        _getController(origIdx, 1).text =
                                            item.quantity.toStringAsFixed(2);
                                        _calculateRow(origIdx);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        child: Icon(Icons.add, size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('@ Rs.${item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11)),
                            ],
                          ),
                          if (item.discount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                  'Discount: ${item.discount.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rs. ${item.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87)),
                        if (item.discount > 0)
                          Text(
                              'Rs. ${(item.quantity * item.price).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            int origIdx = _items.indexOf(item);
                            _removeItemRow(origIdx);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.delete_outline,
                                size: 16, color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Qty',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                    Text(totalQty.toStringAsFixed(2),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                SizedBox(height: _calculateTotalDiscount() > 0 ? 4 : 0),
                if (_calculateTotalDiscount() > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Discount',
                          style: TextStyle(fontSize: 12, color: Colors.green)),
                      Text(
                          '- Rs. ${_calculateTotalDiscount().toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.green)),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Grand Total',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0))),
                    Text('Rs. ${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1565C0))),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (totalAmount > 0) _showPaymentDialog(totalAmount);
                    },
                    child: const Text('Checkout / Pay',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )
              ],
            ))
      ],
    );
  }

  double _calculateTotalDiscount() {
    double discount = 0;
    for (var item in _items) {
      if (item.itemName.isNotEmpty) {
        discount += (item.quantity * item.price) * (item.discount / 100);
      }
    }
    return discount;
  }

  Future<void> _showPaymentDialog(double totalDue) async {
    final tenderedController =
        TextEditingController(text: totalDue.toStringAsFixed(2));
    double tendered = totalDue;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            double change = tendered - totalDue;

            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      const Text('Checkout',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Due',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54)),
                          Text('Rs. ${totalDue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0))),
                        ],
                      ),
                      const Divider(height: 32),
                      TextField(
                        controller: tenderedController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'Amount Tendered (Rs.)',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            tendered = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: change >= 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: change >= 0
                                  ? Colors.green.shade200
                                  : Colors.red.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                change >= 0
                                    ? 'Change to Return'
                                    : 'Amount Short',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: change >= 0
                                        ? Colors.green.shade700
                                        : Colors.red.shade700)),
                            Text('Rs. ${change.abs().toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: change >= 0
                                        ? Colors.green.shade700
                                        : Colors.red.shade700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                              onPressed: change >= 0
                                  ? () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Payment Successful! Order Completed.'),
                                              backgroundColor: Colors.green));
                                      // Here you would typically clear the order and save to DB
                                    }
                                  : null,
                              child: const Text('Confirm',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ));
          });
        });
  }

  Widget _buildFooterButton(String label,
      {VoidCallback? onPressed, bool primary = false}) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? const Color(0xFF1565C0) : Colors.white,
          foregroundColor: primary ? Colors.white : Colors.black87,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: primary ? Colors.transparent : Colors.grey.shade300)),
          elevation: primary ? 2 : 0,
        ),
        onPressed: onPressed ?? () {},
        child: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _buildStatusText(String text) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold)));
  }
}
