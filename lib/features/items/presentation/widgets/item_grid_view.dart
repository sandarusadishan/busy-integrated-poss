import 'package:flutter/material.dart';
import '../../data/models/item.dart';
import 'item_card.dart';

class ItemGridView extends StatelessWidget {
  final List<Item> items;
  final bool isWideScreen;
  final Function(Item) onItemTap;

  const ItemGridView({
    super.key,
    required this.items,
    required this.isWideScreen,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 5 : 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => ItemCard(item: items[index]),
    );
  }
}
