import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import 'package:flutter/services.dart';

class ModifyAccountScreen extends StatefulWidget {
  const ModifyAccountScreen({super.key});

  @override
  State<ModifyAccountScreen> createState() => _ModifyAccountScreenState();
}

class _ModifyAccountScreenState extends State<ModifyAccountScreen> {
  final List<String> _accounts = [
    'Advertisement & Publicity',
    'Bad Debts Written Off',
    'Bank Charges',
    'Books & Periodicals',
    'Busy Infotech Pvt. Ltd.',
    'Capital Equipments',
    'Cash',
    'Charity & Donations',
    'Commission on Sales',
    'Computers',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Custom exact color matching the screenshots
    const bgColor = Color(0xFFE3F2FD); // Light Blue 50

    return Scaffold(
        backgroundColor: bgColor,
        body: BusyKeyboardHandler(
            onEscape: () => context.pop(),
            child: Column(children: [
              // ── Main Menu Header ─────────────────────────────────────────────
              const BusyMenuHeader(),

              Container(
                height: 20,
                color: Colors.white,
                // You can add tabs logic here if needed, but keeping it empty to match standard Busy
              ),

              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Stack(children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: _buildModifyBox(),
                    )
                  ])),

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
                          keyLabel: 'F8', label: 'Add Sales', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F9', label: 'Add Purchase', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'I', label: 'Trial Balance', onTap: () {}),
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
                          keyLabel: 'G', label: 'GST Summary', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'U', label: 'Switch User', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F', label: 'Configuration', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'K', label: 'Lock Program', onTap: () {}),
                    ],
                    onHelp: () {},
                  ),
                ],
              )),

              // ── Bottom Status Bar ─────────────────────────────────────────────
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.white, width: 2)),
                  color: Color(0xFF3F51B5), // Status bar blue
                ),
                child: Row(
                  children: [
                    _buildStatusItem('[ Esc - Quit ]', Colors.white),
                    const Spacer(),
                    Container(color: Colors.white, width: 1, height: 24),
                    _buildStatusItem('F10 Calculator', Colors.black,
                        bgColor: Colors.grey.shade300),
                  ],
                ),
              ),

              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('Busy',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Savibala Hardware',
                                    style: TextStyle(fontSize: 9)),
                                Text('(Comp0001)',
                                    style: TextStyle(fontSize: 9)),
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('F.Y.       :     2026-27',
                                    style: TextStyle(fontSize: 9)),
                                Text('LST No. :',
                                    style: TextStyle(fontSize: 9)),
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User     :     Busy',
                                    style: TextStyle(fontSize: 9)),
                                Text('Country :     Sri Lanka',
                                    style: TextStyle(fontSize: 9)),
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Listening Port :     981',
                                    style: TextStyle(fontSize: 9)),
                                Text('BLS Valid Upto :',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.red)),
                              ]),
                        ])),
                    const SizedBox(width: 10),
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: const Text("Your\nCompany\nLogo",
                          style: TextStyle(
                              fontSize: 8, color: Colors.red, height: 1.0),
                          textAlign: TextAlign.center),
                    ),
                    Container(
                      width: 70,
                      alignment: Alignment.center,
                      child: const Text("Tuesday\n03-17-2026",
                          style: TextStyle(
                              fontSize: 9, color: Colors.black, height: 1.0),
                          textAlign: TextAlign.center),
                    )
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
                color: const Color(0xFF1565C0),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: const [
                  BoxShadow(color: Colors.grey, offset: Offset(1, 1))
                ]),
            child: const Text('Select Account to Modify',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          const SizedBox(height: 12),

          // Empty space input lookalike
          SizedBox(
              height: 22,
              width: 280,
              child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        setState(() {
                          _selectedIndex = (_selectedIndex + 1)
                              .clamp(0, _accounts.length - 1);
                        });
                        return KeyEventResult.handled;
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowUp) {
                        setState(() {
                          _selectedIndex = (_selectedIndex - 1)
                              .clamp(0, _accounts.length - 1);
                        });
                        return KeyEventResult.handled;
                      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                        FocusScope.of(context).nextFocus();
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
              height: 150,
              width: 280,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400)),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _accounts.length,
                  itemBuilder: (ctx, idx) {
                    bool isSelected = idx == _selectedIndex;
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = idx;
                          });
                        },
                        child: Container(
                            color: isSelected
                                ? const Color(0xFF0066CC)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(_accounts[idx],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black))));
                  })),
          const SizedBox(height: 12),

          // Buttons
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildActionButton('Select', onPressed: () {}),
            const SizedBox(width: 8),
            _buildActionButton('Quit', onPressed: () => context.pop()),
          ]),
          const SizedBox(height: 12),
        ]));
  }

  Widget _buildActionButton(String label, {VoidCallback? onPressed}) {
    return Container(
      width: 60,
      height: 22,
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1))]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: BorderSide(color: Colors.grey.shade400, width: 1),
          elevation: 0,
        ),
        onPressed: onPressed ?? () {},
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }

  Widget _buildStatusItem(String text, Color textColor, {Color? bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: bgColor ?? Colors.transparent,
      child: Text(text,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
    );
  }
}
