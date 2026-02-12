import 'package:flutter/material.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

@override
Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            const Text('Cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Search and add items to get started'),
          ],
        ),
      ),
    );
  }
}
