import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:busy_items_app/features/pos/presentation/providers/pos_provider.dart';
import 'package:busy_items_app/features/pos/presentation/widgets/cart/table/components/cart_mobile_list.dart';
import 'package:busy_items_app/features/pos/presentation/widgets/cart/table/components/cart_table_desktop.dart';
import 'package:busy_items_app/features/pos/presentation/widgets/cart/table/components/cart_empty_state.dart';

class ResponsiveCartTable extends ConsumerWidget {
  const ResponsiveCartTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(posCartProvider);

    if (cartItems.isEmpty) {
      return const CartEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {

        final w = constraints.maxWidth;
        final isPhone = w < 600; // iPhone 12

        return Column(
          children: [
            Expanded(
              child: isPhone
                  ? CartMobileList(cartItems: cartItems)
                  : CartTableDesktop(cartItems: cartItems),
            ),
          ],
        );
      },
    );
  }

}
