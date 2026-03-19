// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class ModifyReceiptScreen extends StatefulWidget {
  const ModifyReceiptScreen({super.key});

  @override
  State<ModifyReceiptScreen> createState() => _ModifyReceiptScreenState();
}

class _ModifyReceiptScreenState extends State<ModifyReceiptScreen> {
  final TextEditingController _seriesController =
      TextEditingController(text: 'Main');
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(text: '19-03-2026');

  bool _isSeriesFocused = true;

  @override
  void dispose() {
    _seriesController.dispose();
    _noController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor =
        Color(0xFFF0F0F0); // slightly gray-cyan background matching "modify"

    return Scaffold(
      backgroundColor: bgColor,
      body: BusyKeyboardHandler(
        onEscape: () => context.pop(),
        child: Column(
          children: [
            const BusyMenuHeader(),
            Expanded(
              child: Row(
                children: [
                  // Main Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 350,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                border: Border.all(
                                    color: Colors.blue.shade900, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Select Voucher To Modify ( Receipt )',
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      children: [
                                        _buildRow(
                                            'Voucher Series', _seriesController,
                                            isFocused: _isSeriesFocused),
                                        const SizedBox(height: 8),
                                        _buildRow('Voucher No.', _noController),
                                        const SizedBox(height: 8),
                                        _buildRow(
                                            'Voucher Date', _dateController),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to actual modify screen or load data
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Loading voucher...')));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0E0E0),
                                          border:
                                              Border.all(color: Colors.grey),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(1, 1))
                                          ],
                                        ),
                                        child: const Text('OK',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),

                          // Dropdown overlay simulation (since "Main" is selected in image)
                          if (_isSeriesFocused)
                            Positioned(
                              top:
                                  60, // approximate position below the series text field
                              left:
                                  110, // approximate left matching the text field
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: const Text('Main',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      color: Colors.blue.shade600,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: const Text('Main',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),

                  // Sidebar
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
                          keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
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
                border: Border(top: BorderSide(color: Colors.white, width: 2)),
                color: Color(0xFF3F51B5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('[ Esc - Quit ]   [ F2 - Done ]',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, TextEditingController controller,
      {bool isFocused = false}) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.brown)),
        ),
        Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: isFocused ? Colors.blue : Colors.grey),
          ),
          child: Focus(
            onFocusChange: (f) => setState(
                () => _isSeriesFocused = (f && label == 'Voucher Series')),
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
        ),
      ],
    );
  }
}
