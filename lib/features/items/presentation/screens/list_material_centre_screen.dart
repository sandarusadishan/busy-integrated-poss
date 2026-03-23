// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class ListMaterialCentreScreen extends StatefulWidget {
  const ListMaterialCentreScreen({super.key});

  @override
  State<ListMaterialCentreScreen> createState() => _ListMaterialCentreScreenState();
}

class _ListMaterialCentreScreenState extends State<ListMaterialCentreScreen> {
  final List<Map<String, String>> _items = [
    {'name': 'Godowns', 'primary': 'Y', 'group': ''},
    {'name': 'Production Floors', 'primary': 'Y', 'group': ''},
    {'name': 'Stores', 'primary': 'Y', 'group': ''},
  ];
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD25252),
                              boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1))],
                            ),
                            child: const Text('List of Material Centre Groups',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey)),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                                    child: Row(
                                      children: [
                                        _buildColHeader('Name', flex: 3),
                                        _buildColHeader('Primary', flex: 1),
                                        _buildColHeader('Under Group', flex: 2),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _items.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final item = _items[index];
                                        final isSelected = index == _selectedIndex;
                                        return InkWell(
                                          onTap: () => setState(() => _selectedIndex = index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                                              border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                                            ),
                                            child: Row(
                                              children: [
                                                _buildCell(item['name']!, flex: 3, isSelected: isSelected),
                                                _buildCell(item['primary']!, flex: 1, isCenter: true, isSelected: isSelected),
                                                _buildCell(item['group']!, flex: 2, isSelected: isSelected),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
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
                children: [
                  Text('[ F8 - Delete ]   [ F9 - Hide ]',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColHeader(String text, {int? flex}) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black, width: 0.5))),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildCell(String text, {int? flex, bool isCenter = false, bool isSelected = false}) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        alignment: isCenter ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 0.5))),
        child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }
}
