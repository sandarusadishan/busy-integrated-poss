import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:busy_items_app/features/shared/providers/search_provider.dart';
import 'package:busy_items_app/features/items/data/models/item.dart';

import 'pos_item_card.dart';

class POSItemsGrid extends ConsumerWidget {
  final void Function(Item item) onItemTap;

  const POSItemsGrid({
    super.key,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredItems = ref.watch(filteredItemsProvider);

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No items found', style: TextStyle(fontSize: 18, color: Colors.grey)),
            TextButton(
              onPressed: () {
                ref.read(sharedSearchQueryProvider.notifier).clearQuery();
              },
              child: const Text('Clear Search'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        childAspectRatio: 100 / 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return POSItemCard(
          item: item,
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}
