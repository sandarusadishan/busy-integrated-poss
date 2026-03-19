// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class AddReceiptScreen extends StatefulWidget {
  const AddReceiptScreen({super.key});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  final int _rowCount = 17;

  @override
  Widget build(BuildContext context) {
    // Pale cyan-green background matching receipt voucher image
    const bgColor = Color(0xFFE0F7FA);

    return Scaffold(
        backgroundColor: bgColor,
        body: BusyKeyboardHandler(
          onEscape: () => context.pop(),
          child: Column(
            children: [
              const BusyMenuHeader(),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // Title
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFD25252), // Red title
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey, offset: Offset(1, 1))
                                ]),
                            child: const Text(
                              'Add Receipt Voucher',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Top Controls
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                _buildTopField('Voucher Series', 'Main',
                                    width: 100),
                                const SizedBox(width: 20),
                                _buildTopField('Date', '01-04-2025', width: 90),
                                const SizedBox(width: 20),
                                _buildTopField('Vch No.', '', width: 80),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Table and right panel area
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Table
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: Column(
                                            children: [
                                              // Header
                                              Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    _buildColHeader('S.No',
                                                        width: 30),
                                                    _buildColHeader('D/C',
                                                        width: 30),
                                                    _buildColHeader('Account',
                                                        flex: 2),
                                                    _buildColHeader(
                                                        'Debit (Rs.)',
                                                        flex: 1,
                                                        isCenter: true),
                                                    _buildColHeader(
                                                        'Credit (Rs.)',
                                                        flex: 1,
                                                        isCenter: true),
                                                    _buildColHeader(
                                                        'Short Narration',
                                                        flex: 2),
                                                  ],
                                                ),
                                              ),
                                              // Rows
                                              SizedBox(
                                                height:
                                                    300, // Fixed height or auto expanding
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: _rowCount,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.5)),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          _buildCell(
                                                              '${index + 1}',
                                                              width: 30,
                                                              isCenter: true,
                                                              bg: Colors.grey
                                                                  .shade200),
                                                          _buildInputCell(
                                                              width: 30),
                                                          _buildInputCell(
                                                              flex: 2,
                                                              isBlackFocus: index ==
                                                                  0), // highlight first line account
                                                          _buildInputCell(
                                                              flex: 1),
                                                          _buildInputCell(
                                                              flex: 1),
                                                          _buildInputCell(
                                                              flex: 2),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              // Footer
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4),
                                                color: bgColor,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            60), // Sno + D/c spacer
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container()),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text("0.00",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12))),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text("0.00",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12))),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container()),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Voucher Info Right Pane
                                  Expanded(
                                    flex: 1,
                                    child: _buildFieldSet(
                                        'Voucher Info.',
                                        Container(
                                          height: 300,
                                          color: Colors.white,
                                        ),
                                        width: double.infinity,
                                        padding: EdgeInsets.zero),
                                  )
                                ],
                              ),
                            ),
                          ),

                          // Long Narration
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildFieldSet(
                                'Long Narration',
                                Container(
                                    height: 30,
                                    color: Colors.white,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 4)),
                                      style: TextStyle(fontSize: 12),
                                    )),
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 4, right: 4, top: 4, bottom: 4)),
                          ),
                          const SizedBox(height: 10),

                          // Bottom Controls
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                _buildButton('Vch. Other Detail'),
                                const SizedBox(width: 4),
                                _buildButton('Master Other Detail'),
                                const SizedBox(width: 4),
                                _buildButton('Party Dash Board'),
                                const SizedBox(width: 4),
                                _buildButton('VCH\nIMAGE', isSmall: true),
                                const SizedBox(width: 4),
                                _buildButton('ACC\nIMAGE', isSmall: true),
                                const Spacer(),
                                _buildButton('Save', onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Saving...')));
                                }),
                                const SizedBox(width: 16),
                                _buildButton('Quit',
                                    onTap: () => context.pop()),
                                const SizedBox(
                                    width:
                                        50), // Spacer relative to Voucher info pane
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    // Sidebar
                    ShortcutPanel(
                      items: [
                        ShortcutItem(
                            keyLabel: 'F1', label: 'Help', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F1', label: 'Add Account', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F2', label: 'Add Item', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F3', label: 'Add Master', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F5', label: 'Add Payment', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F6', label: 'Add Receipt', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F7', label: 'Add Journal', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F8', label: 'Add Sales', onTap: () {}),
                        ShortcutItem(
                            keyLabel: 'F9',
                            label: 'Add Purchase',
                            onTap: () {}),
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

              // Status Bar
              Container(
                height: 24,
                decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.white, width: 2)),
                  color:
                      Color(0xFF4A8CA6), // Status bar somewhat turquoise/blue
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        '[ Esc - Quit ]   [ F2 - Done ]   [ F4 - Std.Nar. ]   [ F6 - Vch.Type ]   [ F7 - Repeat ]   [ F9 - Del. Line ]',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTopField(String label, String initialValue,
      {double width = 100}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A6A6A))),
        Container(
          width: width,
          height: 20,
          color: Colors.white,
          child: TextField(
            controller: TextEditingController(text: initialValue),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              border: OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButton(String label,
      {VoidCallback? onTap, bool isSmall = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            border: Border.all(color: Colors.grey),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(1, 1))
            ]),
        alignment: Alignment.center,
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: isSmall ? 9 : 11,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }

  Widget _buildFieldSet(String title, Widget child,
      {double? width, EdgeInsetsGeometry? padding}) {
    return Container(
      width: width,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: child,
          ),
          Positioned(
            left: 8,
            top: -8,
            child: Container(
              color: const Color(0xFFE0F7FA), // match background
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF8B008B))), // purplish
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColHeader(String text,
      {double? width, int? flex, bool isCenter = false}) {
    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.black, width: 0.5)),
      ),
      alignment: isCenter ? Alignment.center : Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );

    if (flex != null) return Expanded(flex: flex, child: child);
    return SizedBox(width: width, child: child);
  }

  Widget _buildCell(String text,
      {double? width, int? flex, bool isCenter = false, Color? bg}) {
    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: const Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      alignment: isCenter ? Alignment.center : Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );

    if (flex != null) return Expanded(flex: flex, child: child);
    return SizedBox(width: width, child: child);
  }

  Widget _buildInputCell(
      {double? width, int? flex, bool isBlackFocus = false}) {
    Widget child = Container(
      height: 20,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: TextField(
        style: TextStyle(
            fontSize: 12,
            color: isBlackFocus ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          filled: isBlackFocus,
          fillColor: isBlackFocus ? Colors.black : Colors.transparent,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
    );

    if (flex != null) return Expanded(flex: flex, child: child);
    return SizedBox(width: width, child: child);
  }
}
