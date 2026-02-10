import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/item.dart';

class BusyStatusBar extends StatelessWidget {
  final List<Item> items;
  final bool isDark;

  const BusyStatusBar({super.key, required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        border:
            Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: Colors.white70),
              const SizedBox(width: 8),
              Text("Total Records: ${items.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Text("User: ADMIN | FY: 2026-27 | BUSY release 8.4",
              style: TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
