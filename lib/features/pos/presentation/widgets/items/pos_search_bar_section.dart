import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:busy_items_app/core/constants/app_colors.dart';
import 'package:busy_items_app/features/shared/providers/search_provider.dart';
import 'package:busy_items_app/features/shared/widgets/shared_search_bar.dart';
import 'package:busy_items_app/features/items/data/models/item.dart';

class POSSearchBarSection extends ConsumerWidget {
  final void Function(Item item) onItemSelected;

  const POSSearchBarSection({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            child: SharedSearchBar(
              hintText: "Search items to add to cart...",
              width: double.infinity,
              showDropdown: true,
              onItemSelected: onItemSelected,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: View all items
              ref.read(sharedSearchQueryProvider.notifier).clearQuery();
            },
            icon: const Icon(Icons.list),
            label: const Text('View All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
