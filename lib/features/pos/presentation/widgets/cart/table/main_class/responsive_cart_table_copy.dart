import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/features/pos/presentation/providers/pos_provider.dart';

class ResponsiveCartTable extends ConsumerWidget {
  const ResponsiveCartTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(posCartProvider);

    if (cartItems.isEmpty) {
      return _emptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        final isPhone = w < 600; // iPhone 12
        return Column(
          children: [
            Expanded(
              child: isPhone
                  ? _mobileCartList(cartItems, ref)
                  : _tabletDesktopResponsiveTable(cartItems, ref),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // MOBILE (Card/List)
  // =========================
  Widget _mobileCartList(List<CartItem> cartItems, WidgetRef ref) {
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
                    _qtyControl(
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

  // =========================
  // TABLET + DESKTOP (Responsive Table)
  // =========================
  Widget _tabletDesktopResponsiveTable(List<CartItem> cartItems, WidgetRef ref) {
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
                    _hCell('No.', noW, center: true),
                    _hCell('Item Name', nameW),
                    _hCell('Group', groupW, center: true),
                    _hCell('Qty', qtyW, center: true),
                    _hCell('Price', priceW, right: true),
                    _hCell('Total', totalW, right: true),
                    _hCell('Actions', actionW, center: true),
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
                          _bCell(
                            noW,
                            Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          _bCell(
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

                            _bCell(
                              groupW,
                              Center(
                                child: Text(
                                  c.item.parentGroup,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                          _bCell(
                            qtyW,
                            Center(
                              child: _qtyControl(
                                qty: c.quantity,
                                onMinus: () => ref.read(posCartProvider.notifier).updateQuantity(c.item, -1),
                                onPlus: () => ref.read(posCartProvider.notifier).updateQuantity(c.item, 1),
                              ),
                            ),
                          ),

                          _bCell(
                            priceW,
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Rs. ${c.item.price.toStringAsFixed(2)}'),
                              ),
                            ),
                          ),

                          _bCell(
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

                          _bCell(
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

  // =========================
  // Shared UI Helpers
  // =========================
  Widget _hCell(String text, double width, {bool center = false, bool right = false}) {
    return SizedBox(
      width: width,
      height: double.infinity,
      child: Align(
        alignment: right
            ? Alignment.centerRight
            : center
                ? Alignment.center
                : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
          ),
        ),
      ),
    );
  }

  Widget _bCell(double width, Widget child) {
    return SizedBox(width: width, height: double.infinity, child: child);
  }

 Widget _qtyControl({
  required int qty,
  required VoidCallback onMinus,
  required VoidCallback onPlus,
}) {
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
          _qtyBtn(Icons.remove, onMinus),
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
          _qtyBtn(Icons.add, onPlus),
        ],
      ),
    ),
  );
}


  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
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

  Widget _emptyState() {
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
