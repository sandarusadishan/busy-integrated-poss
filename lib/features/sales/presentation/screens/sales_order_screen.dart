import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../items/data/dummy/dummy_items.dart';
import '../../../items/data/models/item.dart';
import '../../../../core/ui/organisms/pos_header.dart'; // Import POSHeader
import '../../data/models/sales_order_item.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

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

  // Data Source
  late List<Item> _dummyItems;

  // Focus Management
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _dummyItems = getDummyItems();
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
        text = item.itemName;
      }
      if (col == 1) {
        text = item.quantity == 0 ? '' : item.quantity.toStringAsFixed(2);
      }
      if (col == 2) {
        text = item.unit;
      }
      if (col == 3) {
        text = item.price == 0 ? '' : item.price.toStringAsFixed(2);
      }
      if (col == 4) {
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
    item.amount = item.quantity * item.price;
    // Update Amount Controller state
    _getController(row, 4).text = item.amount.toStringAsFixed(2);
    setState(() {}); // Trigger rebuild for totals
  }

  void _onItemSelect(int row, Item selectedItem) {
    final item = _items[row];
    item.itemName = selectedItem.name;
    item.price = selectedItem.price;
    item.unit = selectedItem.unit;

    _getController(row, 0).text = selectedItem.name;
    _getController(row, 2).text = selectedItem.unit;
    _getController(row, 3).text = selectedItem.price.toStringAsFixed(2);
    _calculateRow(row);

    // Move Focus to Qty
    FocusScope.of(context).requestFocus(_getFocusNode(row, 1));
  }

  // Key Handler for Grid Navigation
  KeyEventResult _handleGridKey(
      FocusNode node, KeyEvent event, int row, int col) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (row < _items.length - 1) {
          FocusScope.of(context).requestFocus(_getFocusNode(row + 1, col));
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (row > 0) {
          FocusScope.of(context).requestFocus(_getFocusNode(row - 1, col));
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // Enter: Move Right. If last col, Move Next Row First Col.
        if (col < 3) {
          FocusScope.of(context).requestFocus(_getFocusNode(row, col + 1));
          return KeyEventResult.handled;
        } else {
          // End of row
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
      appBar: const POSHeader(),
      body: Column(
        children: [
          // 2. Page Title (Blue)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              color: const Color(0xFF1565C0), // Blue 800
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              child: const Text('Add Sales Order',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),

          // 3. Header Form
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 40,
                        child: Text('Series', style: TextStyle(fontSize: 12))),
                    const SizedBox(
                        width: 100,
                        child: Text('Main',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(
                        width: 40,
                        child: Text('Date', style: TextStyle(fontSize: 12))),
                    _buildHeaderInput(_dateController, width: 90),
                    const SizedBox(
                      width: 40,
                      child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child:
                              Text('Vch No.', style: TextStyle(fontSize: 12))),
                    ),
                    _buildHeaderInput(_voucherNoController,
                        width: 60, align: TextAlign.right),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(
                        width: 40,
                        child: Text('Party', style: TextStyle(fontSize: 12))),
                    Expanded(
                        child: _buildHeaderInput(_partyController,
                            align: TextAlign.left)),
                    const SizedBox(width: 20),
                    const Text('Mat. Centre', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    const SizedBox(
                        width: 150,
                        child: Text('Main Store',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(
                        width: 40,
                        child:
                            Text('Narration', style: TextStyle(fontSize: 12))),
                    Expanded(
                        child: _buildHeaderInput(_narrationController,
                            align: TextAlign.left)),
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
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        // Grid Header
                        Container(
                          height: 24,
                          color: Colors.grey[300],
                          child: const Row(
                            children: [
                              SizedBox(
                                  width: 30,
                                  child: Center(
                                      child: Text('S.N.',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text('Item',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 60,
                                  child: Center(
                                      child: Text('Qty.',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 50,
                                  child: Center(
                                      child: Text('Unit',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 80,
                                  child: Center(
                                      child: Text('Price (Rs.)',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 100,
                                  child: Center(
                                      child: Text('Amount (Rs.)',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              const Text('(Cur. Stock = 100.00 Kgs.)',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.purple)),
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
                                  child: Text(totalAmount.toStringAsFixed(2),
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

                // Sidebar (Info Panels)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(child: _buildInfoPanel('Item Info.')),
                      Expanded(child: _buildInfoPanel('Voucher Info.')),
                    ],
                  ),
                )
              ],
            ),
          ),

          // 5. Bill Sundry (Simplified)
          Container(
            height: 120, // Lower section height
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Bill Sundry Table (Left)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          color: Colors.grey[300],
                          child: const Row(
                            children: [
                              SizedBox(
                                  width: 30,
                                  child: Center(
                                      child: Text('S.N.',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text('Bill Sundry',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 40,
                                  child: Center(
                                      child: Text('@',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                              SizedBox(
                                  width: 80,
                                  child: Center(
                                      child: Text('Amount (Rs.)',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)))),
                            ],
                          ),
                        ),
                        // Empty rows for now
                        Expanded(
                          child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (c, i) => Container(
                                    height: 20,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5))),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 30,
                                            child: Center(
                                                child: Text('${i + 1}',
                                                    style: const TextStyle(
                                                        fontSize: 11)))),
                                        const VerticalDivider(width: 1),
                                      ],
                                    ),
                                  )),
                        ),
                        // Grand Total
                        Container(
                          padding: const EdgeInsets.all(4),
                          color: const Color(0xFFE0F7FA),
                          alignment: Alignment.centerRight,
                          child: Text(totalAmount.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Buttons (Right)
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(children: [
                        Expanded(child: _buildFooterButton('Save'))
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        Expanded(
                            child: _buildFooterButton('Quit',
                                onPressed: () => context.pop()))
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
    // Background Color Logic? (Selection)
    return Container(
      height: 22,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          // S.N.
          SizedBox(
              width: 30,
              child: Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child:
                    Text('${index + 1}', style: const TextStyle(fontSize: 11)),
              )),
          const VerticalDivider(width: 1),
          // Item (Autocomplete)
          Expanded(
            flex: 2,
            child: LayoutBuilder(builder: (context, constraints) {
              return RawAutocomplete<Item>(
                textEditingController: _getController(index, 0),
                focusNode:
                    _getFocusNode(index, 0), // Listener attached to this node
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<Item>.empty();
                  }
                  return _dummyItems.where((Item option) {
                    return option.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
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
                          itemBuilder: (BuildContext context, int index) {
                            final Item option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.name,
                                    style: const TextStyle(fontSize: 12)),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
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
          const VerticalDivider(width: 1),
          // Qty
          _buildCell(index, 1, width: 60, align: TextAlign.right),
          const VerticalDivider(width: 1),
          // Unit
          _buildCell(index, 2, width: 50, align: TextAlign.center),
          const VerticalDivider(width: 1),
          // Price
          _buildCell(index, 3, width: 80, align: TextAlign.right),
          const VerticalDivider(width: 1),
          // Amount (Read Only)
          _buildCell(index, 4,
              width: 100, align: TextAlign.right, readOnly: true),
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
      style: const TextStyle(fontSize: 12),
      onChanged: (val) {
        // Update State
        final item = _items[row];
        double v = double.tryParse(val) ?? 0;
        if (col == 1) {
          item.quantity = v;
        }
        if (col == 3) {
          item.price = v;
        }
        if (col == 1 || col == 3) {
          _calculateRow(row); // Recalc amount
        }
      },
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        border: InputBorder.none,
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return Expanded(child: child);
  }

  // --- Helper Widgets ---

  Widget _buildHeaderInput(TextEditingController controller,
      {double? width, TextAlign align = TextAlign.left}) {
    // Look like Busy inputs: No border, just text on background? Or underline?
    // Screenshot shows simplified inputs.
    return SizedBox(
      width: width,
      height: 20,
      child: TextField(
        controller: controller,
        textAlign: align,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          // filled: true,
          // fillColor: Colors.white,
          border:
              UnderlineInputBorder(borderSide: BorderSide.none), // Or underline
        ),
      ),
    );
  }

  Widget _buildInfoPanel(String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 8, 0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: const EdgeInsets.all(2),
              color: Colors.grey[100],
              child: Text(title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey))),
          const Spacer(),
          const Icon(Icons.arrow_left, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFooterButton(String label, {VoidCallback? onPressed}) {
    return SizedBox(
      height: 24,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: Colors.grey)),
          elevation: 1,
        ),
        onPressed: onPressed ?? () {},
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
