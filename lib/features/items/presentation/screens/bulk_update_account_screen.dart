// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class BulkUpdateAccountScreen extends StatefulWidget {
  const BulkUpdateAccountScreen({super.key});

  @override
  State<BulkUpdateAccountScreen> createState() =>
      _BulkUpdateAccountScreenState();
}

class _BulkUpdateAccountScreenState extends State<BulkUpdateAccountScreen> {
  int _basisMode = 0; // 0 = Add New Master, 1 = Modify Existing Master
  final int _rowCount = 15;

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFECEDF5);

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
                                color: const Color(0xFFD25252), // Red title matching UI
                                border: Border.all(color: Colors.white, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey, offset: Offset(1, 1))
                                ]),
                            child: const Text(
                              'Multiple Account Master Creation/Modification',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Top Controls
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                _buildFieldSet(
                                  'Specify Master Creation/Updation Basis',
                                  Row(
                                    children: [
                                      Radio(
                                        value: 0,
                                        groupValue: _basisMode,
                                        onChanged: (v) => setState(
                                            () => _basisMode = v as int),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      const Text('Add New Master',
                                          style: TextStyle(fontSize: 12)),
                                      const SizedBox(width: 16),
                                      Radio(
                                        value: 1,
                                        groupValue: _basisMode,
                                        onChanged: (v) => setState(
                                            () => _basisMode = v as int),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      const Text('Modify Existing Master',
                                          style: TextStyle(fontSize: 12)),
                                      const SizedBox(width: 16),
                                      const Text('Key Field',
                                          style: TextStyle(fontSize: 12)),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 100,
                                        height: 20,
                                        color: Colors.white,
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                _buildButton('Select Fields'),
                                const SizedBox(width: 8),
                                _buildButton('Load Masters'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Table
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  // Header
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    child: Row(
                                      children: [
                                        _buildColHeader('S.No', width: 40),
                                        _buildColHeader('Name', flex: 4),
                                        _buildColHeader('Alias', flex: 2),
                                        _buildColHeader('Group Name', flex: 3),
                                        _buildColHeader('Opening Bal.', flex: 2),
                                        _buildColHeader('Prev. Bal', flex: 2),
                                        Expanded(flex: 4, child: const SizedBox()), // Empty space
                                      ],
                                    ),
                                  ),
                                  // Rows
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: _rowCount,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5)),
                                          ),
                                          child: Row(
                                            children: [
                                              _buildCell('${index + 1}',
                                                  width: 40,
                                                  isCenter: true,
                                                  bg: const Color(0xFFF0F0F0)),
                                              _buildInputCell(
                                                  flex: 4,
                                                  isBlackFocus: index == 0),
                                              _buildInputCell(flex: 2),
                                              _buildInputCell(flex: 3),
                                              _buildInputCell(flex: 2),
                                              _buildInputCell(flex: 2),
                                              Expanded(flex: 4, child: const SizedBox()), // Empty space
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Bottom Controls
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldSet(
                                    'Specify Default Values For New Masters',
                                    const Row(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            child: Text('Parent Group',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF8B8B8B)))),
                                        SizedBox(width: 10),
                                        SizedBox(
                                            width: 100,
                                            child: Text('Master Series Group',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF8B8B8B)))),
                                      ],
                                    ),
                                    width: double.infinity),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                          value: false, onChanged: null),
                                    ),
                                    const Text(
                                        'Overwrite Existing Account Category',
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildButton('Add Rows'),
                                    const SizedBox(width: 8),
                                    _buildButton('Delete Rows'),
                                    const SizedBox(width: 8),
                                    _buildButton('Clear All'),
                                    const Spacer(),
                                    _buildButton('Save', onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Saving...')));
                                    }),
                                    const SizedBox(width: 8),
                                    _buildButton('Quit',
                                        onTap: () => context.pop()),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
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
                  color: Color(0xFF3F51B5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        '[ Esc - Quit ]   [ F2 - Done ]   [ F9 - Del. Line ]',
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

  Widget _buildButton(String label, {VoidCallback? onTap}) {
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
        child: Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }

  Widget _buildFieldSet(String title, Widget child, {double? width}) {
    return Container(
      width: width,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: child,
          ),
          Positioned(
            left: 8,
            top: -8,
            child: Container(
              color: const Color(0xFFF0F0F0), // same as bg
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8B008B))), // purplish title
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColHeader(String text, {double? width, int? flex}) {
    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.black, width: 0.5)),
      ),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );

    if (flex != null) {
      return Expanded(flex: flex, child: child);
    } else {
      return SizedBox(width: width, child: child);
    }
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

    if (flex != null) {
      return Expanded(flex: flex, child: child);
    } else {
      return SizedBox(width: width, child: child);
    }
  }

  Widget _buildInputCell({int? flex, bool isBlackFocus = false}) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
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
      ),
    );
  }
}
