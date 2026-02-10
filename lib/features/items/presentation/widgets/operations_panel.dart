import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OperationsPanel extends StatelessWidget {
  final bool isDark;
  final VoidCallback onAddItem;
  final VoidCallback onAddGroup;

  const OperationsPanel({
    super.key,
    required this.isDark,
    required this.onAddItem,
    required this.onAddGroup,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.panelBg,
        border: Border(
            left: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5))),
            ),
            child: Row(
              children: [
                const Icon(Icons.settings, size: 20, color: AppColors.accent),
                const SizedBox(width: 8),
                Text('Operations Panel',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _panelButton(
                    'Add Item', 'F2', Icons.add_box_outlined, onAddItem),
                _panelButton('Add Group', 'F3', Icons.folder_open, onAddGroup),
                const Divider(),
                _panelButton('Modify', 'Ent', Icons.edit_outlined, () {}),
                _panelButton('Delete', 'F8', Icons.delete_outline, () {}),
                _panelButton('List', 'F5', Icons.list_alt, () {}),
                const Divider(),
                _panelButton('Print', 'Alt+P', Icons.print_outlined, () {}),
                _panelButton('Email', 'Ctrl+E', Icons.email_outlined, () {}),
                _panelButton(
                    'Export', 'Alt+E', Icons.file_download_outlined, () {}),
                const Divider(),
                _panelButton('Quit', 'Esc', Icons.exit_to_app, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelButton(
      String label, String shortcut, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.centerLeft,
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryLight),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: Text(shortcut,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
