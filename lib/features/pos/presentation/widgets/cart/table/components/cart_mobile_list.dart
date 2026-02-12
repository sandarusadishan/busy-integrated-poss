import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/features/pos/presentation/providers/pos_provider.dart';

import 'cart_qty_control.dart';

class CartMobileList extends ConsumerWidget {
  final List<CartItem> cartItems;

  const CartMobileList({super.key, required this.cartItems});

  @override
   Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: cartItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = cartItems[i];
        final total = c.item.price * c.quantity;

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.item.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
                    onPressed: () => ref.read(posCartProvider.notifier).removeItem(c.item),
                  )
                     ,
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  c.item.parentGroup,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CartQtyControl(
                      qty: c.quantity,
                      onMinus: () => ref.read(posCartProvider.notifier).updateQuantity(c.item, -1),
                      onPlus: () => ref.read(posCartProvider.notifier).updateQuantity(c.item, 1),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Price: Rs. ${c.item.price.toStringAsFixed(2)}'),
                        const SizedBox(height: 4),
                        Text(
                          'Total: Rs. ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
