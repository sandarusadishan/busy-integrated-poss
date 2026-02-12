import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/features/items/data/models/item.dart';

class CartItem {
  final Item item;
  final int quantity;

  const CartItem({
    required this.item,
    this.quantity = 1,
  });

  CartItem copyWith({Item? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }
}

final posCartProvider = NotifierProvider<POSCartNotifier, List<CartItem>>(
  POSCartNotifier.new,
);

class POSCartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addItem(Item item) {
    final index = state.indexWhere((c) => c.item.name == item.name);

    if (index != -1) {
      state = [
        for (final c in state)
          if (c.item.name == item.name)
            c.copyWith(quantity: c.quantity + 1)
          else
            c
      ];
    } else {
      state = [...state, CartItem(item: item)];
    }
  }

  void updateQuantity(Item item, int delta) {
    state = state
        .map((c) {
          if (c.item.name != item.name) return c;

          final newQty = c.quantity + delta;
          if (newQty <= 0) return null;

          return c.copyWith(quantity: newQty);
        })
        .whereType<CartItem>()
        .toList();
  }

  void removeItem(Item item) {
    state = state.where((c) => c.item.name != item.name).toList();
  }

  void clearCart() {
    state = [];
  }
}
