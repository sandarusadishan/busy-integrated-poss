// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class ModifyUnitScreen extends StatefulWidget {
  const ModifyUnitScreen({super.key});

  @override
  State<ModifyUnitScreen> createState() => _ModifyUnitScreenState();
}

class _ModifyUnitScreenState extends State<ModifyUnitScreen> {
  final List<String> _items = ['Bags', 'BOTTLE', 'Gms.', 'kg', 'KGS', 'Metre', 'N.A.', 'NOS', 'Pcs.', 'Tonne'];
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
                          color: AppColors.background,
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
                                'Select Unit to Modify',
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
                                  Container(height: 20, color: Colors.black),
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
                  ShortcutPanel(items: [], onHelp: () {})
                ],
              ),
            ),
            _buildStatusBar(),
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

  Widget _buildStatusBar() {
    return Container(
      height: 24,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white, width: 2)),
        color: AppColors.primaryDark,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('[ Esc - Quit ]', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))],
      ),
    );
  }
}
