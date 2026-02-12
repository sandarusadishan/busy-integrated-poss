import 'package:flutter/material.dart';

class CartQtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const CartQtyControl({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _btn(Icons.remove, onMinus),
            const SizedBox(width: 10),
            SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  '$qty',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _btn(Icons.add, onPlus),
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade300),
        ),
        child: Icon(icon, size: 18, color: Colors.blue.shade700),
      ),
    );
  }
}
