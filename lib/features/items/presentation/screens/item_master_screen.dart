import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../data/models/item.dart';

class ItemMasterScreen extends StatefulWidget {
  final Item? item; // null = Add mode, non-null = Modify mode

  const ItemMasterScreen({super.key, this.item});

  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> {
  bool get _isModifyMode => widget.item != null;

  // ── Controllers ──────────────────────────────────────────────────────────
  late TextEditingController _nameController;
  late TextEditingController _aliasController;
  late TextEditingController _printNameController;
  late TextEditingController _groupController;
  late TextEditingController _unitController;
  late TextEditingController _opStockQtyController;
  late TextEditingController _opStockValueController;
  late TextEditingController _salesPriceController;

  final TextEditingController _purcPriceController =
      TextEditingController(text: '0.00');
  final TextEditingController _mrpController =
      TextEditingController(text: '0.00');
  final TextEditingController _minSalesPriceController =
      TextEditingController(text: '0.00');
  final TextEditingController _selfValPriceController =
      TextEditingController(text: '0.00');
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _saleDiscController =
      TextEditingController(text: '0.00');
  final TextEditingController _purcDiscController =
      TextEditingController(text: '0.00');
  final TextEditingController _specifyDefaultMCController =
      TextEditingController();
  final TextEditingController _freezeMCController = TextEditingController();

  // ── Toggles ──────────────────────────────────────────────────────────────
  // ignore: prefer_final_fields
  bool _setCriticalLevel = true;
  // ignore: prefer_final_fields
  bool _dontMaintainStockBalance = false;

  // ── Image Picker ─────────────────────────────────────────────────────────
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?.name ?? '');
    _aliasController = TextEditingController(text: item?.alias ?? '');
    _printNameController = TextEditingController(text: item?.name ?? '');
    _groupController = TextEditingController(text: item?.parentGroup ?? '');
    _unitController = TextEditingController(text: item?.unit ?? '');
    _opStockQtyController = TextEditingController(
        text: item != null ? item.quantity.toStringAsFixed(2) : '0.00');
    _opStockValueController = TextEditingController(
        text: item != null
            ? (item.price * item.quantity).toStringAsFixed(2)
            : '0.00');
    _salesPriceController = TextEditingController(
        text: item != null ? item.price.toStringAsFixed(2) : '0.00');

    if (item != null) {
      _purcPriceController.text = '0.00';
      _mrpController.text = '0.00';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _printNameController.dispose();
    _groupController.dispose();
    _unitController.dispose();
    _opStockQtyController.dispose();
    _opStockValueController.dispose();
    _salesPriceController.dispose();
    _purcPriceController.dispose();
    _mrpController.dispose();
    _minSalesPriceController.dispose();
    _selfValPriceController.dispose();
    _descriptionController.dispose();
    _saleDiscController.dispose();
    _purcDiscController.dispose();
    _specifyDefaultMCController.dispose();
    _freezeMCController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _pickedImage = image);
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFE3F2FD);
    const titleBoxColor = Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Main Menu Header ─────────────────────────────────────────────
          const BusyMenuHeader(),
          // ── Title Bar ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              color: titleBoxColor,
              child: Text(
                _isModifyMode ? 'Modify Item Master' : 'Add Item Master',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),

          // ── Main Content ─────────────────────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Form (3 columns) ─────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── LEFT COLUMN ───────────────────────────────────
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDenseRow('Name', _nameController,
                                  isBold: true),
                              _buildDenseRow('Alias', _aliasController),
                              _buildDenseRow(
                                  'Print Name', _printNameController),
                              _buildDenseRow('Group', _groupController),
                              const SizedBox(height: 8),
                              _buildGroupBox(
                                title: 'Main Unit Details',
                                child: _buildDenseRow('Unit', _unitController,
                                    width: 60),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                color: Colors.teal.withValues(alpha: 0.1),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    _buildDenseRow('Op. Stock (Qty.)',
                                        _opStockQtyController,
                                        isBold: true),
                                    _buildDenseRow('Op. Stock (Value)',
                                        _opStockValueController,
                                        isBold: true),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildGroupBox(
                                title: 'Item Price Info',
                                child: Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Sales Price applied on',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey)),
                                        Text('Purc. Price applied on',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    _buildDenseRow('Sales Price (Kgs.)',
                                        _salesPriceController,
                                        isBold: true),
                                    _buildDenseRow('Purc. Price (Kgs.)',
                                        _purcPriceController,
                                        isBold: true),
                                    _buildDenseRow(
                                        'M.R.P. (Kgs.)', _mrpController,
                                        isBold: true),
                                    _buildDenseRow('Min. Sales Price (Kgs.)',
                                        _minSalesPriceController),
                                    _buildDenseRow('Self-Val. Price',
                                        _selfValPriceController),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildGroupBox(
                                  title: 'Packaging Unit Details',
                                  child: Column(
                                    children: [
                                      _buildLabelValue(
                                          'Packaging Unit', 'Con. Factor'),
                                      _buildLabelValue('Sales Price (Kgs.)',
                                          'Purc. Price (Kgs.)'),
                                    ],
                                  )),
                              const SizedBox(height: 8),
                              _buildLabelValue('Default Unit for Sales',
                                  'Default Unit for Purc.'),
                              _buildLabelValue('Tax Inclusive Sale Price',
                                  'Tax Inclusive Purchase'),
                              const Row(
                                children: [
                                  SizedBox(
                                      width: 110,
                                      child: Text('Sales Account',
                                          style: TextStyle(fontSize: 12))),
                                  Text('Specify Here',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Row(
                                children: [
                                  SizedBox(
                                      width: 110,
                                      child: Text('Purchase Account',
                                          style: TextStyle(fontSize: 12))),
                                  Text('Specify Here',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // ── MIDDLE COLUMN ─────────────────────────────────
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGroupBox(
                                title: 'Discount & Markup Det.',
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildDenseRow(
                                                'Sale Discount',
                                                _saleDiscController,
                                                labelWidth: 80)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: _buildDenseRow(
                                                'Purc. Discount',
                                                _purcDiscController,
                                                labelWidth: 80)),
                                      ],
                                    ),
                                    _buildLabelValue('Sale Compound Disc.',
                                        'Purc. Compound Disc.'),
                                    const Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                'Specify Sales Disc.Structure   N',
                                                style:
                                                    TextStyle(fontSize: 12))),
                                        Expanded(
                                            child: Text(
                                                'Specify Purc. Disc.Structure   N',
                                                style:
                                                    TextStyle(fontSize: 12))),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildLabelValue(
                                        'Sale Markup', 'Purc. Markup'),
                                    _buildLabelValue('Sale Comp. Markup',
                                        'Purc. Comp. Markup'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildGroupBox(
                                title: 'Item Description',
                                child: Container(
                                  height: 80,
                                  color: Colors.white,
                                  child: TextField(
                                    controller: _descriptionController,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildToggleRow(
                                  'Set Critical Level (Y/N)', _setCriticalLevel,
                                  onToggle: () => setState(() =>
                                      _setCriticalLevel = !_setCriticalLevel)),
                              const SizedBox(height: 8),
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Maintain RG-23D',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('Serial No.-wise Details',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('Parameterized Details',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('MRP-wise Details',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('Exp./Mfg. Date Required',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Tariff Heading',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        SizedBox(height: 16),
                                        Text('Maintain BCN',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('Batch-wise Details',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('Expiry Days',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDenseRow('Specify Default MC',
                                  _specifyDefaultMCController),
                              _buildDenseRow(
                                  'Freeze MC for Item', _freezeMCController),
                              Row(
                                children: [
                                  const Text(
                                      'Total No. of Authors      (Max. 10)',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                  const Spacer(),
                                  Text(
                                      "Don't Maintain Stock Balance   ${_dontMaintainStockBalance ? 'Y' : 'N'}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Text(
                                  'Pick Item Sizing Info. from Item Description',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              const Text('Specify Default Vendor   N',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              // ── Save / Quit ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildActionButton('Save',
                                      onPressed: () => _handleSave(context)),
                                  const SizedBox(width: 8),
                                  _buildActionButton('Quit',
                                      onPressed: () => context.pop()),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // ── RIGHT COLUMN — Image ───────────────────────────
                        Expanded(
                          flex: 3,
                          child: _buildGroupBox(
                            title: 'Item Image',
                            child: Column(
                              children: [
                                Container(
                                  height: 250,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: _pickedImage != null
                                      ? Image.network(_pickedImage!.path,
                                          fit: BoxFit.contain)
                                      : (widget.item?.imageUrl.isNotEmpty ==
                                              true
                                          ? Image.network(widget.item!.imageUrl,
                                              fit: BoxFit.contain)
                                          : const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons.image_not_supported,
                                                      size: 40,
                                                      color: Colors.grey),
                                                  SizedBox(height: 8),
                                                  Text('No Image',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            )),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildActionButton('Browse...',
                                        onPressed: _pickImage),
                                    const SizedBox(width: 8),
                                    _buildActionButton('Clear',
                                        onPressed: () => setState(
                                            () => _pickedImage = null)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Shortcut Sidebar ─────────────────────────────────────
                ShortcutPanel(
                  items: [
                    ShortcutItem(keyLabel: 'F1', label: 'Help', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F1', label: 'Add Account', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F2', label: 'Add Item', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F3', label: 'Add Master', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F3', label: 'Add Voucher', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F5', label: 'Add Payment', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F6', label: 'Add Receipt', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F7', label: 'Add Journal', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'F8',
                        label: 'Add Sales',
                        onTap: () => context.push('/sales-order')),
                    ShortcutItem(
                        keyLabel: 'F9', label: 'Add Purchase', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'T', label: 'Trial Balance', onTap: () {}),
                    ShortcutItem(
                        keyLabel: 'S', label: 'Stock Status', onTap: () {}),
                  ],
                  onHelp: () {},
                ),
              ],
            ),
          ),

          // ── Bottom Status Bar ─────────────────────────────────────────────
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                _buildStatusItem('[ Esc - Quit ]'),
                _buildStatusItem('[ F2 - Done ]'),
                const Spacer(),
                _buildStatusItem('User : Busy'),
                const SizedBox(width: 16),
                _buildStatusItem('Country : Sri Lanka'),
                const SizedBox(width: 16),
                _buildStatusItem('Listening Port : 981'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  void _handleSave(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item Name is required!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_isModifyMode ? "Item updated" : "Item saved"}: ${_nameController.text}'),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildActionButton(String label, {VoidCallback? onPressed}) {
    return SizedBox(
      width: 80,
      height: 24,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: const BorderSide(color: Colors.grey)),
          elevation: 1,
        ),
        onPressed: onPressed ?? () {},
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildGroupBox({required String title, required Widget child}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade200),
            color: Colors.transparent,
          ),
          child: child,
        ),
        Positioned(
          left: 8,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: const Color(0xFFE3F2FD),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDenseRow(String label, TextEditingController controller,
      {bool isBold = false, double labelWidth = 100, double? width}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87),
            ),
          ),
          width != null
              ? SizedBox(width: width, child: _buildDenseInput(controller))
              : Expanded(child: _buildDenseInput(controller)),
        ],
      ),
    );
  }

  Widget _buildDenseInput(TextEditingController controller) {
    return SizedBox(
      height: 20,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1)),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label1, String label2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label1,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(label2,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, {VoidCallback? onToggle}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onToggle,
          child: Text(value ? 'Y' : 'N',
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_drop_down, size: 16),
      ],
    );
  }

  Widget _buildStatusItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
