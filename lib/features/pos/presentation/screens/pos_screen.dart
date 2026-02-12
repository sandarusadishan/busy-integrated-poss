import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:busy_items_app/core/constants/app_colors.dart';
import 'package:busy_items_app/features/items/data/models/item.dart';
import 'package:busy_items_app/features/pos/presentation/providers/pos_provider.dart';

import 'package:busy_items_app/features/pos/presentation/widgets/cart/table/main_class/responsive_cart_table.dart';
import 'package:busy_items_app/features/pos/presentation/widgets/cart/bottom_navigation_bar/cart_bottom_navigation_bar.dart';

import 'package:busy_items_app/features/pos/presentation/widgets/items/pos_search_bar_section.dart';
import 'package:busy_items_app/features/pos/presentation/widgets/items/pos_items_grid.dart';

import 'package:printing/printing.dart';
import 'package:busy_items_app/features/pos/presentation/utils/invoice_pdf.dart';


class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedItems = ref.watch(posCartProvider);
    final total = _calculateTotal(selectedItems);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCartDialog(context, ref),
              ),
              if (selectedItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      selectedItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          POSSearchBarSection(
            onItemSelected: (item) => _addItemToCart(item, ref),
          ),
          Expanded(
            child: Column(
              children: [
                const Expanded(
                  flex: 2,
                  child: ResponsiveCartTable(),
                ),
                Expanded(
                  flex: 2,
                  child: POSItemsGrid(
                    onItemTap: (item) => _addItemToCart(item, ref),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CartBottomNavigationBar(
        total: total,
        onCompleteSale: () => _completeSale(ref),
      ),
    );
  }

  void _addItemToCart(Item item, WidgetRef ref) {
    ref.read(posCartProvider.notifier).addItem(item);
    // (search clear is handled inside your search widget now, so no need here)
  }

void _completeSale(WidgetRef ref) async {
  final cartItems = ref.read(posCartProvider);

  if (cartItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add items to cart first')),
    );
    return;
  }

  final subtotal = _calculateTotal(cartItems);

  // Confirm dialog
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Sale'),
      content: Text(
        'Total: Rs. ${subtotal.toStringAsFixed(2)}\nGenerate invoice & print?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Print'),
        ),
      ],
    ),
  );

  if (ok != true) return;

  final now = DateTime.now();
  final invoiceNo =
      'INV-${now.millisecondsSinceEpoch.toString().substring(7)}';

  // Build PDF bytes (your invoice builder)
  final pdfBytes = await InvoicePdfHps.buildPdfBytes(
    items: cartItems,
    invoiceNo: invoiceNo,
    dateTime: now,
    customerName: "Walk-In Customer",
    mobile: "",
    subtotal: subtotal,
    totalPaid: subtotal,
    paymentLabel: "Cash",
    companyName: "SOFTVISION IT GROUP (PVT) LTD",
    addressLine: "Colombo, Colombo, Colombo, 122, SriLanka",
  );

  // Print (Web opens print dialog)
  await Printing.layoutPdf(onLayout: (_) async => pdfBytes);

  // Clear cart after printing
  ref.read(posCartProvider.notifier).clearCart();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Invoice $invoiceNo printed. Sale completed!')),
  );
}

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, cartItem) {
      return sum + (cartItem.item.price * cartItem.quantity);
    });
  }

  void _showCartDialog(BuildContext context, WidgetRef ref) {
    // TODO: implement cart dialog if needed
  }
}
