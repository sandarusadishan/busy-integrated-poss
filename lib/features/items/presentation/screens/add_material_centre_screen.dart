// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';

class AddMaterialCentreScreen extends StatefulWidget {
  const AddMaterialCentreScreen({super.key});

  @override
  State<AddMaterialCentreScreen> createState() => _AddMaterialCentreScreenState();
}

class _AddMaterialCentreScreenState extends State<AddMaterialCentreScreen> {
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD25252),
                                border: Border.all(color: Colors.white, width: 1),
                                boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(1, 1))],
                              ),
                              child: const Text(
                                'Add Material Centre Master',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 500,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Column(
                              children: [
                                _buildFieldSet('General Info', Column(
                                  children: [
                                    _buildFieldRow('Name', isBlack: true),
                                    _buildFieldRow('Alias'),
                                    _buildFieldRow('Print Name'),
                                    _buildFieldRow('Group'),
                                    _buildFieldRow('Stock Account'),
                                    _buildToggleRow('Reflect the stock in Balance Sheet ?', 'Y'),
                                    _buildFieldRow('Sales Account'),
                                    _buildFieldRow('Purc. Account'),
                                    _buildFieldRow('Accounting in Stock Transfer'),
                                  ],
                                )),
                                const SizedBox(height: 8),
                                _buildFieldSet('Address Info', Column(
                                  children: [
                                    _buildFieldRow('Address', height: 100),
                                  ],
                                )),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      _buildButton('Opt. Fields'),
                                      const Spacer(),
                                      _buildButton('Save', onTap: () {}),
                                      const SizedBox(width: 8),
                                      _buildButton('Quit', onTap: () => context.pop()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ShortcutPanel(
                    items: [
                      ShortcutItem(keyLabel: 'F1', label: 'Help', onTap: () {}),
                      ShortcutItem(keyLabel: 'F1', label: 'Add Account', onTap: () {}),
                      ShortcutItem(keyLabel: 'F2', label: 'Add Item', onTap: () {}),
                      ShortcutItem(keyLabel: 'F3', label: 'Add Master', onTap: () {}),
                      ShortcutItem(keyLabel: 'B', label: 'Balance Sheet', onTap: () {}),
                    ],
                    onHelp: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: 24,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white, width: 2)),
                color: AppColors.primaryDark, // Status bar matching theme
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('[ Esc - Quit ]   [ F2 - Done ]',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldSet(String title, Widget child) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
          Positioned(
            left: 8,
            top: -8,
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(title, style: const TextStyle(fontSize: 11, color: AppColors.primaryDark)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, {bool isBlack = false, double? height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.indigo))),
          Expanded(
            child: Container(
              height: height ?? 20,
              decoration: BoxDecoration(
                color: isBlack ? Colors.black : Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                style: TextStyle(fontSize: 12, color: isBlack ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                maxLines: height != null ? null : 1,
                decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4), border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          SizedBox(width: 250, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.indigo))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
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
