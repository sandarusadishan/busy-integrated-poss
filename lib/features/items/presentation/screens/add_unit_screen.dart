// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/organisms/busy_menu_header.dart';
import '../../../../core/ui/organisms/busy_keyboard_handler.dart';
import '../../../../core/ui/organisms/shortcut_panel.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/ui/organisms/responsive_wrappers.dart';

class AddUnitScreen extends StatefulWidget {
  const AddUnitScreen({super.key});

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
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
                              child: const Text('Add Unit Master',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ResponsiveFormContainer(
                            maxWidth: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  _buildFieldRow('Unit Name', isBlack: true),
                                _buildFieldRow('Alias'),
                                _buildFieldRow('Print Name'),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildButton('Save', onTap: () {}),
                                    const SizedBox(width: 8),
                                    _buildButton('Quit', onTap: () => context.pop()),
                                  ],
                                )
                              ],
                              ),
                            ),
                          ),
                        ],
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
            _buildStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, {bool isBlack = false}) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    Widget inputField = Container(
      height: 20,
      decoration: BoxDecoration(
        color: isBlack ? Colors.black : Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        style: TextStyle(fontSize: 12, color: isBlack ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4), border: InputBorder.none),
      ),
    );

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.indigo)),
            const SizedBox(height: 4),
            inputField,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.indigo))),
          Expanded(child: inputField),
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

  Widget _buildStatusBar() {
    return Container(
      height: 24,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white, width: 2)),
        color: AppColors.primaryDark,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('[ Esc - Quit ]   [ F2 - Done ]', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))],
      ),
    );
  }
}
