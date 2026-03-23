// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class ModifyMaterialCentreScreen extends StatefulWidget {
  const ModifyMaterialCentreScreen({super.key});

  @override
  State<ModifyMaterialCentreScreen> createState() => _ModifyMaterialCentreScreenState();
}

class _ModifyMaterialCentreScreenState extends State<ModifyMaterialCentreScreen> {
  final List<String> _items = ['Main Store', 'RSV SHOP', 'STORE', 'THAWA ANNA SHOP', 'THAWA ANNA STORE', 'TT'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.background;

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
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          border: Border.all(color: Colors.blue.shade900, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 2))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.center,
                              child: const Text(
                                'Select Material Centre to Modify',
                                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 13, decoration: TextDecoration.underline),
                              ),
                            ),
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
                              child: Column(
                                children: [
                                  Container(height: 20, color: Colors.black), // Search bar simulation
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _items.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final isSelected = index == _selectedIndex;
                                        return InkWell(
                                          onTap: () => setState(() => _selectedIndex = index),
                                          child: Container(
                                            color: isSelected ? Colors.blue.shade700 : Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            child: Text(_items[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildButton('Select'),
                                  const SizedBox(width: 8),
                                  _buildButton('Quit', onTap: () => context.pop()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ShortcutPanel(
                    items: [
                      ShortcutItem(keyLabel: 'F1', label: 'Help', onTap: () {}),
                      ShortcutItem(keyLabel: 'F2', label: 'Add Item', onTap: () {}),
                      ShortcutItem(keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
                    ],
                    onHelp: () {},
                  )
                ],
              ),
            ),
            Container(
              height: 24,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white, width: 2)),
                color: Color(0xFF3F51B5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('[ Esc - Quit ]', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          border: Border.all(color: Colors.grey),
          boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(1, 1))],
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}
