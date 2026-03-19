import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class AccountGroup {
  final String name;
  final String primary;
  final String underGroup;

  const AccountGroup(this.name, this.primary, this.underGroup);
}

class ListAccountGroupScreen extends StatefulWidget {
  const ListAccountGroupScreen({super.key});

  @override
  State<ListAccountGroupScreen> createState() => _ListAccountGroupScreenState();
}

class _ListAccountGroupScreenState extends State<ListAccountGroupScreen> {
  final List<AccountGroup> _groups = [
    const AccountGroup('Bank Accounts', 'N', 'Current Assets'),
    const AccountGroup('Bank O/D Account', 'N', 'Loans (Liability)'),
    const AccountGroup('Capital Account', 'Y', ''),
    const AccountGroup('Cash-in-hand', 'N', 'Current Assets'),
    const AccountGroup('Current Assets', 'Y', ''),
    const AccountGroup('Current Liabilities', 'Y', ''),
    const AccountGroup('Duties & Taxes', 'N', 'Current Liabilities'),
    const AccountGroup('Expenses (Direct/Mfg.)', 'N', 'Revenue Accounts'),
    const AccountGroup('Expenses (Indirect/Admn.)', 'N', 'Revenue Accounts'),
    const AccountGroup('Fixed Assets', 'Y', ''),
    const AccountGroup('Income (Direct/Opr.)', 'N', 'Revenue Accounts'),
    const AccountGroup('Income (Indirect)', 'N', 'Revenue Accounts'),
    const AccountGroup('Investments', 'Y', ''),
    const AccountGroup('Loans & Advances (Asset)', 'N', 'Current Assets'),
    const AccountGroup('Loans (Liability)', 'Y', ''),
    const AccountGroup('Pre-Operative Expenses', 'Y', ''),
    const AccountGroup('Profit & Loss', 'Y', ''),
    const AccountGroup(
        'Provisions/Expenses Payable', 'N', 'Current Liabilities'),
    const AccountGroup('Purchase', 'N', 'Revenue Accounts'),
    const AccountGroup('Reserves & Surplus', 'N', 'Capital Account'),
    const AccountGroup('Revenue Accounts', 'Y', ''),
    const AccountGroup('Sale', 'N', 'Revenue Accounts'),
    const AccountGroup('Secured Loans', 'N', 'Loans (Liability)'),
  ];

  int _selectedIndex = 0;
  final FocusNode _listFocusNode = FocusNode();

  @override
  void dispose() {
    _listFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFE3F2FD);

    return Scaffold(
        backgroundColor: bgColor,
        body: BusyKeyboardHandler(
          onEscape: () => context.pop(),
          child: Column(
            children: [
              const BusyMenuHeader(),

              // Top Toolbar placeholder
              Container(
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF3F51B5), // status bar color basically
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Email - [M] | Print - [P] | Refresh - [R] | Export - [E] | Search - F3',
                        style: TextStyle(color: Colors.white, fontSize: 10))
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Focus(
                        focusNode: _listFocusNode,
                        autofocus: true,
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowDown ||
                                event.logicalKey == LogicalKeyboardKey.enter) {
                              setState(() {
                                _selectedIndex = (_selectedIndex + 1)
                                    .clamp(0, _groups.length - 1);
                              });
                              return KeyEventResult.handled;
                            }
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowUp) {
                              setState(() {
                                _selectedIndex = (_selectedIndex - 1)
                                    .clamp(0, _groups.length - 1);
                              });
                              return KeyEventResult.handled;
                            }
                          }
                          return KeyEventResult.ignored;
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // Title
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(1, 1))
                                  ]),
                              child: const Text(
                                'List of Account Groups',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Table Header
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 2))),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2, child: _buildColHeader('Name')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildColHeader('Primary',
                                          center: true)),
                                  Expanded(
                                      flex: 2,
                                      child: _buildColHeader('Under Group')),
                                ],
                              ),
                            ),

                            // Table Body
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.white,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: _groups.length,
                                  itemBuilder: (context, index) {
                                    final group = _groups[index];
                                    final isSelected = index == _selectedIndex;

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = index;
                                        });
                                        _listFocusNode.requestFocus();
                                      },
                                      child: Container(
                                        color: isSelected
                                            ? const Color(0xFF0078D7)
                                            : Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(group.name,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(group.primary,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(group.underGroup,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // Sidebar Focus
                    ShortcutPanel(
                      items: [
                        ShortcutItem(
                            keyLabel: 'F1', label: 'Help', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F1', label: 'Add Account', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F2', label: 'Add Item', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'B',
                            label: 'Balance Sheet',
                            onTap: () {}),
                      ],
                      onHelp: () {},
                    )
                  ],
                ),
              ),

              // Footer
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
                    const Text('Row No : 1 / 29',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: const Text('[ F8 - Delete ]  [ F9 - Hide ]',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildColHeader(String text, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(text,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Colors.black87)),
    );
  }
}
