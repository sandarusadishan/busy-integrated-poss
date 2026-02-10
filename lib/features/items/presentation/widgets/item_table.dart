import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/item.dart';

class ItemTable extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onItemTap;

  const ItemTable({super.key, required this.items, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Container(
          color: AppColors.tableHeader,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: const Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text('Image',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 3,
                  child: Text('Item Name',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('Alias',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('Group',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Price',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 1,
                  child: Text('Qty',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        // Data Rows
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () => onItemTap(item),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 20, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500))),
                      Expanded(flex: 2, child: Text(item.alias)),
                      Expanded(flex: 2, child: Text(item.parentGroup)),
                      Expanded(
                          flex: 1,
                          child: Text(formatPrice(item.price),
                              textAlign: TextAlign.right)),
                      Expanded(
                          flex: 1,
                          child: Text('${item.quantity} ${item.unit}',
                              textAlign: TextAlign.right)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
