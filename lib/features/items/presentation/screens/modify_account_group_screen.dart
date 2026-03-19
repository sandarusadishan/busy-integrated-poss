import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class ModifyAccountGroupScreen extends StatefulWidget {
  const ModifyAccountGroupScreen({super.key});

  @override
  State<ModifyAccountGroupScreen> createState() =>
      _ModifyAccountGroupScreenState();
}

class _ModifyAccountGroupScreenState extends State<ModifyAccountGroupScreen> {
  final List<String> _accountGroups = [
    'Bank Accounts',
    'Bank O/D Account',
    'Capital Account',
    'Cash-in-hand',
    'Current Assets',
    'Current Liabilities',
    'Duties & Taxes',
    'Expenses (Direct/Mfg.)',
    'Expenses (Indirect/Admn.)',
    'Fixed Assets',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFE3F2FD); // Light Blue 50

    return Scaffold(
        backgroundColor: bgColor,
        body: BusyKeyboardHandler(
            onEscape: () => context.pop(),
            child: Column(children: [
              // Menu
              const BusyMenuHeader(),

              Container(height: 20, color: Colors.white),

              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Stack(children: [
                    Positioned(left: 20, top: 20, child: _buildModifyBox())
                  ])),

                  // Shortcuts
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
              )),

              // Footer (omitted full status bar for brevity, keeping simple one)
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.white, width: 2)),
                  color: Color(0xFF3F51B5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: const Text('[ Esc - Quit ]',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ])));
  }

  Widget _buildModifyBox() {
    return Container(
        width: 320,
        decoration: BoxDecoration(
            color: const Color(0xFFF0EBEB), // slightly purple-grey
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(3, 3))
            ]),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
            decoration: BoxDecoration(
                color: const Color(0xFF1565C0), // Blue title
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: const [
                  BoxShadow(color: Colors.grey, offset: Offset(1, 1))
                ]),
            child: const Text('Select Group to Modify',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(height: 12),

          // Search Box / Arrow handling
          SizedBox(
              height: 22,
              width: 280,
              child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        setState(() {
                          _selectedIndex = (_selectedIndex + 1)
                              .clamp(0, _accountGroups.length - 1);
                        });
                        return KeyEventResult.handled;
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowUp) {
                        setState(() {
                          _selectedIndex = (_selectedIndex - 1)
                              .clamp(0, _accountGroups.length - 1);
                        });
                        return KeyEventResult.handled;
                      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                        // Enter should behave like clicking "Select"
                        return KeyEventResult.handled;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: const TextField(
                    autofocus: true,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ))),

          // Black bar
          Container(
            height: 10,
            width: 280,
            color: const Color(0xFF404040),
            margin: const EdgeInsets.symmetric(vertical: 2),
          ),

          // List items
          Container(
            width: 280,
            height: 180,
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.black)),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _accountGroups.length,
              itemBuilder: (context, index) {
                final item = _accountGroups[index];
                final isSelected = index == _selectedIndex;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                  },
                  child: Container(
                    color: isSelected
                        ? const Color(0xFF0078D7) // Windows Blue selection
                        : Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton('Select', () {}),
              const SizedBox(width: 8),
              _buildButton('Quit', () {
                context.pop();
              }),
            ],
          ),
          const SizedBox(height: 16),
        ]));
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 22,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF0F0F0),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: Colors.grey)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }
}
