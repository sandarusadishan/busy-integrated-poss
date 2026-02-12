import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:busy_items_app/core/constants/app_colors.dart';

class CartBottomNavigationBar extends ConsumerWidget {
  final double total;
  final VoidCallback onCompleteSale;

  const CartBottomNavigationBar({
    super.key,
    required this.total,
    required this.onCompleteSale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.25)),
              ),
              color: Colors.white.withOpacity(0.12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT - Button
                ElevatedButton.icon(
                  onPressed: onCompleteSale,
                  icon: const Icon(Icons.payment),
                  label: const Text("Complete Sale"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // RIGHT - Total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                    Text(
                      "Rs. ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
