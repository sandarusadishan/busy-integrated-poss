import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class AddAccountGroupScreen extends StatefulWidget {
  const AddAccountGroupScreen({super.key});

  @override
  State<AddAccountGroupScreen> createState() => _AddAccountGroupScreenState();
}

class _AddAccountGroupScreenState extends State<AddAccountGroupScreen> {
  final _groupController = TextEditingController();
  final _aliasController = TextEditingController();
  final _primaryGroupController = TextEditingController(text: 'N');
  final _underGroupController = TextEditingController();

  final List<String> _underGroups = [
    'Expenses (Direct/Mfg.)',
    'Expenses (Indirect/Admn.)',
    'Income (Direct/Opr.)',
    'Income (Indirect)',
    'Investments'
  ];
  bool _showUnderGroupDropdown = false;
  int _selectedGroupIndex = 0;
  final FocusNode _underGroupFocus = FocusNode();

  @override
  void dispose() {
    _groupController.dispose();
    _aliasController.dispose();
    _primaryGroupController.dispose();
    _underGroupController.dispose();
    _underGroupFocus.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Show saving msg
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Saving Account Group...'),
          duration: Duration(seconds: 1)),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFE3F2FD); // Light Blue 50
    const formBgColor = Color(0xFFE3F2FD); //
    const titleBoxColor = Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      body: BusyKeyboardHandler(
        onEscape: () => context.pop(),
        onF2: () => _handleSave(),
        child: Column(
          children: [
            const BusyMenuHeader(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 500,
                            height: 350,
                            decoration: BoxDecoration(
                                color: formBgColor,
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey, offset: Offset(2, 2)),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Title bar
                                Container(
                                  width: 250,
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: titleBoxColor, // Blue title
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(1, 1))
                                      ]),
                                  child: const Text(
                                    'Add Account Group Master',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),

                                // Fields
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      _buildFieldRow('Group', _groupController,
                                          width: 200),
                                      const SizedBox(height: 12),
                                      _buildFieldRow('Alias', _aliasController,
                                          width: 200),
                                      const SizedBox(height: 12),
                                      _buildToggleRow('Primary Group (Y/N)',
                                          _primaryGroupController,
                                          width: 40),
                                      const SizedBox(height: 12),
                                      _buildUnderGroupField(),
                                    ],
                                  ),
                                ),

                                const Spacer(),
                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildButton('Save', _handleSave),
                                    const SizedBox(width: 8),
                                    _buildButton('Quit', () => context.pop()),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Shortcut Sidebar
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
                          keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'T', label: 'Trial Balance', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'S', label: 'Stock Status', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'A', label: 'Acc. Summary', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'L', label: 'Acc. Ledger', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'I', label: 'Item Summary', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'D', label: 'Item Ledger', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'U', label: 'Switch User', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'E', label: 'Configuration', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'K', label: 'Lock Program', onTap: () {}),
                    ],
                    onHelp: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller,
      {double width = 150}) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ),
        SizedBox(
          width: width,
          height: 20,
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnderGroupField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 150,
          child: Text('Under Group',
              style: TextStyle(fontSize: 12, color: Colors.black87)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              height: 20,
              child: Focus(
                focusNode: _underGroupFocus,
                onFocusChange: (hasFocus) {
                  setState(() => _showUnderGroupDropdown = hasFocus);
                },
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      setState(() {
                        _showUnderGroupDropdown = true;
                        _selectedGroupIndex = (_selectedGroupIndex + 1)
                            .clamp(0, _underGroups.length - 1);
                        _underGroupController.text =
                            _underGroups[_selectedGroupIndex];
                      });
                      return KeyEventResult.handled;
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      setState(() {
                        _showUnderGroupDropdown = true;
                        _selectedGroupIndex = (_selectedGroupIndex - 1)
                            .clamp(0, _underGroups.length - 1);
                        _underGroupController.text =
                            _underGroups[_selectedGroupIndex];
                      });
                      return KeyEventResult.handled;
                    }
                    if (event.logicalKey == LogicalKeyboardKey.enter) {
                      setState(() => _showUnderGroupDropdown = false);
                      FocusScope.of(context).nextFocus();
                      return KeyEventResult.handled;
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: _underGroupController,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) =>
                      setState(() => _showUnderGroupDropdown = true),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (_showUnderGroupDropdown)
              Container(
                width: 250,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _underGroups.length,
                  itemBuilder: (context, index) {
                    final item = _underGroups[index];
                    final isSelected = index == _selectedGroupIndex;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedGroupIndex = index;
                          _underGroupController.text = item;
                          _showUnderGroupDropdown = false;
                        });
                        FocusScope.of(context).nextFocus();
                      },
                      child: Container(
                        color: isSelected
                            ? const Color(0xFF0078D7)
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(item,
                            style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            border: Border.all(color: Colors.grey),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(1, 1))
            ]),
        child: Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black)),
      ),
    );
  }

  Widget _buildToggleRow(String label, TextEditingController controller,
      {double width = 150}) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ),
        SizedBox(
          width: width,
          height: 20,
          child: Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.space) {
                setState(() {
                  controller.text = controller.text == 'Y' ? 'N' : 'Y';
                });
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              readOnly: true, // User only toggles with space
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
