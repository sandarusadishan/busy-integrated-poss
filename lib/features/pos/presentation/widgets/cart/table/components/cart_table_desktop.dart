import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/features/pos/presentation/providers/pos_provider.dart';
import 'cart_table_cells.dart';
import 'cart_qty_control.dart';



class CartTableDesktop extends ConsumerWidget {
  final List<CartItem> cartItems;

  const CartTableDesktop({super.key, required this.cartItems});

  @override
   Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final tableWidth = w - 40; // accounting for padding
        // Responsive widths
        final noW = 1/16 * tableWidth; // 8.3%
        final nameW = 3/16 * tableWidth; // 33.3%
        final qtyW = 3/16 * tableWidth; // 12.5%
        final priceW = 2.5/16 * tableWidth; // 12.5%
        final totalW = 2.5/16 * tableWidth; // 12.5%
        final actionW = 1.5/16 * tableWidth; // 8.3%
        final groupW = 1.5/16 * tableWidth; // 8.3%
    

        final table = Container(
           width: tableWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
        
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    CartTableCells.hCell('No.', noW, center: true),
                    CartTableCells.hCell('Item Name', nameW),
                    CartTableCells.hCell('Group', groupW, center: true),
                    CartTableCells.hCell('Qty', qtyW, center: true),
                    CartTableCells.hCell('Price', priceW, right: true),
                    CartTableCells.hCell('Total', totalW, right: true),
                    CartTableCells.hCell('Actions', actionW, center: true),
                  ],
                ),
              ),

              // BODY
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, i) {
                    final c = cartItems[i];
                    final lineTotal = c.item.price * c.quantity;

                    return Container(
                      height: 64,
                      color: i.isEven ? Colors.white : Colors.grey.shade50,
                      child: Row(
                        children: [
                          CartTableCells.bCell(
                            noW,
                            Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          CartTableCells.bCell(
                            nameW,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  c.item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),

                            CartTableCells.bCell(
                              groupW,
                              Center(
                                child: Text(
                                  c.item.parentGroup,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                          CartTableCells.bCell(
                            qtyW,
                            Center(
                              child: CartQtyControl(
                                qty: c.quantity,
                                onMinus: () => ref.read(posCartProvider.notifier).updateQuantity(c.item, -1),
                                onPlus: () => ref.read(posCartProvider.notifier).updateQuantity(c.item, 1),
                              ),
                            ),
                          ),

                          CartTableCells.bCell(
                            priceW,
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Rs. ${c.item.price.toStringAsFixed(2)}'),
                              ),
                            ),
                          ),

                          CartTableCells.bCell(
                            totalW,
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Rs. ${lineTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          CartTableCells.bCell(
                            actionW,
                            Center(
                              child: IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                                onPressed: () => ref.read(posCartProvider.notifier).removeItem(c.item),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(child: table),
        );
      },
    );
  }

}
