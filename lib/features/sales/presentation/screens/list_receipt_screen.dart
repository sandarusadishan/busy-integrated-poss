// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';

class ListReceiptScreen extends StatefulWidget {
  const ListReceiptScreen({super.key});

  @override
  State<ListReceiptScreen> createState() => _ListReceiptScreenState();
}

class _ListReceiptScreenState extends State<ListReceiptScreen> {
  final TextEditingController _startController =
      TextEditingController(text: '01-04-2025');
  final TextEditingController _endController =
      TextEditingController(text: '25-09-2025');

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF0F0F0);

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
                              width: 380,
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
                                    color: const Color(0xFFD25252),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'List of Receipt Vouchers',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      children: [
                                        _buildTextRow(
                                            'Select Voucher Series Group',
                                            '<<-ALL->>'),
                                        const SizedBox(height: 12),
                                        _buildTextRow(
                                            'Voucher Series', '<<-ALL->>'),
                                        const SizedBox(height: 12),
                                        _buildInputRow(
                                            'Starting Date', _startController),
                                        const SizedBox(height: 8),
                                        _buildInputRow(
                                            'Ending Date', _endController),
                                        const SizedBox(height: 8),
                                        _buildTextRow(
                                            'Account to be shown by', 'Name'),
                                        const SizedBox(height: 12),
                                        _buildTextRow(
                                            'Show Mobile No. of Parties ?',
                                            'N'),
                                        const SizedBox(height: 12),
                                        _buildTextRow(
                                            'Show Short Narration', 'N'),
                                        const SizedBox(height: 12),
                                        _buildTextRow(
                                            'Show Report Notes in Column ?',
                                            'N'),
                                        const SizedBox(height: 30),
                                      ],
                                    ),
                                  ),

                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Loading list...')));
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
                                        child: const Text('OK (F2)',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
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
                          keyLabel: 'F5', label: 'Add Payment', onTap: () {}),
                      ShortcutItem(
                          keyLabel: 'F6', label: 'Add Receipt', onTap: () {}),
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

  Widget _buildTextRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.brown)),
        ),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.brown)),
        ),
        Container(
          width: 90,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black, // Active focus like in the image
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              border: InputBorder.none,
            ),
            autofocus: label.contains('Starting Date'), // Focus first input
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
        ),
      ],
    );
  }
}
