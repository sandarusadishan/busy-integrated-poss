import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/items_provider.dart';

class BusySearchBar extends ConsumerWidget {
  const BusySearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 250,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search items...",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (val) =>
                  ref.read(searchQueryProvider.notifier).setQuery(val),
            ),
          ),
        ],
      ),
    );
  }
}
