import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'busy_search_bar.dart';

class ItemFilterBar extends StatelessWidget {
  const ItemFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x80B0BCC8))),
      ),
      child: Row(
        children: const [
          Text("Account: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Admin", style: TextStyle(color: AppColors.primary)),
          Spacer(),
          BusySearchBar(),
        ],
      ),
    );
  }
}
